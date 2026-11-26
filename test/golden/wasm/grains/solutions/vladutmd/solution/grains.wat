(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;; ok so square 0, negative square or square greater than 64 have no value
    ;; so let's start with an if check for those
    (if (i32.or
          (i32.lt_s (local.get $squareNum) (i32.const 1))
          (i32.gt_s (local.get $squareNum) (i32.const 64)))
      (then (return (i64.const 0))))
    ;; otherwise, we are within the [1, 64] range for $squareNum
    ;; the number of grains on a specific square is 2^(squareNum - 1)
    ;; since there is no power operator in wasm, we need to shift 
    ;; our bits to the left by (squareNum - 1)
    ;; BUT our squareNum is 32 bits, we need to extend it 
    ;; (https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Numeric/Extend)
    ;; to 64 bits
    (i64.shl 
      (i64.const 1)
      (i64.sub
        (i64.extend_i32_s (local.get $squareNum))
        (i64.const 1)
      )
    )
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    ;; well the total is 2^64 - 1. can't do 2^64 or we'll overflow
    ;; since it's unsigned, let's return -1
    (return (i64.const -1))
  )
)






