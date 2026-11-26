(module
  (func $advance (param $number i32) (result i32)
    ;; Test odd/even by inspecting lowest bit
    (if (result i32)
      (i32.and (i32.const 1) (local.get $number))
      (then ;; odd, n1 = n0 * 3 + 1
        (i32.add
                  (i32.mul (i32.const 3) (local.get $number) )
                  (i32.const 1))
        )
      (else ;; even, n1 = n0 / 2
        (i32.div_u (local.get $number) (i32.const 2))
        )
      )
    )
  (func (export "steps") (param $number i32) (result i32)
    ;; Error if $number <= 0
    (if (i32.le_s (local.get $number) (i32.const 0))
      (then
        (return (i32.const -1))
        )
      )

    (block $break (result i32)
      ;; Track num_steps on stack (our return val)
      i32.const 0
      (loop $next (param i32) (result i32)
        ;; If $number = 1; we're done
        (br_if $break (i32.eq (local.get $number) (i32.const 1)))
        ;; Else, advance to the next item of the collatz sequence
        ;; increment $steps
        (local.set $number (call $advance (local.get $number)))
        i32.const 1
        i32.add
        ;; Go back to loop
        br $next
        )
      )
    )
  )
