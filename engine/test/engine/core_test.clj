(ns engine.core-test
  (:require [engine.core :refer :all]
            [engine.objects :refer [get-new-object]]
            [engine.newgame :refer [create-new-game]]
            [clojure.test :refer :all]))

(deftest test-get-next-player
  (let [g (create-new-game)]
    (is (= 0 (g :active-player)))
    (is (= 2 (get-next-player g 0)))
    (is (= 0 (get-next-player g 2)))))

(deftest test-initial-board
  (let [g (create-new-game)]
    (is (= :castle ((get-object-at g [0 0]) :type)))
    (is (= 0 ((get-object-at g [0 0]) :player)))
    (is (= (get-object-at g [0 0])
           (get-object-at g [0 1])
           (get-object-at g [1 0]) ))
    (is (= :spearman ((get-object-at g [0 2]) :type)))
    (is (= 0 ((get-object-at g [0 2]) :player)))
    (is (= :spearman ((get-object-at g [2 0]) :type)))
    (is (= 0 ((get-object-at g [2 0]) :player)))))

(deftest test-distance
  (let [c (set-object-placement (get-new-object :castle) [0 0])
        s1 (set-object-placement (get-new-object :spearman) [2 2])
        s2 (set-object-placement (get-new-object :spearman) [0 2])]
    (is (= 2 (obj-distance c s1)))
    (is (= 2 (obj-distance s1 s2)))
    (is (= 1 (obj-distance c s2)))))
