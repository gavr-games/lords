(ns engine.actions
  (:require [engine.object-utils :as obj])
  (:require [engine.core :refer :all])
  (:require [engine.commands :as cmd :refer [add-command]])
  (:require [engine.transformations :refer [distance]]))

(defn check-game
  [g]
  (cond
    (nil? g) :invalid-game
    (= :over (g :status)) :game-over))

(defn check-player
  [g p]
  (let [player (get-in g [:players p])]
    (cond
      (nil? player) :invalid-player
      (not= :active (player :status)) :player-not-active)))

(defn check-object-action
  "Checks that player can do given action on the object."
  [g p obj-id action]
  (let [obj (get-in g [:objects obj-id])]
    (cond
      (not obj) :invalid-obj-id
      (not= p (obj :player)) :not-owner
      (zero? (or (obj :moves) 0)) :object-inactive
      ;; TODO test paralysis
      (not (get-in obj [:actions action])) :invalid-action)))

(defn check-coord-one-step-away
  [obj coord]
  (let [obj-current-coords (keys (get-object-coords-map obj))
        dist-one? #(= 1 (distance % coord))]
    (if (not-any? dist-one? obj-current-coords)
      :target-coord-not-reachable))) ;; TODO knight

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
   (check-valid-coord g new-position)
   (check-coord-one-step-away (get-in g [:objects obj-id]) new-position)
   (check-can-move-to g obj-id new-position)))

(defn check-my-turn
  [g p]
  (if (not= p (g :active-player))
    :not-your-turn))

(defn move
  [g p obj-id new-position]
  (as-> g game
    (update-object game obj-id #(update % :moves dec) cmd/set-moves)
    (move-object game p obj-id new-position)))

(defn end-turn
  [g p]
  (-> g
      (add-command (cmd/end-turn p))
      (set-next-player-active)))

(defn check-valid-attack-target
  [g target-id]
  (if (not (get-in g [:objects target-id :health]))
    :invalid-attack-target))

(defn check-obj-one-step-away
  [o1 o2]
  (if (not= 1 (obj-distance o1 o2))
    :target-object-is-not-reachable))

(defn check-attack
  [g p obj-id target-id]
  (or
   (check-object-action g p obj-id :attack)
   (check-valid-attack-target g target-id)
   (check-obj-one-step-away
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))))

(defn attack
  [g p obj-id target-id]
  (let [damage (get-in g [:objects obj-id :attack])]
    (-> g
        (update-object obj-id obj/deactivate cmd/set-moves)
        (add-command (cmd/attack obj-id target-id damage))
        (damage-obj target-id p damage))))

(def actions-dic
  {:move {:check check-move
          :do move
          :params [:obj-id :new-position]}
   :end-turn {:check check-my-turn
              :do end-turn
              :params []}
   :attack {:check check-attack
            :do attack
            :params [:obj-id :target-id]}
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

(defn check
  "Checks if an action can be performed.
  Returns nil (on valid action) or error.
  Params should be a map of keyword arguments."
  [g p action params]
  (let [check-fn (get-in actions-dic [action :check])
        param-keys (get-in actions-dic [action :params])
        param-values (vals (select-keys params param-keys))]
    (or
     (check-game g)
     (check-player g p)
     (apply check-fn g p param-values))))

(defn act
  "Performs action and returns the resulting game state.
  Assumes that the action is valid.
  Params should be a map of keyword arguments."
  [g p action params]
  (let [act-fn (get-in actions-dic [action :do])
        param-keys (get-in actions-dic [action :params])
        param-values (vals (select-keys params param-keys))
        act-call #(apply (auto-end-turn act-fn) % p param-values)
        action-log {:player p :action action :params params}]
    (-> g
        (update-in [:actions] conj action-log)
        act-call)))

(defn check-and-act
  "Performs check and action. Returns error or resulting state of the game.
  Params should be a map of keyword arguments."
  [g p action params]
  (or (check g p action params)
      (act g p action params)))
