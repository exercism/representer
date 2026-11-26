(module
  (func (export "steps") (param $number i32) (result i32)
    (local $steps i32)
    (local.set $steps (i32.const 0))

    (if (i32.le_s (local.get $number) (i32.const 0))
      (then (return (i32.const -1)))
    )

    (loop $loop
      (if (i32.eq (local.get $number) (i32.const 1))
        (then (return (local.get $steps)))
      )

      (if (i32.and (local.get $number) (i32.const 1))
        (then
          (local.set $number (i32.add (i32.mul (local.get $number) (i32.const 3)) (i32.const 1)))
        )
        (else
          (local.set $number (i32.div_s (local.get $number) (i32.const 2)))
        )
      )

      (local.set $steps (i32.add (local.get $steps) (i32.const 1)))

      br $loop
    )

    unreachable
  )
)
