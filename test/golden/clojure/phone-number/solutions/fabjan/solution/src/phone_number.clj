(ns phone-number)

(defn parse-nanp [num-string]
  "parse the given North American phone number into a map"
  (let [digits (apply str (filter #(Character/isDigit ^char %) num-string))
        [all _ area exchange subscriber] (re-find #"^(1|)([2-9][0-9][0-9])([2-9][0-9][0-9])([0-9]{4})$" digits)]
    (if (nil? all)
      {:full "0000000000"}                                  ;; this means invalid
      {:full (str area exchange subscriber)
       :area-code area
       :exchange-code exchange
       :subscriber subscriber})))

(defn number [num-string]
  "validate and clean up the given North American phone number"
  (let [phone-number (parse-nanp num-string)]
    (:full phone-number)))

(defn area-code [num-string]
  "extract the area code from he given North American phone number"
  (:area-code (parse-nanp num-string)))

(defn pretty-print [num-string]
  "present the given North American phone number as a string '(AAA) XXX-NNNN'"
  (let [{:keys [area-code exchange-code subscriber]} (parse-nanp num-string)]
    (format "(%s) %s-%s" area-code exchange-code subscriber)))