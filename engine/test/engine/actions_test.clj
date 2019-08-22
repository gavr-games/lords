(ns engine.actions-test
  (:require [engine.actions :refer :all]
            [engine.core :refer :all]
            [clojure.test :refer :all]))

(deftest test-move-attack
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        g-moved (act g 0 :move sp1-id [1 1])
        g-attacked (act g-moved 0 :attack sp2-id sp1-id)]
    (is (= [1 1] (get-in g-moved [:objects sp1-id :position])))
    (is (nil? (get-in g-attacked [:objects sp1-id])))
    (is (= 2 (g-attacked :active-player)))))

(deftest test-invalid-actions
  (let [g (create-new-game)]
    (is (keyword? (act g 2 :move 1 [1 1])))
    (is (keyword? (act g 0 :move 1 [5 5])))
    (is (keyword? (act g 2 :move 4 [18 18])))
    (is (keyword? (act g 0 :move 1 [1 0])))
    (is (keyword? (act g 2 :attack 1 2)))))
