(module
  (func (export "steps") (param $number i32) (result i32)
    (local $count i32)

    (if (i32.le_s (local.get $number) (i32.const 0))
      (then
        (return (i32.const -1))
      )
    )

    (if (i32.eq (local.get $number) (i32.const 1))
      (then
        (return (i32.const 0))
      )
    )

    (loop $main
        (if (i32.eqz (i32.rem_u (local.get $number) (i32.const 2)))
          (then
            (local.set $number
              (i32.div_u (local.get $number) (i32.const 2))
            )
          )
          (else
            (local.set $number
              (i32.add
                (i32.mul (local.get $number) (i32.const 3))
                (i32.const 1)
              )
            )
          )
        )

      (local.set $count
        (i32.add (local.get $count) (i32.const 1))
      )

      (i32.ne (local.get $number) (i32.const 1))
      (br_if $main)
    )

    (return (local.get $count))
  )
)
