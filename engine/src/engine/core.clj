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
       obj))))

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
    (every? #(coord-params-compatible params %) current-params)))

(defn can-place-object?
  [g obj]
  (let [coords (get-object-coords-map obj)]
    (every? #(can-add-coordinate g %) coords)))

(defn assert-can-place-object
  [g obj]
  (assert (can-place-object? g obj)
          (str "Object " obj " cannot be placed on the board"))
  g)

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

(defn update-objects
  "Performs function f on every object in the game that satisfies pred."
  [g f pred]
  (reduce
   (fn [game obj]
     (update-in game [:objects obj] f))
   g
   (map first 
        (filter #(pred (second %)) (g :objects)))))

(defn set-turn
  "Sets turn to player p.
  Activates all their objects and deactivates all other's objects."
  [g p]
  (let [belongs-to-p? (partial obj/belongs-to? p)]
    (-> g
        (assoc :active-player p)
        (update-objects obj/deactivate (comp belongs-to-p?))
        (update-objects obj/activate belongs-to-p?))))

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
      (set-turn 0)))
