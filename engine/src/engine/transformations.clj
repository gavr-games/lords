(ns engine.transformations)

(defn dot
  "Calculates dot product of two vectors."
  [v1 v2]
  (reduce + (map * v1 v2)))

(defn m*v
  "Multiplies a matrix by a vector."
  [m v]
  (map #(dot % v) m))

(defn v+v
  "Adds two vectors."
  [v1 v2]
  (map + v1 v2))

(def flip-matrix [[-1 0] [0 1]])
(def rot90-matrix [[0 -1] [1 0]])
(def rot180-matrix [[-1 0] [0 -1]])
(def rot270-matrix [[0 1] [-1 0]])

(defn flip
  "Flips a coordinate along vertical axis if flag is positive."
  [coord flag]
  (if (pos? (or flag 0))
    (m*v flip-matrix coord)
    coord))

(defn rotate
  "Rotates a coordinate clockwise (0 for no rotation, 1 for 90 degrees, 2 for 180, 3 for 270)."
  [coord rotation]
  (case (or rotation 0)
    0 coord
    1 (m*v rot90-matrix coord)
    2 (m*v rot180-matrix coord)
    3 (m*v rot270-matrix coord)))

(defn flip-rotate
  "Applies first flip then rotation to a coordinate."
  [coord flip-flag rotation]
  (->
   coord
   (flip flip-flag)
   (rotate rotation)))

(defn translate
  "Adds vector t to a coordinate."
  [coord t]
  (v+v coord t))

(defn transform
  "Transforms a coord."
  [coord flip-flag rotation translation]
  (->
   coord
   (flip-rotate flip-flag rotation)
   (translate translation)))

(defn transform-coords
  [coords flip-flag rotation translation]
  (map #(transform % flip-flag rotation translation) coords))

(defn difference
  "Returns absolute value of the difference between two numbers."
  [a b]
  (Math/abs (- a b)))

(defn distance
  "Returns manhattan distance between two coordinates"
  [c1 c2]
  (reduce + (map difference c1 c2)))
