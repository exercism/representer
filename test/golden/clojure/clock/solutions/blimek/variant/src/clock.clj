(ns clock)

(def full-day (* 24 60))

(defn- substract-full-days [time]
    (rem time full-day))

(defn- to-time [[hours minutes]]
       (+ (* hours 60) minutes))

(defn- reverse-negative-time [time]
       (if (neg? time)
         (- full-day time)
         time))

(defn- normalize [time]
       (-> time
           substract-full-days
           reverse-negative-time))

(defn clock [hours minutes]
  (-> [hours minutes]
      to-time
      normalize))

(defn- clock->hm [time]
  (let [h (rem (quot time 60) 24) m (rem time 60)]
    [h m]))

(defn clock->string [time]
  (let [[h m] (clock->hm time)]
    (format "%02d:%02d" h m)))


(defn add-time [clock time]
  (-> time
      (+ clock)
      normalize))
