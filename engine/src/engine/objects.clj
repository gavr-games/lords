(ns engine.objects)

(def objects {
           :castle
           {:health 10
            :coords {
                     [0 0] {:fill :solid}
                     [0 1] {:fill :solid}
                     [1 0] {:fill :solid}
                     [1 1] {:fill :floor :spawn true}}}
           :tree
           {:health 2
            :coords {
                     [0 0] {:fill :solid}}}})
