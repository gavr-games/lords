(ns engine.objects
  (:require [engine.core :refer :all]
            [engine.object-utils :refer [unit?]]
            [clojure.set :as set]))


(def default-unit-actions #{:move :levelup})

(def
 objects
 {:castle
  {:health 10
   :class :building
   :coords
   {[0 0] {:fill :solid}
    [0 1] {:fill :solid}
    [1 0] {:fill :solid}
    [1 1] {:fill :floor :spawn true}}
   :handlers
   {:on-destruction [:castle-destroyed]}},

  :tree
  {:health 2
   :class :building
   :no-experience true
   :coords
   {[0 0] {:fill :solid}}}

  :puddle
  {:class :building
   :coords
   {[0 0] {:fill :water}}}

  :bridge
  {:class :building
   :health 10
   :no-experience true
   :coords
   {[0 0] {:fill :bridge}
    [0 1] {:fill :solid}
    [1 0] {:fill :solid}}}

  :spearman
  {:health 1
   :max-moves 2
   :attack 1
   :class :unit
   :coords
   {[0 0] {:fill :unit}}
   :actions
   #{:attack}}

  :chevalier
  {:health 3
   :max-moves 4
   :attack 2
   :class :unit
   :coords
   {[0 0] {:fill :unit}}
   :actions
   #{:attack}}

  :ram
  {:health 2
   :max-moves 1
   :attack 5
   :class :unit
   :coords
   {[0 0] {:fill :unit}}
   :actions
   #{:attack :bind}}

  :dragon
  {:health 5
   :max-moves 6
   :attack 5
   :class :unit
   :coords
   {[0 0] {:fill :unit}
    [0 1] {:fill :unit}
    [1 0] {:fill :unit}
    [1 1] {:fill :unit}}
   :actions
   #{:splash-attack}}
  })

(create-handler
 :castle-destroyed
 [g obj-id]
 (let [p-lost (get-in g [:objects obj-id :player])
       remaining-players (dissoc (g :players) p-lost)
       remaining-teams
       (set (map :team (filter
                        #(= :active (% :status))
                        (vals remaining-players))))
       p-won (if (= 1 (count remaining-teams))
               (keys remaining-players)
               [])]
   (as-> g game
     (player-lost game p-lost)
     (reduce player-won (end-game game) p-won))))

(defn get-new-object
  "Gets a new object of a given type."
  [obj-type]
  (as-> (objects obj-type) obj
    (assoc obj :type obj-type)
    (if (obj :max-moves)
      (assoc obj :moves 0)
      obj)
    (if (unit? obj)
      (update obj :actions set/union default-unit-actions)
      obj)))


(defn add-new-object
  "Convenience function that creates a new object and adds it to the game.
  If field map is given, it adds/overrides to defauld fields of the new object."
  ([g obj-type position]
   (add-new-object g nil obj-type position nil nil))
  ([g obj-type position flip rotation]
   (add-new-object g nil obj-type position flip rotation))
  ([g p obj-type position]
   (add-new-object g p obj-type position nil nil))
  ([g p obj-type position flip rotation]
   (add-new-object g p obj-type position flip rotation nil))
  ([g p obj-type position flip rotation fields]
   (add-object g p
               (merge (get-new-object obj-type) fields)
               position flip rotation)))
