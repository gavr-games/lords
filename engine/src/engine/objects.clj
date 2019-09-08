(ns engine.objects
  (:require [engine.core :refer :all]))

(declare objects)

(defn get-new-object
  "Gets a new object of a given type."
  [obj-type]
  (as-> (objects obj-type) obj
     (assoc obj :type obj-type)
     (if (obj :max-moves)
       (assoc obj :moves 0)
       obj)))

(defn castle-destroyed
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
   {:on-destruction castle-destroyed}},

  :tree
  {:health 2
   :class :building
   :coords
   {[0 0] {:fill :solid}}}

  :spearman
  {:health 1
   :max-moves 2
   :attack 1
   :class :unit
   :coords
   {[0 0] {:fill :unit}}
   :actions
   #{:move :attack}}})
