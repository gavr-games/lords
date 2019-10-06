(ns engine.actions
  (:require [engine.object-utils :as obj-utils])
  (:require [engine.core :refer :all])
  (:require [engine.commands :as cmd :refer [add-command]])
  (:require [engine.transformations :refer [distance]])
  (:require [engine.attack :refer [get-attack-params]]))


(defmulti
  action
  "Player action distinguished by a keyword code."
  identity)

(defmacro create-action
  "Creates and registers action method for the given code.
  Action method should take game and player-num as first two arguments.
  This method should either return a keyword for an error, or a modified game."
  [code args body]
  `(defmethod action ~code
     [_#]
     (with-meta
       (fn ~args ~body)
       {:args ~(mapv keyword (drop 2 args))})))


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


(defn auto-end-turn
  "Ends turn if p is active and does not have active objects."
  [g p]
  (if
      (and
       (= p (g :active-player))
       (not (has-active-objects? g p)))
    (set-next-player-active g)
    g))


(defn act
  "Performs action and returns the resulting game state or error keyword.
  Params should be a map of keyword arguments."
  [g p action-code params]
  (let [act-fn (action action-code)
        param-keys ((meta act-fn) :args)
        param-values (vals (select-keys params param-keys))
        act-call #(apply act-fn % p param-values)
        action-log {:player p :action action :params params}
        prechecks-fail (or
                        (check-game g)
                        (check-player g p))]
    (or
     prechecks-fail
     (let [g-after (-> g
                       (update-in [:actions] conj action-log)
                       act-call)
           invalid-action (keyword? g-after)]
       (if invalid-action
         g-after
         (auto-end-turn g-after p))))))

(defn check
  "Checks if an action can be performed.
  Returns nil (on valid action) or error keyword.
  Params should be a map of keyword arguments."
  [g p action-code params]
  (let [g-after (act g p action-code params)]
    (if (keyword? g-after)
      g-after
      nil)))


(defn check-object-action
  "Checks that player can do given action on the object."
  [g p obj-id action-code]
  (let [obj (get-in g [:objects obj-id])]
    (cond
      (not obj) :invalid-obj-id
      (not= p (obj :player)) :not-owner
      (zero? (or (obj :moves) 0)) :object-inactive
      ;; TODO test paralysis
      (not (get-in obj [:actions action-code])) :invalid-action)))

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


(defn check-valid-attack-target
  [g target-id]
  (if (not (get-in g [:objects target-id :health]))
    :invalid-attack-target))

(defn check-obj-one-step-away
  "Checks that o1 can step on o2 in one step."
  [o1 o2]
  (if (not= 1 (obj-distance o1 o2))
    :target-object-is-not-reachable)) ;TODO knight


(defn calculate-experience
  "Calculates how much experience should be given for attacking target."
  [g target-id target-before]
  (if (target-before :no-experience)
    0
    (let [health-after (get-in g [:objects target-id :health] 0)
          damage (- (target-before :health) health-after)
          kill-bonus (if (get-in g [:objects target-id]) 0 1)]
      (+ damage kill-bonus))))

(defn add-experience
  [g obj-id target-id target]
  (let [exp (calculate-experience g target-id target)]
    (if (pos? exp)
      (update-object g obj-id
                     #(obj-utils/add-experience % exp) cmd/set-experience)
      g)))

(defn check-is-unit
  [g target-id]
  (if (not (obj-utils/unit? (get-in g [:objects target-id])))
    :target-should-be-a-unit))

(defn check-objects-near
  "Checks that o1 is near o2 (distance between them is 1)."
  [o1 o2]
  (if (not= 1 (obj-distance o1 o2))
    :target-object-is-not-reachable))

(defn check-bind
  [g p obj-id target-id]
  (or
   (check-object-action g p obj-id :bind)
   (check-is-unit g target-id)
   (check-objects-near
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))))

(defn bind [] nil)


(create-action
 :end-turn
 [g p]
 (if (not= p (g :active-player))
   :not-your-turn
   (-> g
      (add-command (cmd/end-turn p))
      (set-next-player-active))))


(create-action
 :move
 [g p obj-id new-position]
 (or
   (check-object-action g p obj-id :move)
   (check-valid-coord g new-position)
   (check-coord-one-step-away (get-in g [:objects obj-id]) new-position)
   (check-can-move-to g obj-id new-position)
   (-> g
       (update-object obj-id #(update % :moves dec) cmd/set-moves)
       (move-object p obj-id new-position))))


(create-action
 :attack
 [g p obj-id target-id]
 (or
   (check-object-action g p obj-id :attack)
   (check-valid-attack-target g target-id)
   (check-obj-one-step-away
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))

   (let [obj (get-in g [:objects obj-id])
        target (get-in g [:objects target-id])
        attack-params (get-attack-params obj target)]
    (-> g
        (update-object obj-id obj-utils/deactivate cmd/set-moves)
        (add-command (cmd/attack obj-id target-id attack-params))
        (damage-obj p target-id (attack-params :damage))
        (add-experience obj-id target-id target)))))
