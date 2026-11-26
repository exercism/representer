(ns bob)

(def responses {
  :ask "Sure."
  :yell "Whoa, chill out!"
  :askyell "Calm down, I know what I'm doing!"
  :sentence "Whatever."
  :else "Fine. Be that way!"
})

(defn sentence-type [s]
  (let [has-lowercase (re-find #"[a-z]" s)
        has-uppercase (re-find #"[A-Z]" s)
        has-number (re-find #"[0-9]" s)
        is-question (re-find #"\?\s*$" s)]
    (cond
      (and (not has-lowercase) has-uppercase is-question)
        :askyell
      (and (not has-lowercase) has-uppercase)
        :yell
      is-question
        :ask
      (or has-lowercase has-number)
        :sentence
      :else
        :else)))

(defn response-for [s]
  ((sentence-type s) responses))
