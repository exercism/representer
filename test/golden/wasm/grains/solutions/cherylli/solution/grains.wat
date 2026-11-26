(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;; Check if the squareNum is within the valid range (1 to 64)
    (if (i32.or
          (i32.lt_s (local.get $squareNum) (i32.const 1))
          (i32.gt_s (local.get $squareNum) (i32.const 64)))
      (then
        ;; Return 0 to indicate an error for an invalid squareNum
        (return (i64.const 0))
      )      
    )
    ;; square the number
    (i64.shl
      (i64.const 1)
      (i64.extend_i32_u (i32.sub (local.get $squareNum) (i32.const 1)))
    )
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    ;; Calculate the total number of grains on the chessboard
    (i64.const -1)
  )
)