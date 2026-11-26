(ns interest-is-interesting)

(defn- percent-to-value [percent-value]
  (* percent-value 100.0M))


(defn interest-rate
  "Calculate interest rate based on account balance"
  [balance]
  (cond
    (neg? balance) -3.213
    (< balance 1000) 0.5
    (< balance 5000) 1.621
    :else 2.475)
  )

(defn annual-balance-update
  "Calculate the updated balance after adding the interest rate"
  [balance]
  (bigdec (* balance (+ 1 (abs (percent-to-value (bigdec (interest-rate balance)))))))
  )

(defn amount-to-donate
  "Calculate how much to donate to chaity based on balance and the percentage that is tax free"
  [balance tax-free-percentage]
  (if (pos? balance)
   (int (* balance 2 (percent-to-value tax-free-percentage)))
   0)
  )


(comment
  (interest-rate 200.75M)
  (interest-rate 1234M)
  (interest-rate -0.123M)
  (annual-balance-update 200.75M)
  (percent-to-value (bigdec (interest-rate -0.123M)))
  (bigdec (* -0.123M (+ 1 (abs (percent-to-value (interest-rate -0.123M))))))
  (annual-balance-update -0.123M)
  (def balance 550.5M)
  (def tax-free-percentage 2.5)
  (amount-to-donate balance tax-free-percentage)
  :rcf)

