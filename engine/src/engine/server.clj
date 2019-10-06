(ns engine.server
  (:require [engine.newgame :refer [create-new-game]]
            [engine.actions :as action]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [compojure.coercions :refer [as-int]]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [ring.middleware.json :refer [wrap-json-body wrap-json-response]]
            [ring.util.response :refer [response]]))

(def games (ref {}))

(defn new-game! []
  (let [id (.. (java.util.UUID/randomUUID) toString)
        new-game (create-new-game)]
    (dosync (alter games assoc id new-game))
    (response {:new-game-id id})))

(defn list-games []
  (response (keys @games)))

(defn get-game [g-id]
  (response (@games g-id)))

(defn deep-to-int [x]
  (cond
    (vector? x) (vec (map deep-to-int x))
    (map? x) (into {} (for [[k v] x] [k (deep-to-int v)]))
    (as-int x) (Long/parseLong x)
    :else x))

(defn act! [g-id p action-code params]
  (let [params (deep-to-int params)
        action-code (keyword action-code)]
    (dosync
     (let [g (@games g-id)
           action-result (action/act g p action-code params)]
       (if (keyword? action-result)
         (response {:success false :error action-result})
         (let [g-after action-result
               new-commands (subvec (g-after :commands) (count (g :commands)))
               over (= :over (g-after :status))]
           (if over
             (alter games dissoc g-id)
             (alter games assoc g-id g-after))
           (response
            {:success true :commands new-commands :game g-after})))
       ))))

(defn whatif [g-id p action-code params]
  "Copypaste from act!"
  (let [params (deep-to-int params)
        action-code (keyword action-code)]
    (let [g (@games g-id)
          action-result (action/act g p action-code params)]
      (if (keyword? action-result)
        (response {:success false :error action-result})
        (let [g-after action-result
              new-commands (subvec (g-after :commands) (count (g :commands)))]
          (response
           {:success true :commands new-commands :game g-after})))
      )))

(defroutes app-routes
  (GET "/" [] "Please call /newgame to create game or /list to list existing games")
  (GET "/newgame" [] (new-game!))
  (GET "/list" [] (list-games))
  (GET "/game/:g-id" [g-id] (get-game g-id))
  (GET "/game/:g-id/:p/act" [g-id p :<< as-int action & params]
       (act! g-id p action params))
  (GET "/game/:g-id/:p/whatif" [g-id p :<< as-int action & params]
       (whatif g-id p action params))
  (route/not-found "Not Found"))

(def app (->
           app-routes
           (wrap-json-body {:keywords? true})
           (wrap-json-response)
           (wrap-defaults api-defaults)))
