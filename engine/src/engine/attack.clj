(ns engine.attack
  (:require [engine.object-utils :refer [unit? building? is-type?]])
  (:require [engine.utils :refer [weighted-random-choice]]))


(defmulti attacks-modifier
  "Modifier of attack parameters from the attacking unit."
  (fn [attack-params attacker target] (:type attacker)))

(defmulti attacked-modifier
  "Modifier of attack parameters from the attacked unit."
  (fn [attack-params attacker target] (:type target)))


(defmethod attacks-modifier :default
  [params & _] params)

(defmethod attacked-modifier :default
  [params & _] params)


(defn- damage-bonus-against
  "Returns attack modifier that adds bonus to damage for target of given type."
  [target-type bonus]
  (fn [attack-params attacker target]
    (if (is-type? target target-type)
      (map #(update % :damage + bonus) attack-params)
      attack-params)))

(defmethod attacks-modifier :spearman
  [& args]
  (apply (damage-bonus-against :chevalier 1) args))


(defmethod attacks-modifier :chevalier
  [& args]
  (apply (damage-bonus-against :dragon 2) args))


(defmethod attacks-modifier :ram
  [attack-params attacker target]
  (if (unit? target)
    (map #(assoc % :damage 0) attack-params)
    attack-params))


(defn default-attack-possibilities
  [attacker]
  (let [damage (attacker :attack)]
    [{:weight 5 :damage damage :outcome :hit}
     {:weight 1 :damage (inc damage) :outcome :critical}]))

(defn get-attack-possibilities
  "Gets all possible attack outcomes for given attacker and target."
  [attacker target]
  (-> (default-attack-possibilities attacker)
      (attacks-modifier attacker target)
      (attacked-modifier attacker target)))

(defn get-attack-params
  "Picks an random attack outcome and return its params."
  [attacker target]
  (let [possibilities (get-attack-possibilities attacker target)]
    (if (seq possibilities)
      (weighted-random-choice possibilities))))




(defmulti default-shot-possibilities
  "Returns map distance->[possibilities]."
  (fn [shooter] (:type shooter)))


(defmulti shoots-modifier
  "Modifier of attack parameters from the shooting unit."
  (fn [attack-params shooter target distance] (:type shooter)))


(defn get-shooting-range
  "Returns shooting range of the shooter in form [min-distance max-distance]."
  [shooter]
  (let [ranges (keys (default-shot-possibilities shooter))]
    [(apply min ranges) (apply max ranges)]))


(defmethod default-shot-possibilities :archer
  [shooter]
  (let [damage (shooter :attack)]
    {2 [{:weight 1 :damage damage :outcome :hit}]
     3 [{:weight 1 :damage damage :outcome :hit}
        {:weight 1 :outcome :miss}]
     4 [{:weight 1 :damage damage :outcome :hit}
        {:weight 5 :outcome :miss}]}))

(defmethod shoots-modifier :archer
  [attack-params shooter target distance]
  (cond
    (unit? target) attack-params
    (and (== distance 4) (is-type? target :tree)) (map #(assoc % :damage 0)
                                                       attack-params)
    :else []))


(defmethod default-shot-possibilities :marksman
  [shooter]
  (let [damage (shooter :attack)]
    {2 [{:weight 1 :damage damage :outcome :hit}]
     3 [{:weight 1 :damage damage :outcome :hit}
        {:weight 1 :damage (dec damage) :outcome :hit}]
     4 [{:weight 1 :damage (dec damage) :outcome :hit}
        {:weight 1 :outcome :miss}]}))

(defmethod shoots-modifier :marksman
  [attack-params shooter target distance]
  (if (unit? target)
    attack-params
    []))


(defmethod default-shot-possibilities :catapult
  [shooter]
  (let [damage (shooter :attack)]
    {2 [{:weight 1 :damage damage :outcome :hit}]
     3 [{:weight 1 :damage damage :outcome :hit}
        {:weight 1 :outcome :miss}]
     4 [{:weight 1 :damage damage :outcome :hit}
        {:weight 2 :outcome :miss}]
     5 [{:weight 1 :damage damage :outcome :hit}
        {:weight 5 :outcome :miss}]}))

(defmethod shoots-modifier :catapult
  [attack-params shooter target distance]
  (if (building? target)
    attack-params
    []))


(defn get-shot-possibilities
  "Gets possible shot outcomes for given shooter, target and distance."
  [shooter target distance]
  (-> ((default-shot-possibilities shooter) distance)
      (shoots-modifier shooter target distance)
      (attacked-modifier shooter target)))

(defn get-shot-params
  "Picks an random attack outcome and return its params."
  [shooter target distance]
  (let [possibilities (get-shot-possibilities shooter target distance)]
    (if (seq possibilities)
      (weighted-random-choice possibilities))))
