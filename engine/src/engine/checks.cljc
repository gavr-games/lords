(ns engine.checks
  (:require [engine.core :as core]
            [engine.transformations :refer [distance v-v]]
            [engine.object-utils :refer [unit?]]
            [engine.utils :refer [abs]]))


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


(defn- chess-knight-reachable
  [c1 c2]
  (let [deltas (map abs (v-v c1 c2))]
    (= (set deltas) #{1 2})))


(defn coord-one-step-away
  [obj coord]
  (if (or
       (and (obj :chess-knight)
            (not (chess-knight-reachable (obj :position) coord)))
       (and (not (obj :chess-knight))
            (not= 1 (distance (obj :position) coord))))
    :target-coord-not-reachable))


(defn obj-one-step-away
  "Checks that o1 can step on o2 in one step."
  [o1 o2]
  (if (or
       (and (o1 :chess-knight)
            (not-any? #(apply chess-knight-reachable %)
                      (core/all-filled-coord-pairs o1 o2)))
       (and (not (o1 :chess-knight))
            (not= 1 (core/obj-distance o1 o2))))
    :target-object-is-not-reachable))


(defn valid-coord
  [g coord]
  (if (not (get-in g [:board coord]))
    :invalid-coord))


(defn can-move-to
  [g obj-id position]
  (if (not (core/can-move-object? g obj-id position))
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
  (if (not= 1 (core/obj-distance o1 o2))
    :target-object-is-not-reachable))

(defn splash-attack-any-targets
  [targets]
  (if (empty? targets)
    :no-objects-to-attack))

(defn shooting-distance-in-range
  [distance [min-distance max-distance]]
  (cond (< distance min-distance) :target-too-close
        (> distance max-distance) :target-too-far))

(defn shooting-valid-outcome
  [params]
  (if (nil? params)
    :shooting-target-not-applicable))

(defn can-fly-distance
  [obj dist]
  (if (> dist (obj :moves))
    :target-coord-not-reachable))
