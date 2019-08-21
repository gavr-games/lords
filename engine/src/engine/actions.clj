(ns engine.actions
  (:require [engine.object-dic :refer [objects]])
  (:require [engine.core :refer :all])
  (:require [engine.commands :as cmd :refer [add-command]])
  (:require [engine.transformations :refer [distance]]))


(defn check-object-action
  "Checks that player can do given action on the object."
  [g p obj-id action]
  (let [obj (get-in g [:objects obj-id])]
    (cond
      (not obj) :invalid-obj-id
      (not= p (obj :player)) :not-owner
      (zero? (or (obj :moves) 0)) :object-inactive
      ;; TODO test paralysis
      (not (get-in objects [(obj :type) :actions action])) :invalid-action)))

(defn check-one-step-away
  [obj coord]
  (let [obj-current-coords (keys (get-object-coords-map obj))
        dist-one? #(= 1 (distance % coord))]
    (if (not-any? dist-one? obj-current-coords)
      :target-not-reachable))) ;; TODO knight

(defn check-valid-coord
  [g coord]
  (if (not (get-in g [:board coord]))
    :invalid-coord))

(defn check-can-move-to
  [g obj-id position]
  (if (not (can-move-object? g obj-id position))
    :place-occupied))

(defn check-move
  [g p obj-id new-position]
  (or
   (check-object-action g p obj-id :move)
   (check-valid-coord g) new-position
   (check-one-step-away (get-in g [:objects obj-id]) new-position)
   (check-can-move-to g obj-id new-position)))

(defn check-my-turn
  [g p]
  (if (not= p (g :active-player))
    :not-your-turn))

(defn move
  [g p obj-id new-position]
  (as-> g game
    ;; TODO remove bind target
    (move-object game obj-id new-position)
    (update-object game obj-id #(update % :moves dec) cmd/set-moves)
    ;; TODO move bound unit
    ))

(defn end-turn
  [g p]
  (-> g
      (add-command (cmd/end-turn p))
      (set-next-player-active)))

(defn attack [] nil)

(def actions-dic
  {:move {:check check-move
          :do move}
   :end-turn {:check check-my-turn
              :do end-turn}
   })

(defn auto-end-turn
  "Performs action and if current player has no active objects, ends turn."
  [f]
  (fn
    ([g p & params]
     (let [g-after (apply f g p params)]
       (if (and
            (= p (g-after :active-player))
            (not (has-active-objects? g-after p)))
         (set-next-player-active g-after)
         g-after)))))

(defn act
  "Performs check and action. Returns error or resulting state of the game."
  [g p action & params]
  (let [check-fn (get-in actions-dic [action :check])
        act-fn (get-in actions-dic [action :do])]
    (or (apply check-fn g p params)
        (apply (auto-end-turn act-fn) g p params))))
