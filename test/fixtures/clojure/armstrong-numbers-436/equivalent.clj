(ns armstrong-numbers) "Checks if a number is an armstrong number by taking each digit, raising them to the power of the number of digits
then adding them together to get number again" (defn armstrong? [num] (->> (str num) seq (map str) (map read-string) (map #(reduce * (repeat (count (str num)) %))) (reduce +) (= num)))
