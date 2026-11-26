(ns run-length-encoding)

(defn run-length-encode
  "encodes a string with run-length-encoding"
  [plain-text]
  (loop [[current & rest] plain-text
         previous current
         count 0
         result ""]
    (let [temp-result (str result (when (> count 1) count) previous)]
      (cond
        (nil? current) temp-result
        (not= current previous) (recur rest current 1 temp-result)
        :else (recur rest current (inc count) result)))))

(defn parse-int
  "Parses a string into an integer. Returns `nil` if the string can't
  be parsed."
  [string]
  (try (Integer. string)
       (catch NumberFormatException _ nil)))

(defn expand-rle
  "Given a run-length-encoded pair, expand into the repeated characters.
  For example, '5g' -> 'ggggg' or 'a' -> 'a'."
  [rle-pair]
  (let [[_ count ch] (re-find #"(\d*)(\D)" rle-pair)
        count (parse-int count)]
    (if-not count
      (str ch)
      (apply str (repeat count ch)))))

(defn run-length-decode
  "decodes a run-length-encoded string"
  [cipher-text]
  (->> cipher-text
       (re-seq #"\d*\D")
       (map expand-rle)
       (apply str)))
