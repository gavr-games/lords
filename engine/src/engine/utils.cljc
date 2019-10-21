(ns engine.utils)

(defn insert-after
  "Returns a vector where a new element is inserted after after-element in vector v.
  If there is no after-element, the new element is inserted at the beginning."
  [v new-element after-element]
  (let [i (.indexOf v after-element)
        [before after] (split-at (inc i) v)]
    (vec (concat before [new-element] after))))

;; From https://gist.github.com/danielpcox/c70a8aa2c36766200a95#gistcomment-2759497
(defn deep-merge [a b]
  (if (map? a)
    (merge-with deep-merge a b)
    b))


(defn weighted-random-choice
  "Takes a collection of maps, where every element has :weight value.
  Returns a random element from the collection with probabilities proportional to weights."
  [coll]
  (if (= 1 (count coll))
    (first coll)
    (let [weights (map :weight coll)
          cumulative-weights (reductions + weights)
          total-weight (last cumulative-weights)
          normed-weights (map #(/ % total-weight) cumulative-weights)
          r (rand)
          i (first (keep-indexed #(if (> %2 r) %1) normed-weights))]
      (nth coll i))))


(defn average [coll]
  (/ (reduce + coll) (count coll)))

(defn abs
  "Platform-independent absolute value."
  [x]
  (if (< x 0)
    (* x -1)
    x))
