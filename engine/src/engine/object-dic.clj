(ns engine.object-dic)

(def
 objects
 {:castle
  {:health 10
   :class :building
   :coords
   {[0 0] {:fill :solid}
    [0 1] {:fill :solid}
    [1 0] {:fill :solid}
    [1 1] {:fill :floor :spawn true}}},

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
