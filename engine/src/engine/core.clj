(ns engine.core
  (:require [engine.object-utils :as obj])
  (:require [engine.commands :as cmd :refer [add-command]])
  (:require [engine.transformations :refer [transform-coords distance]])
  (:require [engine.utils :refer [deep-merge]]))

(defn pass
  "Dummy handler that does nothing and returns game."
  [g &more]
  g)

(defn create-player
  [team gold]
  {:gold gold :team team :status :active})

(defn add-player
  "Adds a player with a given number p and player data."
  [g p player-data]
  (assoc-in g [:players p] player-data))

(defn set-object-placement
  "Updates object flip, rotation (if given and not nil) and position."
  ([obj position] (set-object-placement obj nil nil position))
  ([obj flip rotation position]
   (cond-> obj
     true (assoc :position position)
     flip (assoc :flip flip)
     rotation (assoc :rotation rotation))))

(defn transform-coords-map
  "Transforms every key in coords (every key should be a coord)."
  [coords flip rotation position]
  (zipmap
   (transform-coords (keys coords) flip rotation position)
   (vals coords)))

(defn get-object-coords-map
  [obj]
  (let [coords (obj :coords)]
    (transform-coords-map coords (obj :flip) (obj :rotation) (obj :position))))

(defn place-object-on-board
  [g obj-id]
  (let [obj (get-in g [:objects obj-id])
        obj-coords (get-object-coords-map obj)
        board-data (into {}
                         (map
                          (fn [[k v]] [k {obj-id v}])
                          obj-coords))]
    (update g :board deep-merge board-data)))

(defn add-object
  "Adds a new object to the game."
  ([g p obj position] (add-object g p obj nil nil position))
  ([g p obj flip rotation position]
   (let [owned-obj (assoc obj :player p)
         new-obj (set-object-placement owned-obj flip rotation position)
         new-obj-id (g :next-object-id)]
     (-> g
         (assoc-in [:objects new-obj-id] new-obj)
         (update :next-object-id inc)
         (place-object-on-board new-obj-id)
         (add-command (cmd/add-obj new-obj-id new-obj))))))

(defn remove-object-coords
  "Removes object from board"
  [g obj-id]
  (let [obj (get-in g [:objects obj-id])
        obj-coords (keys (get-object-coords-map obj))]
    (reduce
     (fn [game coord]
       (update-in game [:board coord] dissoc obj-id))
     g
     obj-coords)))

(defn remove-object
  "Removes object from the game."
  [g obj-id]
  (-> g
      (remove-object-coords obj-id)
      (update-in [:objects] dissoc obj-id)
      (add-command (cmd/remove-obj obj-id))))

