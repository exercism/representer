(ns interest-is-interesting)

(defn interest-rate
  "Returns the interest rate based on the specified balance."
  [balance]
  (let [interests [-3.213 0.5 1.621 2.475]
        limits [0 1000 5000]
        x (count (take-while #(>= balance %) limits))]
    (double (get interests x))))

(defn annual-balance-update
  "Returns the annual balance update, taking into account the interest rate."
  [balance]
  (+ balance (* balance 1/100 (bigdec (Math/abs (interest-rate balance))))))

(defn amount-to-donate
  "Returns how much money to donate based on the balance and the tax-free percentage."
  [balance tax-free-percentage]
  (int (if (> balance 0)  (Math/floor (* balance (* 2 (/ tax-free-percentage 100)))) 0)))