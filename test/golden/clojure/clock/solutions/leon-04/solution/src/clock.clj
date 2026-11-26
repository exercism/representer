(ns clock)

(def max-minutes
  (* 24 60))

(defn clock->string [{:keys [min]}]
  (format "%02d:%02d"
          (quot min 60)
          (mod min 60)))

(defn clock
  ([hours minutes]
   (clock (+ (* 60 hours) minutes)))
  ([minutes]
   {:min
    (mod minutes max-minutes)}))

(defn add-time [{:keys [min]} minutes]
  (clock
    (+ min minutes)))