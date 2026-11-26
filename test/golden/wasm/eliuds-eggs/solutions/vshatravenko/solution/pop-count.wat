(module
  (func (export "eggCount") (param $number i32) (result i32)
    (local $count i32)
    (loop $main
      (if (i32.eqz (local.get $number))
        (then
          (return (local.get $count))
        )
      )

      (if
        (i32.eq
          (i32.and (local.get $number) (i32.const 1))
          (i32.const 1)
        )
        (then
          (local.set $count (i32.add (local.get $count) (i32.const 1)))
        )
      )

      (local.set $number (i32.shr_s (local.get $number) (i32.const 1)))

      (br_if $main (i32.ne (local.get $number) (i32.const 0)))
    )

    (return (local.get $count))
  )
)
