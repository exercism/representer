(ns etl
  (:require [clojure.string :as str])
)

(defn transform [source]
  (->>
    (mapcat #(apply repeat %) source)
    flatten
    (map #(str/lower-case %))
    frequencies
    )
  )
