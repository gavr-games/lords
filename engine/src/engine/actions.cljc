(ns engine.actions
  (:require [engine.core :as core]
            [engine.commands :as cmd]
            [engine.checks :as check])
  #?(:cljs (:require-macros [engine.actions :refer [create-action]])))


(defmulti
  action
  "Player action distinguished by a keyword code."
  identity)

(defmacro create-action
  "Creates and registers action method for the given code.
  Action method should take game and player-num as first two arguments.
  This method should either return a keyword for an error, or a modified game."
  [code args body]
  `(defmethod action ~code
     [_#]
     (with-meta
       (fn ~args ~body)
       {:args ~(mapv keyword (drop 2 args))})))


(defn auto-end-turn
  "Ends turn if p is active and does not have active objects."
  [g p]
  (if
      (and
       (= p (g :active-player))
       (not (core/has-active-objects? g p)))
    (core/set-next-player-active g)
    g))


(defn act
  "Performs action and returns the resulting game state or error keyword.
  Params should be a map of keyword arguments."
  [g p action-code params]
  (let [act-fn (action action-code)
        param-keys ((meta act-fn) :args)
        param-values (vals (select-keys params param-keys))
        act-call #(apply act-fn % p param-values)
        action-log {:player p :action action :params params}
        prechecks-fail (or
                        (check/game g)
                        (check/player g p))]
    (or
     prechecks-fail
     (let [g-after (-> g
                       (update-in [:actions] conj action-log)
                       act-call)
           invalid-action (keyword? g-after)]
       (if invalid-action
         g-after
         (auto-end-turn g-after p))))))


(defn check
  "Checks if an action can be performed.
  Returns nil (on valid action) or error keyword.
  Params should be a map of keyword arguments."
  [g p action-code params]
  (let [g-after (act g p action-code params)]
    (if (keyword? g-after)
      g-after
      nil)))


(create-action
 :end-turn
 [g p]
 (if (not= p (g :active-player))
   :not-your-turn
   (-> g
      (cmd/add-command (cmd/end-turn p))
      (core/set-next-player-active))))
