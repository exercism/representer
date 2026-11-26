(ns bank-account)

(defn open-account []
  (atom {:open-account true :balance 0}))

(def my-account (open-account))

(defn close-account [my-account]
  (reset! my-account nil))

(defn get-balance [token]
  (if token (:balance @token) 0))

(defn update-balance [token value]
  (swap! token update :balance - value))