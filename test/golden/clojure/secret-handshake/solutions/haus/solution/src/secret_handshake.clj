(ns secret-handshake)

(defn commands [command]
  (cond-> []
    (bit-test command 0) (conj "wink")
    (bit-test command 1) (conj "double blink")
    (bit-test command 2) (conj "close your eyes")
    (bit-test command 3) (conj "jump")
    (bit-test command 4) reverse))
