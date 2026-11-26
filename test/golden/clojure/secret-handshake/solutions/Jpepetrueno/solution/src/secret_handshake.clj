(ns secret-handshake)

(defn commands
  "Convert a number `n` into a vector of actions."
  [n]
  (cond-> []
    (bit-test n 0) (conj "wink")
    (bit-test n 1) (conj "double blink")
    (bit-test n 2) (conj "close your eyes")
    (bit-test n 3) (conj "jump")
    (bit-test n 4) (reverse)))
