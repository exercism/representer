(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (local $total i64)
    (if
      (i32.le_s
        (local.get $squareNum)
        (i32.const 0))
      (then
        (return
          (i64.const 0))))
    (local.set $total
      (i64.const 1))
    (block $out
      (loop $mul
        (local.set $squareNum
          (i32.sub
            (local.get $squareNum)
            (i32.const 1)))
        (br_if $out
          (i32.eqz
            (local.get $squareNum)))
        (local.set $total
          (i64.mul
            (local.get $total)
            (i64.const 2)))
        (br $mul)))
    (local.get $total)
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $total i64)
    (local $i i32)
    (local.set $i
      (i32.const 64))
    (loop $add
      (local.set $total
        (i64.add
          (local.get $total)
          (call $square
            (local.get $i))))
      (local.set $i
        (i32.sub
          (local.get $i)
          (i32.const 1)))
      (br_if $add
        (i32.gt_u
          (local.get $i)
          (i32.const 0))))
    (local.get $total)
  )
)
