(ns run-length-encoding)

(defn encode-block [plain-block]
  (let [letter (first plain-block)
        letter-count (count plain-block)]
    (if (= 1 letter-count)
      (str letter)
      (str letter-count letter))))

(defn extract-letter-count [cypher-block]
  (->> cypher-block
       (drop-last)
       (apply str)
       (Integer/parseInt)))

(defn decode-block [cypher-block]
  (if (= 1 (count cypher-block))
    (str cypher-block)
    (let [letter (last cypher-block)
          letter-count (extract-letter-count cypher-block)]
      (->> letter
           (repeat letter-count)
           (apply str)))))

(defn run-length-encode
  "encodes a string with run-length-encoding"
  [plain-text]
  (->> plain-text
       (partition-by identity)
       (map encode-block)
       (apply str)))

(defn run-length-decode
  "decodes a run-length-encoded string"
  [cipher-text]
  (let [cypher-structure #"[0-9]*[a-zA-Z\s]"]
    (->> cipher-text
         (re-seq cypher-structure)
         (map decode-block)
         (apply str))))
