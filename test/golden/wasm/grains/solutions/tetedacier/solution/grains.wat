(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $twoPower (param $exponent i32) (result i64)
    (i64.shl (i64.const 1) (i64.extend_i32_s (local.get $exponent)))
  )
  (func $square (export "square") (param $squareNum i32) (result i64)
    (if
      (result i64)
      (i32.eq (i32.le_s (local.get $squareNum) (i32.const 0)) (i32.const 1))
      (then (i64.const 0))
      (else
          (if
            (result i64)
            (i32.eq (i32.gt_s (local.get $squareNum) (i32.const 64)) (i32.const 1))
            (then (i64.const 0))
            (else (
              call $twoPower (i32.sub (local.get $squareNum) (i32.const 1))
            ))
          )
      )
    )
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $sum i64)
    (local $exponents i32)
    (local.set $sum (i64.const 0))
    (local.set $exponents (i32.const 0))
    (loop $sumSquare
      (local.set $sum (i64.add (local.get $sum) (call $twoPower (local.get $exponents))))
      (local.set $exponents (i32.add (local.get $exponents) (i32.const 1)))
      (if
        (i32.eq (i32.lt_s (local.get $exponents) (i32.const 64)) (i32.const 1))
        (then (br $sumSquare))
      )
    )
    (local.get $sum)
  )
)
