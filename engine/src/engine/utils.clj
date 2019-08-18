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
