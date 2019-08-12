(ns engine.handler
  (:require [engine.core :as core]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [ring.util.response :refer [response]]))

(def games (atom {}))

(defn new-game! [request]
  (let [id (.. (java.util.UUID/randomUUID) toString)
        new-game (core/create-new-game)]
    (swap! games assoc id new-game)
    (response {:new-game-id id})))

(defn list-games [request]
  (response @games))

(defroutes app-routes
  (GET "/" [] "Please call /newgame to create game or /list to list existing games")
  (GET "/newgame" [] new-game!)
  (GET "/list" [] list-games)
  (route/not-found "Not Found"))

(def app (->
           app-routes
           (wrap-json-body {:keywords? true})
           (wrap-json-response)
           (wrap-defaults api-defaults)))
