(ns grade-school)

(defn add [school pupil grade]
  (update-in school [grade] (fnil conj []) pupil))

(defn grade [school grade]
  (school grade []))

(defn sorted [school]
  (into {} (sort (reduce-kv (fn [m k v]
                         (assoc m k (sort v)))
                       {}
                       school))))