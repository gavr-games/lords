(ns engine.checks
  (:require [engine.core :refer :all]
            [engine.transformations :refer [distance]]
            [engine.object-utils :refer [unit?]]))


(defn game
  [g]
  (cond
    (nil? g) :invalid-game
    (= :over (g :status)) :game-over))


(defn player
  [g p]
  (let [player (get-in g [:players p])]
    (cond
      (nil? player) :invalid-player
      (not= :active (player :status)) :player-not-active)))


(defn object-action
  "Checks that player can do given action on the object."
  [g p obj-id action-code]
  (let [obj (get-in g [:objects obj-id])]
    (cond
      (not obj) :invalid-obj-id
      (not= p (obj :player)) :not-owner
      (zero? (or (obj :moves) 0)) :object-inactive
      ;; TODO test paralysis
      (not (get-in obj [:actions action-code])) :invalid-action)))


(defn coord-one-step-away
  [obj coord]
  (if (not= 1 (distance (obj :position) coord))
    :target-coord-not-reachable)) ; TODO chess knight


(defn obj-one-step-away
  "Checks that o1 can step on o2 in one step."
  [o1 o2]
  (if (not= 1 (obj-distance o1 o2))
    :target-object-is-not-reachable)) ; TODO chess knight


(defn valid-coord
  [g coord]
  (if (not (get-in g [:board coord]))
    :invalid-coord))


(defn can-move-to
  [g obj-id position]
  (if (not (can-move-object? g obj-id position))
    :place-occupied))


(defn valid-attack-target
  [g target-id]
  (if (not (get-in g [:objects target-id :health]))
    :invalid-attack-target))


(defn is-unit
  [g target-id]
  (if (not (unit? (get-in g [:objects target-id])))
    :target-should-be-a-unit))


(defn objects-near
  "Checks that o1 is near o2 (distance between them is 1)."
  [o1 o2]
  (if (not= 1 (obj-distance o1 o2))
    :target-object-is-not-reachable))

(defn splash-attack-any-targets
  [targets]
  (if (empty? targets)
    :no-objects-to-attack))
