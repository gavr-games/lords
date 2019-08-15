(ns engine.transformations-test
  (:require [engine.transformations :refer :all]
            [clojure.test :refer :all]))

(deftest test-dot
  (is (= 11 (dot [1 2] [3 4])))
  (is (= 3 (dot [-1 0 1] [2 4 5]))))

(deftest test-m*v
  (is (= [25 3] (m*v [[1 2 3] [-1 0 1]] [2 4 5]))))

(deftest test-m*m
  (is (= [[5 23] [7 33]] (m*m [[0 1] [2 3]] [[4 5] [6 7]]))))

(deftest test-translate
  (is (= [[10 21] [12 23]] (translate [[0 1] [2 3]] [10 20]))))

(deftest test-place
  (is (= [[1 0] [0 2]] (place [[1 0] [0 2]] 0 0 [0 0])))
  (is (= [[0 1] [-2 0]] (place [[1 0] [0 2]] 0 1 [0 0])))
  (is (= [[-1 0] [0 -2]] (place [[1 0] [0 2]] 0 2 [0 0])))
  (is (= [[0 -1] [2 0]] (place [[1 0] [0 2]] 0 3 [0 0])))
  (is (= [[-1 0] [0 2]] (place [[1 0] [0 2]] 1 0 [0 0])))
  (is (= [[0 -1] [-2 0]] (place [[1 0] [0 2]] 1 1 [0 0])))
  (is (= [[1 0] [0 -2]] (place [[1 0] [0 2]] 1 2 [0 0])))
  (is (= [[0 1] [2 0]] (place [[1 0] [0 2]] 1 3 [0 0])))
  (is (= [[0 0]] (place [[0 0]] 0 0 [0 0])))
  (is (= [[1 2]] (place [[0 0]] 0 0 [1 2])))
  (is (= [[10 19] [8 20]] (place [[1 0] [0 2]] 1 1 [10 20]))))
