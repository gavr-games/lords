(ns engine.utils-test
  (:require [engine.utils :refer [insert-after]]
            #?(:clj  [clojure.test :refer [deftest is]]
               :cljs [cljs.test :refer-macros [deftest is]])))

(deftest test-insert-after
  (is (= [0] (insert-after [] 0 nil)))
  (is (= [0 1] (insert-after [0] 1 nil)))
  (is (= [0 1 2] (insert-after [0 2] 1 0)))
  (is (= [0 1 2] (insert-after [0 1] 2 1)))
  (is (= [0 1 2] (insert-after [0 1] 2 nil))))
