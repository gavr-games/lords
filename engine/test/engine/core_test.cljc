(ns engine.core-test
  (:require [engine.core :as core]
            [engine.objects :refer [get-new-object add-new-object]]
            [engine.newgame :refer [create-new-game]]
            [clojure.test :refer [deftest is are]]))

(deftest test-get-next-player
  (let [g (create-new-game)]
    (is (= 0 (g :active-player)))
    (is (= 2 (core/get-next-player g 0)))
    (is (= 0 (core/get-next-player g 2)))))

(deftest test-initial-board
  (let [g (create-new-game)]
    (is (= :castle ((core/get-object-at g [0 0]) :type)))
    (is (= 0 ((core/get-object-at g [0 0]) :player)))
    (is (= (core/get-object-at g [0 0])
           (core/get-object-at g [0 1])
           (core/get-object-at g [1 0]) ))
    (is (= :spearman ((core/get-object-at g [0 2]) :type)))
    (is (= 0 ((core/get-object-at g [0 2]) :player)))
    (is (= :spearman ((core/get-object-at g [2 0]) :type)))
    (is (= 0 ((core/get-object-at g [2 0]) :player)))))

(deftest test-distance
  (let [c (core/set-object-placement (get-new-object :castle) [0 0])
        s1 (core/set-object-placement (get-new-object :spearman) [2 2])
        s2 (core/set-object-placement (get-new-object :spearman) [0 2])]
    (is (= 2 (core/obj-distance c s1)))
    (is (= 2 (core/obj-distance s1 s2)))
    (is (= 1 (core/obj-distance c s2)))))


(deftest test-object-placement
  (let [ng (create-new-game)
        g (add-new-object ng :puddle [3 3])
        can-place? (fn [obj coord]
                     (core/can-place-object? g
                                             (core/set-object-placement
                                              (get-new-object obj) coord)))]
    (are [obj coord] (not (can-place? obj coord))
      :tree [0 0]
      :tree [0 2]
      :tree [1 1]
      :tree [3 3]
      :spearman [0 0]
      :spearman [2 0]
      :puddle [0 0]
      :puddle [1 1]
      :puddle [3 3]
      :bridge [4 4]
      )
    (are [obj coord] (can-place? obj coord)
      :tree [2 2]
      :spearman [1 1]
      :spearman [2 2]
      :spearman [3 3]
      :puddle [4 4]
      :bridge [3 3])))
