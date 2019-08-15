(ns engine.transformations)

(defn dot
  "Calculates dot product of two vectors."
  [v1 v2]
  (reduce + (map * v1 v2)))

(defn m*v
  "Multiplies a matrix by a vector."
  [m v]
  (map #(dot % v) m))

(defn m*m
  "Multiplies two matrices.
  In m1 elements are rows, in m2 and the result elements are columns."
  [m1 m2]
  (map #(m*v m1 %) m2))

(defn v+v
  "Adds two vectors."
  [v1 v2]
  (map + v1 v2))

(def flip-matrix [[-1 0] [0 1]])
(def rot90-matrix [[0 -1] [1 0]])
(def rot180-matrix [[-1 0] [0 -1]])
(def rot270-matrix [[0 1] [-1 0]])

(defn flip
  "Flips coordinates along vertical axis if flag is positive."
  [coords flag]
  (if (pos? flag)
    (m*m flip-matrix coords)
    coords))

(defn rotate
  "Rotates coordinates clockwise (0 for no rotation, 1 for 90 degrees, 2 for 180, 3 for 270)."
  [coords rotation]
  (case rotation
    0 coords
    1 (m*m rot90-matrix coords)
    2 (m*m rot180-matrix coords)
    3 (m*m rot270-matrix coords)))

(defn transform
  "Applies first flip then rotation to the passed coordinates."
  [coords flip-flag rotation]
  (->
   coords
   (flip flip-flag)
   (rotate rotation)))

(defn translate
  "Adds vector t elementwise to every coord."
  [coords t]
  (map #(v+v % t) coords))

(defn place
  "Flips, rotates and translates coords."
  [coords flip-flag rotation translation]
  (->
   coords
   (transform flip-flag rotation)
   (translate translation)))
