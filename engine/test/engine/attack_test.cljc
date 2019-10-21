(ns engine.attack-test
  (:require [engine.attack :refer [get-attack-possibilities]]
            [engine.objects :refer [get-new-object]]
            #?(:clj  [clojure.test :refer [deftest is]]
               :cljs [cljs.test :refer-macros [deftest is]])))

(deftest test-attack-modifiers
  (let [sp (get-new-object :spearman)
        ch (get-new-object :chevalier)
        normal (get-attack-possibilities sp sp)
        modified (get-attack-possibilities sp ch)]
    (is (= #{1 2} (set (map :damage normal))))
    (is (= #{2 3} (set (map :damage modified))))))
