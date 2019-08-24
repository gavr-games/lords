(ns engine.actions-test
  (:require [engine.actions :refer :all]
            [engine.core :refer :all]
            [clojure.test :refer :all]))

(deftest test-move-attack
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        g-moved (check-and-act g 0 :move {:obj-id sp1-id :new-position [1 1]})
        g-attacked (check-and-act g-moved 0 :attack {:obj-id sp2-id :target-id sp1-id})]
    (is (= [1 1] (get-in g-moved [:objects sp1-id :position])))
    (is (nil? (get-in g-attacked [:objects sp1-id])))
    (is (= 2 (g-attacked :active-player)))))

(deftest test-invalid-actions
  (let [g (create-new-game)]
    (is (check g 2 :move {:obj-id 1 :new-position [1 1]}))
    (is (check g 0 :move {:obj-id 1 :new-position [5 5]}))
    (is (check g 2 :move {:obj-id 4 :new-position [18 18]}))
    (is (check g 0 :move {:obj-id 1 :new-position [1 0]}))
    (is (check g 2 :attack {:obj-id 1 :target-id 2}))))
