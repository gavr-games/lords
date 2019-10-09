(ns engine.abilities
  (:require [engine.actions :refer [create-action]]
            [engine.checks :as check]
            [engine.core :refer :all]
            [engine.object-utils :as obj-utils]
            [engine.commands :as cmd]
            [engine.attack :refer [get-attack-params]]
            [engine.transformations :refer [distance v-v translate eu-distance]]
            [clojure.set :as set]))


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
       (handle obj-id :before-walks new-position)
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
        (handle obj-id :before-attacks target-id)
        (update-object obj-id obj-utils/deactivate cmd/set-moves)
        (cmd/add-command (cmd/attack obj-id target-id attack-params))
        (damage-obj p target-id (attack-params :damage))
        (add-experience obj-id target-id target)))))


(create-action
 :bind
 [g p obj-id target-id]
 (or
   (check/object-action g p obj-id :bind)
   (check/is-unit g target-id)
   (check/objects-near
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))

   (-> g
       (update-object obj-id obj-utils/deactivate cmd/set-moves)
       (cmd/add-command (cmd/binds obj-id target-id))
       (update-object obj-id #(assoc % :binding-to target-id))
       (update-object target-id #(assoc % :binding-from obj-id))
       (add-handler target-id :after-moved :binding-drag)
       (add-handler obj-id :after-moved :binding-unbind-if-not-near)
       (add-handler obj-id :before-walks :binding-unbind)
       (add-handler obj-id :before-attacks :binding-unbind)
       (add-handler obj-id :before-destruction :binding-unbind)
       (add-handler target-id :before-destruction :binding-get-unbound))))

(defn unbind
  [g obj-id]
  (let [target-id (get-in g [:objects obj-id :binding-to])]
    (-> g
        (cmd/add-command (cmd/unbinds obj-id target-id))
        (update-object obj-id #(dissoc % :binding-to))
        (update-object target-id #(dissoc % :binding-from))
        (remove-handler target-id :after-moved :binding-drag)
        (remove-handler obj-id :after-moved :binding-unbind-if-not-near)
        (remove-handler obj-id :before-walks :binding-unbind)
        (remove-handler obj-id :before-attacks :binding-unbind)
        (remove-handler obj-id :before-destruction :binding-unbind)
        (remove-handler target-id :before-destruction :binding-get-unbound))))

(defn get-unbound
  [g obj-id]
  (let [binding-obj-id (get-in g [:objects obj-id :binding-from])]
   (unbind g binding-obj-id)))

(create-handler
 :binding-unbind
 [g obj-id & _]
 (unbind g obj-id))

(create-handler
 :binding-get-unbound
 [g obj-id & _]
 (get-unbound g obj-id))

(create-handler
 :binding-drag
 [g obj-id old-position new-position & _]
 (let [dist (distance old-position new-position)]
   (if (> dist 1)
     (get-unbound g obj-id)
     (let [obj (get-in g [:objects obj-id])
           dragged-obj-id (obj :binding-from)
           dragged-obj-position (get-in g [:objects dragged-obj-id :position])
           coords (set (keys (get-object-coords-map obj)))
           move-delta (v-v old-position new-position)
           old-coords (set (map #(translate % move-delta) coords))
           freed-coords (set/difference old-coords coords)
           closest-coord (apply min-key
                                #(eu-distance dragged-obj-position %)
                                freed-coords)]
       (move-object g (obj :player) dragged-obj-id closest-coord)))))

(create-handler
 :binding-unbind-if-not-near
 [g obj-id & _]
 (let [obj (get-in g [:objects obj-id])
       bound-obj (get-in g [:objects (obj :binding-to)])]
   (if (> (obj-distance obj bound-obj) 1)
     (unbind g obj-id)
     g)))
