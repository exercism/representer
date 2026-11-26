(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;; Check if square num in valid range
    (if 
      (i32.or
        (i32.lt_s (local.get $squareNum) (i32.const 1))
        (i32.gt_s (local.get $squareNum) (i32.const 64))
      )
    (then 
      (return (i64.const 0)))
    )

    (i64.const 1)            ;; Starting with base 1
    (i32.sub (local.get $squareNum) (i32.const 1))  ;; The number of bit to shift left 
    (i64.extend_i32_s)       ;; Convert the result to a 64-bit integer
    (i64.shl)                ;; Left-shift by the converted result
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (i64.const 0xFFFFFFFFFFFFFFFF) ;; Maximum value of unsigned 64 bits
  )
)
