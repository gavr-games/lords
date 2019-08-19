(ns engine.actions)

(defn check-move)
(defn move [g p obj-id new-position] nil)
(defn attack [] nil)

(def actions-dic
  {:move {:check check-move
          :do move}

   })

