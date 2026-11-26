(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (i32.and 
        (i32.gt_s (local.get $squareNum) (i32.const 0)) 
        (i32.lt_s (local.get $squareNum) (i32.const 65))
    )
    (if (result i64)
      (then 
        (block (result i64)
          i64.const 1
          local.get $squareNum
          i64.extend_i32_s
          i64.const 1
          i64.sub
          i64.shl
        )
      )
      (else i64.const 0)
    )
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    i64.const -1
  )
)
