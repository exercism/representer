fun nthPrime n =
  if n < 1 then NONE else SOME (nthPrime' n 2)

and nthPrime' 1 p = p
  | nthPrime' n p =
      if isPrime (p + 1) then nthPrime' (n - 1) (p + 1) else nthPrime' n (p + 1)

and isPrime 2 = true
  | isPrime n =
      n > 2 andalso Int.rem (n, 2) <> 0 andalso
      let
        val root = floor (Math.sqrt (Real.fromInt n))
        val m = ref 3
        val result = ref true
        val continue = ref true
      in
        while !continue andalso !m <= root do
          (if Int.rem (n, !m) = 0 then (continue := false; result := false)
           else m := (!m) + 2);
        !result
      end
