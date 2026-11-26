(module
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;;; if (squareNum <= 0 || squareNum > 64) return 0
    (if
      (i32.or
        (i32.le_s (local.get $squareNum) (i32.const 0))
        (i32.gt_s (local.get $squareNum) (i32.const 64))
      )
      (return (i64.const 0))
    )
    ;;; 1 << (squareNum - 1)
    (i64.shl (i64.const 1) (i64.extend_i32_s (i32.sub (local.get $squareNum) (i32.const 1))))
  )
  ;; i64 -1 interpreted as unsigned is 2**65 - 1
  (func (export "total") (result i64) i64.const -1)
)
