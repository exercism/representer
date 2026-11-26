(module
  (func (export "steps") (param $number i32) (result i32)
    (if
      ;; Check if the input is valid, must be a number greater than 0
      (i32.le_s (local.get $number) (i32.const 0))
      (return (i32.const -1))
    )
    ;; Start recursion
    (call $collatz_rec (local.get $number) (i32.const 0))
  )
  (func $collatz_rec (param $n i32) (param $i i32) (result i32)
    (local $n2 i32)
    ;; base case n = 1
    (if
      (i32.eq (local.get $n) (i32.const 1))
      (return (local.get $i))
    )
    ;; Check input number for even/odd
    (if
      (i32.rem_u (local.get $n) (i32.const 2))
      ;; n is odd
      (then 
        (local.set $n2 ;; 3n + 1
          (i32.add
              (i32.mul (i32.const 3) (local.get $n))
              (i32.const 1)
          )
        )
      )
      ;; otherwise n is even
      (else
        (local.set $n2;; n / 2
          (i32.div_u (local.get $n) (i32.const 2))
        )
      )
    )
    (call $collatz_rec (local.get $n2) (i32.add (local.get $i) (i32.const 1)))
  )
)