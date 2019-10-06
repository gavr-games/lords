(ns engine.abilities
  (:require [engine.actions :refer [create-action]]
            [engine.checks :as check]
            [engine.core :refer :all]
            [engine.object-utils :as obj-utils]
            [engine.commands :as cmd]
            [engine.attack :refer [get-attack-params]]))


(defn- calculate-experience
  "Calculates how much experience should be given for attacking target."
  [g target-id target-before]
  (if (target-before :no-experience)
    0
    (let [health-after (get-in g [:objects target-id :health] 0)
          damage (- (target-before :health) health-after)
          kill-bonus (if (get-in g [:objects target-id]) 0 1)]
      (+ damage kill-bonus))))


(defn- add-experience
  [g obj-id target-id target]
  (let [exp (calculate-experience g target-id target)]
    (if (pos? exp)
      (update-object g obj-id
                     #(obj-utils/add-experience % exp) cmd/set-experience)
      g)))


(create-action
 :move
 [g p obj-id new-position]
 (or
   (check/object-action g p obj-id :move)
   (check/valid-coord g new-position)
   (check/coord-one-step-away (get-in g [:objects obj-id]) new-position)
   (check/can-move-to g obj-id new-position)
   (-> g
       (update-object obj-id #(update % :moves dec) cmd/set-moves)
       (move-object p obj-id new-position))))


(create-action
 :attack
 [g p obj-id target-id]
 (or
   (check/object-action g p obj-id :attack)
   (check/valid-attack-target g target-id)
   (check/obj-one-step-away
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))

   (let [obj (get-in g [:objects obj-id])
        target (get-in g [:objects target-id])
        attack-params (get-attack-params obj target)]
    (-> g
        (update-object obj-id obj-utils/deactivate cmd/set-moves)
        (cmd/add-command (cmd/attack obj-id target-id attack-params))
        (damage-obj p target-id (attack-params :damage))
        (add-experience obj-id target-id target)))))







(defn check-bind
  [g p obj-id target-id]
  (or
   (check/object-action g p obj-id :bind)
   (check/is-unit g target-id)
   (check/objects-near
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))))
