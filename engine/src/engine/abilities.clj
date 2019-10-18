(ns engine.abilities
  (:require [engine.actions :refer [create-action]]
            [engine.checks :as check]
            [engine.core :refer :all]
            [engine.object-utils :as obj-utils]
            [engine.commands :as cmd]
            [engine.attack :refer [get-attack-params get-shooting-range get-shot-params]]
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


(defn- add-attack-experience
  [g obj-id target-id target]
  (let [exp (calculate-experience g target-id target)]
    (if (pos? exp)
      (add-experience g obj-id exp)
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


(defn attack
  "Performs attack actions for both melee attack or shooting."
  [g p obj-id target-id attack-params]
  (let [obj (get-in g [:objects obj-id])
        target (get-in g [:objects target-id])]
    (as-> g game
        (update-object game obj-id obj-utils/deactivate cmd/set-moves)
        (cmd/add-command game (cmd/attack obj-id target-id attack-params))
        (if (not= :miss (attack-params :outcome))
          (-> game
            (damage-obj p target-id (attack-params :damage))
            (add-attack-experience obj-id target-id target))
          game))))


(defn melee-attack
  "Performs melee attack actions."
  [g p obj-id target-id]
  (let [obj (get-in g [:objects obj-id])
        target (get-in g [:objects target-id])
        attack-params (assoc (get-attack-params obj target) :type :melee)]
    (-> g
        (handle obj-id :before-melee-attacks target-id)
        (attack p obj-id target-id attack-params))))


(defn range-attack
  "Performs range attack actions."
  [g p obj-id target-id params]
  (as-> g game
    (attack game p obj-id target-id (assoc params :type :range))
    (if (not= :miss (params :outcome))
      (handle game obj-id :after-successfully-range-attacks target-id)
      game)))


(create-action
 :attack
 [g p obj-id target-id]
 (or
   (check/object-action g p obj-id :attack)
   (check/valid-attack-target g target-id)
   (check/obj-one-step-away
    (get-in g [:objects obj-id])
    (get-in g [:objects target-id]))

   (melee-attack g p obj-id target-id)))


(create-action
 :shoot
 [g p obj-id target-id]
 (or
   (check/object-action g p obj-id :shoot)
   (check/valid-attack-target g target-id)
   (let [obj (get-in g [:objects obj-id])
         target (get-in g [:objects target-id])
         distance (obj-distance obj target)
         shot-params (get-shot-params obj target distance)]
     (or
      (check/shooting-distance-in-range distance (get-shooting-range obj))
      (check/shooting-valid-outcome shot-params)

      (range-attack g p obj-id target-id shot-params))
     )))


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
       (add-handler obj-id :before-melee-attacks :binding-unbind)
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
        (remove-handler obj-id :before-melee-attacks :binding-unbind)
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


(defn object-coords
  "Returns a set of object coordinates."
  [obj]
  (set (keys (get-object-coords-map obj))))

(defn object-coords-at-position
  "Returns a set of object coordinates
  if it would be moved to the given position."
  [obj position]
  (object-coords (assoc obj :position position)))


(create-handler
 :binding-drag
 [g obj-id old-position new-position & _]
 (let [dist (distance old-position new-position)]
   (if (> dist 1)
     (get-unbound g obj-id)
     (let [obj (get-in g [:objects obj-id])
           dragged-obj-id (obj :binding-from)
           dragged-obj-position (get-in g [:objects dragged-obj-id :position])
           freed-coords (set/difference
                         (object-coords-at-position obj old-position)
                         (object-coords obj))
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


(create-action
 :splash-attack
 [g p obj-id attack-position]
 (or
  (check/object-action g p obj-id :splash-attack)
  (check/coord-one-step-away (get-in g [:objects obj-id]) attack-position)
  (let [obj (get-in g [:objects obj-id])
        attacked-coords (object-coords-at-position obj attack-position)
        target-ids (->> attacked-coords
                        (map #(get-object-id-at g %))
                        (filter identity)
                        (filter #(not= % obj-id))
                        (filter #(get-in g [:objects % :health]))
                        set)]
    (or
     (check/splash-attack-any-targets target-ids)
     (reduce
      (fn [game target-id] (melee-attack game p obj-id target-id))
      g target-ids)))))
