(ns engine.attack
  (:require [engine.object-utils :refer [unit? is-type?]])
  (:require [engine.utils :refer [weighted-random-choice]]))


(defmulti attacks-modifier
  "Modifier of attack parameters from the attacking unit"
  (fn [attack-params attacker target] (:type attacker)))

(defmulti attacked-modifier
  "Modifier of attack parameters from the attacked unit"
  (fn [attack-params attacker target] (:type target)))

(defmethod attacks-modifier :default
  [params & _] params)

(defmethod attacked-modifier :default
  [params & _] params)


(defn damage-bonus-against
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
  (weighted-random-choice (get-attack-possibilities attacker target)))
