(ns interest-is-interesting)

(defn big-abs [num] (bigdec (if (neg? num) (- num) num)))

(defn interest-rate
  "Calculate the interest rate based on the specified balance"
  [balance]
  (cond
    (< balance  0) -3.213
    (< balance  1000) 0.5
    (< balance  5000) 1.621
    :else 2.475))


(defn annual-balance-update
  "Add the interest rate calculate to annual balance update "
  [balance]
  (let [interest-rate (big-abs (interest-rate balance))
        perc-change (* 0.01M (+ 100 interest-rate))]
    (* balance perc-change)))



(defn amount-to-donate
  "Donation based on balance and  tax-free percentage "
  [balance tax-free-percentage]
  (cond
    (> balance 0) (-> balance
                      (* (* 0.01 tax-free-percentage))
                      (* 2)
                      int)

    :else 0))