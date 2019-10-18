(ns engine.object-utils)


(defn activate
  "Refills object moves."
  [obj]
  (if (obj :moves)
    (assoc obj :moves (obj :max-moves))
    obj))

(defn deactivate
  "Sets object moves to zero."
  [obj]
  (if (obj :moves)
    (assoc obj :moves 0)
    obj))

(defn active?
  [obj]
  (pos? (or (obj :moves) 0)))

(defn unit?
  [obj]
  (= :unit (obj :class)))

(defn building?
  [obj]
  (= :building (obj :class)))

(defn is-type?
  [obj t]
  (= t (obj :type)))

(defn belongs-to?
  "Checks if obj belongs to player p."
  [p obj]
  (= p (obj :player)))

(defn set-health
  "Sets health."
  [obj health]
  {:pre [(pos? health)]}
  (assoc obj :health health))

(defn add-experience
  "Adds experience."
  [obj exp]
  {:pre [(pos? exp)]}
  (update obj :experience (fnil + 0) exp))

(defn damaged?
  [obj]
  (and (obj :health) (< (obj :health) (obj :max-health))))
