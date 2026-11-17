(ns armstrong-numbers) (defn armstrong? [num] (=(reduce + (map #(apply * (repeat (count (str num)) %)) (map #(- % 48) (map int (str num)))))num) )
