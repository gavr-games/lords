(ns client.api
  (:require [engine.newgame :as ng]
            [engine.actions :as a]
            [engine.abilities]))


;; Public API

(defn ^:export new-game
  []
  (clj->js (ng/create-new-game)))

(defn ^:export act
  [g p action params]
  (let [g-clj (js->clj g :keywordize-keys true)
        params-clj (js->clj params :keywordize-keys true)]
    (.dir js/console (clj->js g-clj))
    (clj->js
     (a/act g-clj p (keyword action) params-clj))))
