(ns engine.core-test
  (:require [engine.core :refer :all]
            [clojure.test :refer :all]))

(defn get-object-at
  [g coord]
  (let [obj-ids (keys (get-in g [:board coord]))]
    (assert (= 1 (count obj-ids)))
    (get-in g [:objects (first obj-ids)])))

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
