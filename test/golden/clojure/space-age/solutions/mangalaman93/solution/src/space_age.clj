(ns space-age)

(defn on-earth [age]
      (* (/ age 1000000000.0) 31.6883)
)

(defn on-mercury [age]
  (/ (on-earth age) 0.2408467)
)

(defn on-venus [age]
  (/ (on-earth age) 0.61519726)
)

(defn on-mars [age]
  (/ (on-earth age) 1.8808158)
)

(defn on-jupiter [age]
  (/ (on-earth age) 11.862615)
)

(defn on-saturn [age]
  (/ (on-earth age) 29.447498)
)

(defn on-uranus [age]
  (/ (on-earth age) 84.016846)
)

(defn on-neptune [age]
  (/ (on-earth age) 164.79132)
)
