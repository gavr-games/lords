(ns engine.core
  (:require [engine.object-utils :as obj]
            [clojure.set :as set])
  (:require [engine.commands :as cmd])
  (:require [engine.transformations :refer [transform-coords distance]])
  (:require [engine.utils :refer [deep-merge]]))

(defmulti
  handler
  "Generic handler differentiated by a keyword code."
  identity)

(defmacro create-handler
  "Creates and registers given handler method for the given code.
  Handler should have arguments [game object-id & h-args]."
  [code & fn-tail]
  `(defmethod handler ~code
     [_#]
     (fn ~@fn-tail)))

(defn- pass
  "Dummy handler that does nothing and returns first argument."
  [g & more]
  g)

(defn- chain-handlers
  "Chains two handlers."
  [h1 h2]
  (fn [g & more]
    (apply h2 (apply h1 g more) more)))

(defn- get-handler
  [obj event]
  (let [handlers (get-in obj [:handlers event])]
    (if (seq handlers)
      (reduce chain-handlers (map handler handlers))
      pass)))

(defn handle
  "Gets the approppriate handler for the object and calls it
  with arguments [g obj-id & h-args]."
  [g obj-id event & h-args]
  (let [obj (get-in g [:objects obj-id])
        handler-fn (get-handler obj event)]
    (apply handler-fn g obj-id h-args)))


(defn add-handler
  [g obj-id event handler-code]
  (update-in g [:objects obj-id :handlers event] conj handler-code))


(defn remove-handler
  [g obj-id event handler-code]
  (update-in g [:objects obj-id :handlers event] #(remove #{handler-code} %)))


(defn create-player
  [team gold]
  {:gold gold :team team :status :active})

(defn add-player
  "Adds a player with a given number p and player data."
  [g p player-data]
  (assoc-in g [:players p] player-data))

(defn set-object-placement
  "Updates object flip, rotation (if given and not nil) and position."
  ([obj position] (set-object-placement obj position nil nil))
  ([obj position flip rotation]
   (cond-> obj
     true (assoc :position position)
     flip (assoc :flip flip)
     rotation (assoc :rotation rotation))))

(defn transform-coords-map
  "Transforms every key in coords (every key should be a coord)."
  [coords position flip rotation]
  (zipmap
   (transform-coords (keys coords) flip rotation position)
   (vals coords)))

(defn get-object-coords-map
  "Returns a map from coord to its parameters.
  Example output for castle:
  {(0 0) {:fill :solid},
  (0 1) {:fill :solid},
  (1 0) {:fill :solid},
  (1 1) {:fill :floor, :spawn true}}"
  [obj]
  (let [coords (obj :coords)]
    (transform-coords-map coords (obj :position) (obj :flip) (obj :rotation))))

(defn place-object-on-board
  [g obj-id]
  (let [obj (get-in g [:objects obj-id])
        obj-coords (get-object-coords-map obj)
        board-data (into {}
                         (map
                          (fn [[k v]] [k {obj-id v}])
                          obj-coords))]
    (update g :board deep-merge board-data)))

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
      (cmd/add-command (cmd/remove-obj obj-id))))


(defn get-fills-in-cell
  "Returns a set of fills of all objects in the given coordinate."
  [g coord]
  (set (map :fill
            (vals (get-in g [:board coord])))))

(defn can-add-fill?
  "Checks if the new fill can be added to a set of existing fills."
  [new-fill fills]
  (case new-fill
    :unit (empty? (set/intersection fills #{:solid :unit}))
    :bridge (= fills #{:water})
    (empty? fills)))

(defn can-add-coordinate?
  [g [coord params]]
  (can-add-fill? (params :fill) (get-fills-in-cell g coord)))

(defn can-place-object?
  [g obj]
  (let [coords (get-object-coords-map obj)]
    (every? #(can-add-coordinate? g %) coords)))

(defn assert-can-place-object
  [g obj]
  (assert (can-place-object? g obj)
          (str "Object " obj " cannot be placed on the board"))
  g)

(defn add-object
  "Adds a new object to the game.
  Assumes that the placement is valid."
  ([g obj position] (add-object g nil obj position nil nil))
  ([g obj position flip rotation] (add-object g nil obj position flip rotation))
  ([g p obj position] (add-object g p obj position nil nil))
  ([g p obj position flip rotation]
   (let [owned-obj (if p (assoc obj :player p) obj)
         new-obj (set-object-placement owned-obj position flip rotation)
         new-obj-id (g :next-object-id)]
     (-> g
         (assert-can-place-object new-obj)
         (assoc-in [:objects new-obj-id] new-obj)
         (update :next-object-id inc)
         (place-object-on-board new-obj-id)
         (cmd/add-command (cmd/add-obj new-obj-id new-obj))))))

(defn can-move-object?
  "Checks if the object can be moved to the given position."
  ([g obj-id position] (can-move-object? g obj-id position nil nil))
  ([g obj-id position flip rotation]
   (let [obj (get-in g [:objects obj-id])
         moved-obj (set-object-placement obj position flip rotation)]
     (can-place-object?
      (remove-object-coords g obj-id)
      moved-obj))))

(defn on-water?
  "Checks if object stands on water with at least one cell."
  [g obj-id]
  (let [obj (get-in g [:objects obj-id])
        cells (keys (get-object-coords-map obj))]
    (some #(and (:water %) (not (:bridge %)))
          (map #(get-fills-in-cell g %) cells))))

(defn destruction-reward
  "Give playe p reward for destroying object."
  [g obj-id p]
  (let [reward (get-in g [:objects obj-id :reward])]
    (if reward
      (-> g
          (update-in [:players p :gold] + reward)
          (cmd/add-command (cmd/change-gold p reward obj-id)))
      g)))


(defn destroy-obj
  "Destroys an object, p is a player who destroyed it."
  [g p obj-id]
  (-> g
      (handle obj-id :before-destruction)
      (destruction-reward obj-id p)
      (cmd/add-command (cmd/destroy-obj obj-id))
      (remove-object obj-id)))

(defn drown-object
  [g p obj-id]
  (-> g
      (cmd/add-command (cmd/drown-obj obj-id))
      (destroy-obj p obj-id)))

(defn drown-handler
  [g p obj-id]
  (let [obj (get-in g [:objects obj-id])]
    (if (and (on-water? g obj-id)
             (not (:waterwalking obj)))
      (drown-object g p obj-id)
      g)))


(defn move-object
  "Moves object to the given position.
  Assumes that it is a valid move."
  ([g p obj-id position] (move-object g p obj-id position nil nil))
  ([g p obj-id position flip rotation]
   (let [obj (get-in g [:objects obj-id])
         old-position (obj :position)
         old-flip (obj :flip)
         old-rotation (obj :rotation)
         moved-obj (set-object-placement obj position flip rotation)]
     (-> g
         (remove-object-coords obj-id)
         (assoc-in [:objects obj-id] moved-obj)
         (assert-can-place-object moved-obj)
         (place-object-on-board obj-id)
         (cmd/add-command (cmd/move-obj obj-id obj moved-obj))
         (handle obj-id :after-moved
                 old-position position
                 old-flip flip
                 old-rotation rotation)
         (drown-handler p obj-id)))))

(defn get-objects
  "Returns map id->object for all objects that satisfy pred."
  [g pred]
  (into {} (filter #(-> % val pred) (g :objects))))

(defn update-object
  "Performs function f on object and optionally adds a command created by cmd-f.
  Function cmd-f should have signature [obj-id obj-old obj-new]."
  ([g obj-id f] (update-object g obj-id f nil))
  ([g obj-id f cmd-f]
   (let [obj (get-in g [:objects obj-id])
         updated-obj (f obj)]
     (if (not= obj updated-obj)
       (as-> g game
         (assoc-in game [:objects obj-id] updated-obj)
         (if cmd-f
           (cmd/add-command game (cmd-f obj-id obj updated-obj))
           game))
       g))))

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
        (cmd/add-command (cmd/set-active-player p)))))

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
  (not (#{:floor :bridge} (properties :fill))))

(defn obj-distance
  "Returns minimal distance between two objects.
  Counts only filled cells."
  [obj1 obj2]
  (let [coords1 (keys (filter filled-cell? (get-object-coords-map obj1)))
        coords2 (keys (filter filled-cell? (get-object-coords-map obj2)))]
    (apply min
           (for [c1 coords1 c2 coords2]
             (distance c1 c2)))))

(defn get-object-id-at
  "Gets id of the filling object at a given coordinate."
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
      (cmd/add-command (cmd/player-lost p))
      (assoc-in [:players p :status] :lost)))

(defn player-won
  [g p]
  (-> g
      (cmd/add-command (cmd/player-won p))
      (assoc-in [:players p :status] :won)))

(defn damage-obj
  "Deals damage to an object."
  [g p obj-id damage]
  (let [health (get-in g [:objects obj-id :health])
        health-after (- health damage)]
    (if (pos? health-after)
      (update-object g obj-id #(obj/set-health % health-after) cmd/set-health)
      (destroy-obj g p obj-id))))

(defn end-game
  "Marks game as over."
  [g]
  (-> g
      (assoc :status :over)
      (cmd/add-command (cmd/game-over))))


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


(defn add-experience
  "Adds experience to the object."
  [g obj-id experience]
  (update-object g obj-id
                 #(obj/add-experience % experience) cmd/set-experience))
