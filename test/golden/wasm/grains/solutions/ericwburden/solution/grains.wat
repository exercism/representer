(module
  ;; Helper function, decrements an i32
  (func $decr (param $n i32) (result i32)
    (i32.sub (local.get $n) (i32.const 1))  
  )

  ;; Helper function, doubles an i64
  (func $double (param $n i64) (result i64)
    (i64.mul (local.get $n) (i64.const 2))  
  )
  
  ;; Calculate the grains of rice on a given square.
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;; Returns zero for any square prior to square 1
    (if (i32.le_s (local.get $squareNum) (i32.const 0))
      (return (i64.const 0)))

    ;; If we're on square 1, return 1 grain. Otherwise, double the result
    ;; from the previous square (recursively).
    (if (result i64) (i32.eq (local.get $squareNum) (i32.const 1))
        (then (i64.const 1))
        (else 
          local.get $squareNum
          call $decr
          call $square
          call $double
        )
    )  
  )

  ;; Calculate all the grains on the entire board. Mathematically, this
  ;; is one less than double the number of grains on the final square.
  (func (export "total") (result i64)
    i32.const 64
    call $square
    call $double
    i64.const 1
    i64.sub
  )
)
