(ns engine.newgame
  (:require [engine.core :refer :all])
  (:require [engine.objects :refer [add-new-object]]))

(def board-size-x 20)
(def board-size-y 20)

(defn create-empty-board
  [size-x size-y]
  (zipmap (for [x (range size-x) y (range size-y)] [x y]) (repeat {})))

(defn create-empty-game []
  {:board
   (create-empty-board board-size-x board-size-y)
   :players {}
   :turn-order []
   :active-player nil
   :objects {}
   :actions []
   :commands []
   :status :active
   :next-object-id 0})

(defn create-new-game []
  (-> (create-empty-game)
      (add-player 0 (create-player 0 100))
      (add-player 2 (create-player 1 100))
      (update :turn-order conj 0 2)
      (add-new-object 0 :castle [0 0] 0 0)
      (add-new-object 0 :spearman [2 0])
      (add-new-object 0 :spearman [0 2])
      (add-new-object 2 :castle [(dec board-size-x) (dec board-size-y)] 0 2)
      (add-new-object 2 :spearman [(dec board-size-x) (- board-size-y 3)])
      (add-new-object 2 :spearman [(- board-size-x 3) (dec board-size-y)])
      (set-active-player 0)))
