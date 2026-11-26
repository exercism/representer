(ns reverse-string)

(defn reverse-string [s]
  (apply str (into () s))) ;; The challenge is to not use the built-in reverse function :)