(ns go-counting)

(defn get-point [grid [x y]]
  (get-in grid [y x]))

(defn adj [grid [x y]]
  (->> [[(inc x) y] [(dec x) y] [x (inc y)] [x (dec y)]]
       (filter #(get-point grid %))))

(defn update-owner [old new]
  (when (#{new :unknown} old) new))

(defn territory [grid point]
  {:pre [(get-point grid point)]}
  (loop [[p & more] [point]
         {:keys [stones] :as res} {:stones #{} :owner :unknown}]
    (cond
      (nil? p) (update res :owner #(when (seq stones) (#{:white :black} %)))
      (stones p) (recur more res)
      :else (if-let [owner (-> (get-point grid p) {\W :white \B :black})]
              (recur more (update res :owner update-owner owner))
              (recur (concat more (adj grid p)) (update res :stones conj p))))))

(defn all-points [grid]
  (for [x (range (count (first grid)))
        y (range (count grid))]
    [x y]))

(def owner-key-mapping
  {:black :black-territory :white :white-territory nil :null-territory})

(defn territories [grid]
  (loop [[p & more] (all-points grid)
         res {:black-territory #{} :white-territory #{} :null-territory #{}}]
    (cond
      (nil? p) res
      (every? #(% p) (vals res)) (recur more res)
      :else (let [{:keys [stones owner]} (territory grid p)
                  k (owner-key-mapping owner)]
              (recur more (update res k into stones))))))