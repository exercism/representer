(ns gigasecond)

(defn- mjd
  "Calculates the Modified Julian Date of given Y M D."
  [y m d]
  (let [y (if (< m 3) (dec y) y)
        m (if (< m 3) (+ 12 m) m)]
    (+ (int (* 365.25 y))
       (quot y 400)
       (- (quot y 100))
       (int (* 30.59 (- m 2)))
       d
       (- 678912))))

(defn- mjd-to-ymd
  "Converts a Modified Julian Date into [Y M D]."
  [mjd]
  (let [y (quot (- mjd 15078.2) 365.25)
        m (quot (- mjd 14956.1 (int (* y 365.25))) 30.6001)
        d (- mjd 14956 (int (* y 365.25)) (int (* m 30.6001)))]
    [(int (+ y 1900 (if (> m 13) 1 0)))
     (int (- m 1 (if (> m 13) 12 0)))
     d]))

(defn from
  "Write a program that calculates the moment when someone has lived for 10^9 seconds."
  [y m d]
  (mjd-to-ymd (quot (+ (* (mjd y m d) 24 60 60) 1000000000) (* 24 60 60))))