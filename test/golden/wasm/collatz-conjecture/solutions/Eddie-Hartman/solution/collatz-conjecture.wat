(module
  (func (export "steps") (param $number i32) (result i32)
    (local $steps i32)
    (local $current i32)

    ;; Return -1 if value is less than 1
    local.get $number
    i32.const 1
    i32.lt_s
    if
      i32.const -1
      return
    end

    ;; Return 0 if value is already 1
    i32.const 1
    local.get $number
    i32.eq
    if
      i32.const 0
      return
    end

    ;; Initialize current value with input number
    (local.set $current (local.get $number))
    (local.set $steps (i32.const 0))

    (block
      (loop
        (br_if 1 (i32.eq (local.get $current) (i32.const 1)))

        ;; Check if current is even or odd
        (if (i32.eqz (i32.and (local.get $current) (i32.const 1)))
          (then 
            ;; current is even, current = current / 2
            (local.set $current (i32.shr_u (local.get $current) (i32.const 1)))
          )
          (else
            ;; current is odd, current = 3current + 1
            (local.set $current (i32.add (i32.mul (local.get $current) (i32.const 3)) (i32.const 1)))
          )
        )

        ;; Increment steps
        (local.set $steps (i32.add (local.get $steps) (i32.const 1)))
        (br 0)
      )
    )

    local.get $steps
    return
  )
)