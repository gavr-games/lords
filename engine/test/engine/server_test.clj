(ns engine.server-test
  (:require [clojure.test :refer :all]
            [engine.server :refer :all]
            [ring.mock.request :as mock]))

(deftest test-app
  (testing "main route"
    (let [response (app (mock/request :get "/"))]
      (is (= (:status response) 200))))

  (testing "not-found route"
    (let [response (app (mock/request :get "/invalid"))]
      (is (= (:status response) 404)))))

(deftest test-create-game
  (let [response (app (mock/request :get "/newgame"))]
    (is (= (:status response) 200))
    (is (.contains (:body response) "new-game-id"))))
