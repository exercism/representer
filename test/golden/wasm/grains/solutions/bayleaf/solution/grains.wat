(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    (local $result i64)
    (local $i i32)
    (local $exp i32)

    (if (i32.or
          (i32.lt_s (local.get $squareNum) (i32.const 1))
          (i32.gt_s (local.get $squareNum) (i32.const 64)))
      (then (return (i64.const 0))))

    (local.set $exp (i32.sub (local.get $squareNum) (i32.const 1)))

    (local.set $result (i64.const 1))
    (local.set $i (i32.const 0))

    (block $break
      (loop $loop
        (br_if $break
          (i32.eq (local.get $i) (local.get $exp)))

        (local.set $result (i64.mul (local.get $result) (i64.const 2)))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))

        (br $loop)))


    (return (local.get $result)))

  ;; Result is unsigned
  (func (export "total") (result i64)
    (local $total i64)
    (local $i i32)

    (local.set $total (i64.const 1))
    (local.set $i (i32.const 1))

    (block $break
      (loop $loop
        (local.set $i (i32.add (local.get $i) (i32.const 1)))

        (local.set $total (i64.add (local.get $total) (call $square (local.get $i))))

        (br_if $break
          (i32.eq (local.get $i) (i32.const 64)))

        (br $loop)))

    (return (local.get $total))
  )
)
