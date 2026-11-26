;; Clojure solution to Exercism's "Crypto-Square" problem:
;;
;; https://exercism.org/tracks/clojure/exercises/crypto-square
;;
;; This solution is longer, more awkward, and more complicated than necessary
;; because the output formats dictated by the "intermediate" functions the
;; tests requires are, in each case, _not_ the ideal forms in which to
;; have the data for that particular step. So for each mandated function,
;; there's one function which gets the data into the "best" form for that
;; particular step, and then _another_ function that turns that form into
;; the form required to pass the tests. Were the goal just to implement
;; `normalize-ciphertext`, this would be a much cleaner solution.

(ns crypto-square
  (:require [clojure.string :as str]))

(def zero (int \0))
(def nine (int \9))
(def big-a (int \A))
(def big-z (int \Z))
(def small-a (int \a))
(def small-z (int \z))

(def upper-lower-offset (- small-a big-a))

(defn normalize-character
  "Return the normalized character, or nil if invalid for normalized text."
  [c]
  (let [d (int c)]
    (cond
      (< d zero) nil
      (<= d nine) c
      (< d big-a) nil
      (<= d big-z) (char (+ d upper-lower-offset))
      (< d small-a) nil
      (<= d small-z) c
      :else nil)))

(defn normalized-plaintext-seq
  "Return a sequence of normalized plaintext characters."
  [plaintext]
  (keep normalize-character (seq plaintext)))

(defn normalize-plaintext
  "Return the given plaintext normalized as a string."
  [plaintext]
  (apply str (normalized-plaintext-seq plaintext)))

(defn width-given-seq
  "Given a sequence of normalized characters, calculate the grid width to use
  for encoding."
  [normalized-seq]
  (int (Math/ceil (Math/sqrt (float (count normalized-seq))))))

(defn square-size
  "Calculate the grid width to use given a plaintext string."
  [plaintext]
  (width-given-seq
    (normalized-plaintext-seq plaintext)))

(defn zip
  "Zip seq-of-seqs and append it to accum."
  [accum seq-of-seqs]
  (if (every? empty? seq-of-seqs)
      (reverse accum)
      (recur
        (apply (partial conj accum) (keep (fn [one-seq] (first one-seq)) seq-of-seqs))
        (map (fn [one-seq] (rest one-seq)) seq-of-seqs))))

(defn or-space
  "Return the supplied character, or \\space if it's nil."
  [c]
  (if (nil? c) \space c))

(defn sequence-next-segment
  "Push the next chunk of `segment-length` characters from `left` onto 'accum'.
  Will pad with spaces if there aren't `segment-length` characters left."
  [accum left segment-length]
  (let [segment (apply vector (take segment-length left))]
    (cond
      (= 0 (count segment))
        (reverse accum)
      (< (count segment) segment-length)
        (recur
          (cons 
            (map (fn [n] (or-space (get segment n))) (range segment-length))
            accum)
          (drop segment-length left)
          segment-length)
      :else (recur
              (cons segment accum)
              (drop segment-length left)
              segment-length))))

(defn sequence-segments
  "Return a list of vectors representing segments of the given plaintext."
  [plaintext]
  (let [plaintext-seq (normalized-plaintext-seq plaintext)
        segment-length (width-given-seq plaintext-seq)]
    (sequence-next-segment '() plaintext-seq segment-length)))

(defn strip-spaces
  "Remove all spaces from a sequence of characters."
  [char-seq]
  (filter (fn [c] (not= c \space)) char-seq))

(defn plaintext-segments
  "Return a sequence of strings representing the rows of a crypto-square
  built from the supplied plaintext."
  [plaintext]
    (map
      (fn [segment] (apply str (strip-spaces segment)))
      (sequence-segments plaintext)))

(defn ciphertext
  "Generate a string of ciphertext from the supplied plaintext enciphered with
  the crypto-square cipher."
  [plaintext]
    (apply str
      (zip '()
        (map strip-spaces
             (sequence-segments plaintext)))))

(defn normalize-ciphertext
  "Generate the *normalized* ciphertext from enciphering the supplied
  plaintext. This is split into the columns of the enciphering square,
  separated by spaces, with shorter columns padded with spaces."
  [plaintext]
  (let [segments (sequence-segments plaintext)
        segment-length (count segments)
        ciphertext-seq (zip '() segments)]
    (str/join " "
      (map (fn [x] (apply str x))
        (sequence-next-segment '() ciphertext-seq segment-length)))))
