(ns client.api-test
  (:require [client.api :as sut]
            [engine.newgame :refer [create-new-game]]
            [cljs.test :refer-macros [deftest is]]))


(deftest roundtrip
  (let [g (create-new-game)]
    (is (= g (js->clj (clj->js g))))))

