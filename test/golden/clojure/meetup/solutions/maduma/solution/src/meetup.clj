(ns meetup
  (:import (java.time LocalDate DayOfWeek)))

(def ^:private teenth
  (partial some
           (fn [date]
             (let [day (.getDayOfMonth date)]
               (when (and (> day 12) (< day 20)) date)))))

(def ^:private selections
  {:first first
   :second second
   :third (comp first (partial drop 2))
   :fourth (comp first (partial drop 3))
   :fifth (comp first (partial drop 4))
   :last last
   :teenth teenth})

(def ^:private week_days
  {:monday DayOfWeek/MONDAY
   :tuesday DayOfWeek/TUESDAY
   :wednesday DayOfWeek/WEDNESDAY
   :thursday DayOfWeek/THURSDAY
   :friday DayOfWeek/FRIDAY
   :saturday DayOfWeek/SATURDAY
   :sunday DayOfWeek/SUNDAY})

(defn meetup [month year day desciptor]
  (let [date (LocalDate/of year month 1)
        len (.lengthOfMonth date)
        date (->> (for [n (range 1 (inc len))] (.withDayOfMonth date n))
                  (filter #(= (.getDayOfWeek %) (week_days day)))
                  ((selections desciptor)))]
    [(.getYear date) (.getMonthValue date) (.getDayOfMonth date)]))