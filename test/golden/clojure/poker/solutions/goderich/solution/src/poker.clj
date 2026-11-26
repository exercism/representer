(ns poker)

(defn- ranks [x]
  (case x
   "J"  11
   "Q"  12
   "K"  13
   "A"  14
   (Integer/parseInt x)))

(defn- parse-hand [hand]
  (->> hand
       (re-seq #"([0-9JQKA]+)([DHSC])")
       (map (fn [[_ r s]] [(ranks r) s]))))

(defn- hand->map [hand]
  (let [transformed-data
        (->> (parse-hand hand)
             (map first)
             (frequencies)
             (sort-by first >)
             (sort-by second >))]
    {:seq transformed-data
     :str hand}))

(defn- full-house? [hand-map]
  (let [[[_ x] [_ y]] (:seq hand-map)]
       (and (= x 3) (= y 2))))

(defn- quad? [hand-map]
  (let [[[_ n]] (:seq hand-map)]
    (= n 4)))

(defn- triplet? [hand-map]
  (let [[[_ n]] (:seq hand-map)]
    (= n 3)))

(defn- two-pair? [hand-map]
  (let [[[_ n] [_ m]] (:seq hand-map)]
    (= n m 2)))

(defn- pair? [hand-map]
  (let [[[_ n]] (:seq hand-map)]
    (= n 2)))

(defn- straight? [hand-map]
  (let [cs (set (map first (:seq hand-map)))]
    (->> ["A" "2" "3" "4" "5" "6" "7" "8" "9" "10" "J" "Q" "K" "A"]
         (map ranks)
         (partition 5 1)
         (map set)
         (some #(= cs %)))))

(defn- flush? [hand-map]
  (->> hand-map :str parse-hand (map second) set count (= 1)))

(defn- straight-flush? [hand]
  (and (straight? hand) (flush? hand)))

(defn- fix-ace-straight [m]
  (if (= [14 5 4 3 2] (:seq m))
    (assoc m :seq [5 4 3 2 1])
    m))

(defn- filter-by-highest [ms]
  (let [max-card (apply max (map (comp first :seq) ms))
        remove? (fn [m] (> max-card (first (:seq m))))]
    (->> (remove remove? ms)
         (map #(update % :seq rest)))))

(defn- tiebreak [ms]
  (let [with-card-vals (fn [m] (update m :seq #(map first %)))
        winner? (fn [ms]
                  (or (= 1 (count ms))
                      (empty? (filter seq (map :seq ms)))))]
    (loop [ms (map (comp fix-ace-straight with-card-vals) ms)]
      (if (winner? ms)
        (map :str ms)
        (recur (filter-by-highest ms))))))

(defn best-hands [hands]
  (let [ms (map hand->map hands)
        fs [straight-flush? quad? full-house? flush? straight? triplet? two-pair? pair?]
        combo (first (drop-while #(not-any? % ms) fs))]
    (if combo
      (tiebreak (filter combo ms))
      (tiebreak ms))))
