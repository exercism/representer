(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (if
      (i32.or
          (i32.le_s (local.get $squareNum) (i32.const 0))
          (i32.gt_s (local.get $squareNum) (i32.const 64))
      )
      (then
        (return (i64.const 0))
      )
    )

    (return
      (i64.shl
        (i64.const 1)
        (i64.sub (i64.extend_i32_u (local.get $squareNum)) (i64.const 1))
      )
    )
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $i i32)
    (local $sum i64)

    (loop
      (local.set $sum
        (i64.add
          (local.get $sum)
          (call $square (local.tee $i (i32.add (local.get $i) (i32.const 1))))
        )
      )

      (br_if 0 (i32.lt_u (local.get $i) (i32.const 64)))
    )

    (return (local.get $sum))
  )
)
