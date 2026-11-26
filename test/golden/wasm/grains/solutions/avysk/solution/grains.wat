(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    local.get $squareNum
    i32.const 1
    i32.lt_s
    (if (then (return (i64.const 0))))
    local.get $squareNum
    i32.const 64
    i32.gt_s
    (if (then (return (i64.const 0))))
    i64.const 1
    local.get $squareNum
    i32.const 1
    i32.sub
    i64.extend_i32_u
    i64.shl
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    i64.const 0
    i64.const 1
    i64.sub
  )
)
