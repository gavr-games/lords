(ns engine.abilities-test
  (:require [engine.actions :refer [act check]]
            [engine.abilities]
            [engine.core :refer :all]
            [engine.newgame :refer [create-new-game]]
            [engine.objects :refer [add-new-object get-new-object]]
            [clojure.test :refer :all]
            [engine.object-utils :as obj]))

(deftest test-move-attack
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        g-moved (act g 0 :move {:obj-id sp1-id :new-position [1 1]})
        g-attacked (act g-moved 0 :attack {:obj-id sp2-id :target-id sp1-id})]
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
        g (damage-obj ng 0 castle 9)
        go (act g 0 :attack {:obj-id sp :target-id castle})]
    (is (check go 0 :move {:obj-id 2 :new-position [1 1]}))
    (is (= :over (go :status)))
    (is (= :lost (get-in go [:players 0 :status])))
    (is (= :won (get-in go [:players 2 :status])))))

(deftest test-move-to-empty-cell
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        g-moved (act g 0 :move {:obj-id sp1-id :new-position [3 1]})]
    (is (= [3 1] (get-in g-moved [:objects sp1-id :position])))))

(deftest test-reward
  (let [r 10
        g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        gold-before (get-in g [:players 0 :gold])
        g-after (-> g
                    (assoc-in [:objects sp1-id :reward] r)
                    (act 0 :move {:obj-id sp1-id :new-position [1 1]})
                    (act 0 :attack {:obj-id sp2-id :target-id sp1-id}))
        gold-after (get-in g-after [:players 0 :gold])]
    (is (= gold-after (+ gold-before r)))))


(deftest test-drowning
  (let [g (create-new-game)
        sp1-id (get-object-id-at g [2 0])
        sp2-id (get-object-id-at g [0 2])
        g-after (-> g
                    (add-new-object :puddle [2 2])
                    (act 0 :move {:obj-id sp1-id :new-position [2 1]})
                    (act 0 :move {:obj-id sp1-id :new-position [2 2]})
                    (add-new-object :bridge [2 2])
                    (act 0 :move {:obj-id sp2-id :new-position [1 2]})
                    (act 0 :move {:obj-id sp2-id :new-position [2 2]}))]
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
                    (act 0 :attack {:obj-id sp1-id :target-id tree-id})
                    (act 0 :attack {:obj-id sp2-id :target-id castle-id}))]
    (is (zero? (get-in g-after [:objects sp1-id :experience] 0)))
    (is (pos? (get-in g-after [:objects sp2-id :experience])))))

(deftest test-binding
  (let [g (-> (create-new-game)
              (add-new-object 0 :ram [2 1]))
        sp1-id (get-object-id-at g [2 0])
        ram-id (get-object-id-at g [2 1])
        castle-id (get-object-id-at g [0 0])
        g (-> g
              (update-object ram-id obj/activate)
              (act 0 :bind {:obj-id ram-id :target-id sp1-id})
              (act 0 :move {:obj-id sp1-id :new-position [3 0]})
              (update-object ram-id obj/activate))
        unbound? (fn [g]
                   (let [ram-pos (get-in g [:objects ram-id :position])
                         [sp-x sp-y] (get-in g [:objects sp1-id :position])
                         g (act
                            g
                            0
                            :move
                            {:obj-id sp1-id :new-position [(inc sp-x) sp-y]})
                         ram-pos-after (get-in g [:objects ram-id :position])]
                     (= ram-pos ram-pos-after)))]
    (is (= [2 0] (get-in g [:objects ram-id :position])))
    (is (unbound? (act g 0 :move {:obj-id ram-id :new-position [1 1]})))
    (is (unbound? (act g 0 :attack {:obj-id ram-id :target-id castle-id})))
    (is (unbound? (move-object g 0 ram-id [5 5])))
    (is (unbound? (move-object g 0 sp1-id [5 5])))
    (is (map? (-> g
                  (destroy-obj 0 sp1-id)
                  (act 0 :move {:obj-id ram-id :new-position [1 1]}))))
    (is (map? (-> g
                  (destroy-obj 0 ram-id)
                  (act 0 :move {:obj-id sp1-id :new-position [4 0]}))))))

(deftest test-binding-to-dragon
  (let [g (-> (create-new-game)
              (add-new-object 0 :ram [2 2])
              (add-new-object 0 :dragon [3 3]))
        ram-id (get-object-id-at g [2 2])
        dragon-id (get-object-id-at g [3 3])
        g (-> g
              (update-object ram-id obj/activate)
              (update-object dragon-id obj/activate)
              (act 0 :bind {:obj-id ram-id :target-id dragon-id})
              (act 0 :move {:obj-id dragon-id :new-position [3 2]}))
        ram-pos-2 (get-in g [:objects ram-id :position])
        g (act g 0 :move {:obj-id dragon-id :new-position [4 2]})
        ram-pos-3 (get-in g [:objects ram-id :position])]
    (is (= [3 4] ram-pos-2))
    (is (= [3 3] ram-pos-3))))

(deftest test-dragon-move
  (let [g (-> (create-new-game)
              (add-new-object 0 :dragon [3 3]))
        dragon-id (get-object-id-at g [3 3])
        g (-> g
              (update-object dragon-id obj/activate))]
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [2 2]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [2 3]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [2 4]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [3 2]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [3 4]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [4 2]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [4 3]})))
    (is (not (check g 0 :move {:obj-id dragon-id :new-position [4 4]})))
    (is (check g 0 :move {:obj-id dragon-id :new-position [3 3]}))
    (is (check g 0 :move {:obj-id dragon-id :new-position [5 3]}))
    (is (check g 0 :move {:obj-id dragon-id :new-position [5 5]}))))
