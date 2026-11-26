(ns run-length-encoding)

(defn run-length-encode [plain-text]
  "encodes a string with run-length-encoding"
  (clojure.string/replace
   plain-text
   #"(.)\1+"
   (fn [[full-match matched-char]]
     (str
      (count full-match)
      matched-char))))

(defn run-length-decode
  "decodes a run-length-encoded string"
  [cipher-text]
  (clojure.string/replace
   cipher-text
   #"(\d+)?([^\d])"
   (fn [[full-match count char]]
     (apply str
            (repeat
             (if count (Integer/parseInt count) 1)
             char)))))
