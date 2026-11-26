(ns run-length-encoding)

(defn run-length-encode
  "encodes a string with run-length-encoding"
  [plain-text]
  (->> plain-text
       (partition-by identity)
       (mapcat (juxt count first))
       (remove #{1})
       (apply str)))

(defn run-length-decode
  "decodes a run-length-encoded string, replacing a digit by the character repetition"
  [cipher-text]
  (->> (re-seq #"(\d+)?(\D)" cipher-text)
       (mapcat (fn [[_ n c]] (repeat (Long/valueOf (or n 1)) c)))
       (apply str)))
