(ns armstrong-numbers) (defn ** [x n] (reduce * (repeat n x)) ) (defn armstrong? [num] (= num (reduce + (map #(** % (count (str num))) (map #(Character/digit % 10) (str num))))) )