(defn coord-params-compatible?
  [p1 p2]
  (assert (seq p1))
  (assert (seq p2))
  (let [fills (set [(p1 :fill) (p2 :fill)])]
    (= fills #{:unit :floor})))

(defn can-add-coordinate?
  [g [coord params]]
  (let [current-objs (get-in g [:board coord])
        current-params (vals current-objs)]
    (and current-objs
         (every? #(coord-params-compatible? params %) current-params))))

(defn can-place-object?
  [g obj]
  (let [coords (get-object-coords-map obj)]
    (every? #(can-add-coordinate? g %) coords)))

(defn assert-can-place-object
  [g obj]
  (assert (can-place-object? g obj)
          (str "Object " obj " cannot be placed on the board"))
  g)

(defn can-move-object?
  "Checks if the object can be moved to the given position."
  ([g obj-id position] (can-move-object? g obj-id nil nil position))
  ([g obj-id flip rotation position]
   (let [obj (get-in g [:objects obj-id])
         moved-obj (set-object-placement obj flip rotation position)]
     (can-place-object?
      (remove-object-coords g obj-id)
      moved-obj))))

(defn move-object
  "Moves object to the given position.
  Assumes that it is a valid move."
  ([g obj-id position] (move-object g obj-id nil nil position))
  ([g obj-id flip rotation position]
   (let [obj (get-in g [:objects obj-id])
         moved-obj (set-object-placement obj flip rotation position)]
     (-> g
         (remove-object-coords obj-id)
         (assoc-in [:objects obj-id] moved-obj)
         (assert-can-place-object moved-obj)
         (place-object-on-board obj-id)
         (add-command (cmd/move-obj obj-id obj moved-obj))))))

(defn get-objects
  "Returns map id->object for all objects that satisfy pred."
  [g pred]
  (into {} (filter #(-> % val pred) (g :objects))))

(defn update-object
  "Performs function f on object and adds a command created by cmd-f.
  Function cmd-f should have signature [obj-id obj-old obj-new]."
  [g obj-id f cmd-f]
  (let [obj (get-in g [:objects obj-id])
        updated-obj (f obj)]
    (if (not= obj updated-obj)
      (-> g
          (assoc-in [:objects obj-id] updated-obj)
          (add-command (cmd-f obj-id obj updated-obj)))
      g)))

(defn update-objects
  "Performs function f on every object in the game that satisfies pred.
  For every update also adds a command (cmd-f obj-id obj-old obj-new)."
  [g pred f cmd-f]
  (reduce
   (fn [game obj-id]
     (update-object game obj-id f cmd-f))
   g
   (keys (get-objects g pred))))


(defn set-active-player
  "Sets turn to player p and activetes all their objects."
  [g p]
  (let [belongs-to-p? (partial obj/belongs-to? p)]
    (-> g
        (assoc :active-player p)
        (update-objects (complement belongs-to-p?) obj/deactivate cmd/set-moves)
        (update-objects belongs-to-p? obj/activate cmd/set-moves)
        ;; TODO income, building effects etc.
        (add-command (cmd/set-active-player p)))))

(defn get-next-player
  "Returns player number whose turn is after p."
  [g p]
  (let [player-pos (.indexOf (g :turn-order) p)
        next-pos (mod (inc player-pos) (count (g :turn-order)))]
    (assert (>= player-pos 0))
    (get-in g [:turn-order next-pos])))

(defn set-next-player-active
  [g]
  (let [p (g :active-player)
        next-p (get-next-player g p)]
    (set-active-player g next-p)))

(defn has-active-objects?
  [g p]
  (seq
   (get-objects g #(and (obj/belongs-to? p %) (obj/active? %)))))

(defn filled-cell?
  [[coord properties]]
  (not= :floor (properties :fill)))

(defn obj-distance
  "Returns minimal distance between two objects.
  Counts only filled cells (except :floor)"
  [obj1 obj2]
  (let [coords1 (keys (filter filled-cell? (get-object-coords-map obj1)))
        coords2 (keys (filter filled-cell? (get-object-coords-map obj2)))]
    (apply min
           (for [c1 coords1 c2 coords2]
             (distance c1 c2)))))

(defn get-object-id-at
  "Gets object id at a given coordinate."
  [g coord]
  (let [obj-ids (keys (filter filled-cell? (get-in g [:board coord])))]
    (assert (<= 0 (count obj-ids) 1))
    (first obj-ids))
  )

(defn get-object-at
  "Gets object at a given coordinate."
  [g coord]
  (let [obj-id (get-object-id-at g coord)]
    (get-in g [:objects obj-id])))

(defn player-lost
  [g p]
  (-> g
      (add-command (cmd/player-lost p))
      (assoc-in [:players p :status] :lost)))

(defn player-won
  [g p]
  (-> g
      (add-command (cmd/player-won p))
      (assoc-in [:players p :status] :won)))


(defn destruction-reward
  "Give playe p reward for destroying object."
  [g obj-id p]
  (let [reward (get-in g [:objects obj-id :reward])]
    (if reward
      (-> g
          (update-in [:players p :gold] + reward)
          (add-command (cmd/change-gold p reward obj-id)))
      g)))

(defn destroy-obj
  "Destroys an object, p is a player who destroyed it."
  [g obj-id p]
  (let [obj (get-in g [:objects obj-id])
        destruction-handler (get-in obj [:handlers :on-destruction]
                                    pass)]
    (-> g
        (destruction-handler obj-id)
        (destruction-reward obj-id p)
        (add-command (cmd/destroy-obj obj-id))
        (remove-object obj-id))))

(defn damage-obj
  "Deals damage to an object."
  [g obj-id p damage]
  (let [health (get-in g [:objects obj-id :health])
        health-after (- health damage)]
    (if (pos? health-after)
      (update-object g obj-id #(obj/set-health % health-after) cmd/set-health)
      (destroy-obj g obj-id p))))

(defn end-game
  "Marks game as over."
  [g]
  (-> g
      (assoc :status :over)
      (add-command (cmd/game-over))))


(defn activate
  "Refills object moves."
  [obj]
  (if (obj :moves)
    (assoc obj :moves (obj :max-moves))
    obj))

(defn deactivate
  "Sets object moves to zero."
  [obj]
  (if (obj :moves)
    (assoc obj :moves 0)
    obj))

(defn active?
  [obj]
  (pos? (or (obj :moves) 0)))

(defn belongs-to?
  "Checks if obj belongs to player p."
  [p obj]
  (= p (obj :player)))

(defn set-health
  "Sets health."
  [obj health]
  {:pre [(pos? health)]}
  (assoc obj :health health))
