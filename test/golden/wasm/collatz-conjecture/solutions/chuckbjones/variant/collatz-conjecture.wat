(module
  (func (export "steps") (param $number i32) (result i32)
    (local $cnt i32)

    (if (i32.le_s (local.get $number) (i32.const 0))
      (return (i32.const -1))
    )

    (if (i32.eq (local.get $number) (i32.const 1))
      (return (i32.const 0))
    )

    (local.set $cnt (i32.const 0))
    (loop $cntLoop
      (local.set $number (call $calcCollatz (local.get $number) ) )
      (local.set $cnt (i32.add (local.get $cnt) (i32.const 1) ) )
      (br_if 0 (i32.ge_s (local.get $number) (i32.const 1)))
    )
    (return (local.get $cnt))
  )

  (func $calcCollatz (param $number i32) (result i32)
    (if (result i32)
      (i32.and (local.get $number) (i32.const 1))
      (then ;; odd - 3 * n + 1
        (return (i32.add (i32.mul (local.get $number) (i32.const 3)) (i32.const 1)))
      )
      (else ;; even - n / 2
        (return (i32.shr_s (local.get $number) (i32.const 1)))
      )
    )
  )
)
