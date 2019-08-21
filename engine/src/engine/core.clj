(ns engine.core
  (:require [engine.object-dic :refer [objects]])
  (:require [engine.objects :as obj])
  (:require [engine.commands :as cmd :refer [add-command]])
  (:require [engine.transformations :refer [transform-coords]])
  (:require [engine.utils :refer [deep-merge]]))

(def board-size-x 20)
(def board-size-y 20)

(defn create-empty-board
  [size-x size-y]
  (zipmap (for [x (range size-x) y (range size-y)] [x y]) (repeat {})))

(defn create-empty-game []
  {:board
   (create-empty-board board-size-x board-size-y)
   :players {}
   :turn-order []
   :active-player nil
   :objects {}
   :actions []
   :commands []
   :next-object-id 0})

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

(defn create-new-object
  "Creates and returns a new object of type obj-key with player p at given position optionally with flip and rotation."
  ([p obj-key position] (create-new-object p obj-key nil nil position))
  ([p obj-key flip rotation position]
   (as-> (objects obj-key) obj
     (dissoc obj :coords)
     (assoc obj :player p)
     (assoc obj :type obj-key)
     (if (obj :max-moves)
       (assoc obj :moves 0)
       obj)
     (set-object-placement obj flip rotation position))))

(defn transform-coords-map
  "Transforms every key in coords (every key should be a coord)."
  [coords flip rotation position]
  (zipmap
   (transform-coords (keys coords) flip rotation position)
   (vals coords)))

(defn get-object-coords-map
  [obj]
  (let [obj-key (obj :type)
        coords (get-in objects [obj-key :coords])]
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
  ([g p obj-key position] (add-object g p obj-key nil nil position))
  ([g p obj-key flip rotation position]
   {:pre [(contains? objects obj-key)
          (contains? (g :players) p)]}
   (let [new-obj (create-new-object p obj-key flip rotation position)
         new-obj-id (g :next-object-id)
         ]
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
      (update-in [:objects] dissoc obj-id)
      (remove-object-coords obj-id)
      (add-command (cmd/remove-obj obj-id))))

(defn coord-params-compatible
  [p1 p2]
  (let [fills (set [(p1 :fill) (p2 :fill)])]
    (= fills #{:unit :floor})))

(defn can-add-coordinate
  [g [coord params]]
  (let [current-params (vals (get-in g [:board coord]))]
    (and current-params
         (every? #(coord-params-compatible params %) current-params))))

(defn can-place-object?
  [g obj]
  (let [coords (get-object-coords-map obj)]
    (every? #(can-add-coordinate g %) coords)))

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

(defn create-new-game []
  (-> (create-empty-game)
      (add-player 0 {:gold 100 :team 0})
      (add-player 2 {:gold 100 :team 1})
      (update :turn-order conj 0 2)
      (add-object 0 :castle 0 0 [0 0])
      (add-object 0 :spearman [2 0])
      (add-object 0 :spearman [0 2])
      (add-object 2 :castle 0 2 [(dec board-size-x) (dec board-size-y)])
      (add-object 2 :spearman [(dec board-size-x) (- board-size-y 3)])
      (add-object 2 :spearman [(- board-size-x 3) (dec board-size-y)])
      (set-active-player 0)))
