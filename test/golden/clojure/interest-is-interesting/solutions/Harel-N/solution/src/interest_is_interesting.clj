(ns interest-is-interesting)

(defn interest-rate
  "Get the balance and return the interest rate"
  [balance]
  (cond
    (< balance 0M) -3.213
    (< balance 1000M) 0.5
    (< balance 5000M) 1.621
    :else 2.475))

(defn annual-balance-update
  "Calculate the annual balance update"
  [balance]
  (+ balance
     (* balance
        1/100
        (bigdec (Math/abs (interest-rate balance))))))


(defn amount-to-donate
  "Calculate how much money to donate"
  [balance tax-free-percentage]
  (if (< balance 0)
    0
    (int (* balance (/ (* 2M tax-free-percentage) 100M)))))