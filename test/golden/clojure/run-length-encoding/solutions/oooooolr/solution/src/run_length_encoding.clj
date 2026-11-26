(ns run-length-encoding)


(defn run-length-encode
  [plain-text]
  (->> (partition-by identity plain-text)
       (mapcat (juxt count first))
       (remove #{1})
       (apply str)))


(defn run-length-decode
  "decodes a run-length-encoded string"
  [cipher-text]
  (->> (re-seq #"(\d+)?(\D)" cipher-text)
       (mapcat (fn [[_ n c]]
                 (repeat (Long/valueOf (or n 1)) c)))
       (apply str)))
