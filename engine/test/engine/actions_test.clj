(ns engine.actions-test
  (:require [engine.actions :refer :all]
            [engine.core :refer :all]
            [engine.newgame :refer [create-new-game]]
            [engine.objects :refer [add-new-object get-new-object]]
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

(deftest test-end-game
  (let [ng (create-new-game)
        sp (get-object-id-at ng [2 0])
        castle (get-object-id-at ng [0 0])
        g (damage-obj ng castle 0 9)
        go (check-and-act g 0 :attack {:obj-id sp :target-id castle})]
    (is (check go 0 :move {:obj-id 2 :new-position [1 1]}))
    (is (= :over (go :status)))
    (is (= :lost (get-in go [:players 0 :status])))
    (is (= :won (get-in go [:players 2 :status])))))

(deftest test-move-to-empty-cell
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        g-moved (check-and-act g 0 :move {:obj-id sp1-id :new-position [3 1]})]
    (is (= [3 1] (get-in g-moved [:objects sp1-id :position])))))

(deftest test-reward
  (let [r 10
        g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        gold-before (get-in g [:players 0 :gold])
        g-after (-> g
                    (assoc-in [:objects sp1-id :reward] r)
                    (check-and-act 0 :move {:obj-id sp1-id :new-position [1 1]})
                    (check-and-act 0 :attack {:obj-id sp2-id :target-id sp1-id}))
        gold-after (get-in g-after [:players 0 :gold])]
    (is (= gold-after (+ gold-before r)))))


(deftest test-drowning
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        g-after (-> g
                    (add-new-object :puddle [2 2])
                    (check-and-act 0 :move {:obj-id sp1-id :new-position [2 1]})
                    (check-and-act 0 :move {:obj-id sp1-id :new-position [2 2]})
                    (add-new-object :bridge [2 2])
                    (check-and-act 0 :move {:obj-id sp2-id :new-position [1 2]})
                    (check-and-act 0 :move {:obj-id sp2-id :new-position [2 2]}))]
    (is (not (get-in g-after [:objects sp1-id])))
    (is (get-in g-after [:objects sp2-id]))))

(deftest test-experience
  (let [g (-> (create-new-game)
              (add-new-object :tree [3 0]))
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        castle-id (get-object-id-at g [0 0])
        tree-id (get-object-id-at g [3 0])
        g-after (-> g
                    (attack 0 sp1-id tree-id)
                    (attack 0 sp2-id castle-id))]
    (is (zero? (get-in g-after [:objects sp1-id :experience] 0)))
    (is (pos? (get-in g-after [:objects sp2-id :experience])))))
