(ns armstrong-numbers) (defn exp [x n] (reduce * (repeat n x))) (defn armstrong? [num] ( = num (reduce + (map #(exp % (count (seq (str num)))) (map #(- (int %) (int \0)) (seq (str num))))) ) )
