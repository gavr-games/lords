(ns engine.transformations-test
  (:require [engine.transformations :refer :all]
            [clojure.test :refer :all]))

(deftest test-dot
  (is (= 11 (dot [1 2] [3 4])))
  (is (= 3 (dot [-1 0 1] [2 4 5]))))

(deftest test-m*v
  (is (= [25 3] (m*v [[1 2 3] [-1 0 1]] [2 4 5]))))


(deftest test-translate
  (is (= [12 23] (translate [2 3] [10 20]))))

(deftest test-transform-coords
  (is (= [[1 0] [0 2]] (transform-coords [[1 0] [0 2]] 0 0 [0 0])))
  (is (= [[0 1] [-2 0]] (transform-coords [[1 0] [0 2]] 0 1 [0 0])))
  (is (= [[-1 0] [0 -2]] (transform-coords [[1 0] [0 2]] 0 2 [0 0])))
  (is (= [[0 -1] [2 0]] (transform-coords [[1 0] [0 2]] 0 3 [0 0])))
  (is (= [[-1 0] [0 2]] (transform-coords [[1 0] [0 2]] 1 0 [0 0])))
  (is (= [[0 -1] [-2 0]] (transform-coords [[1 0] [0 2]] 1 1 [0 0])))
  (is (= [[1 0] [0 -2]] (transform-coords [[1 0] [0 2]] 1 2 [0 0])))
  (is (= [[0 1] [2 0]] (transform-coords [[1 0] [0 2]] 1 3 [0 0])))
  (is (= [[0 0]] (transform-coords [[0 0]] 0 0 [0 0])))
  (is (= [[1 2]] (transform-coords [[0 0]] 0 0 [1 2])))
  (is (= [[10 19] [8 20]] (transform-coords [[1 0] [0 2]] 1 1 [10 20]))))
