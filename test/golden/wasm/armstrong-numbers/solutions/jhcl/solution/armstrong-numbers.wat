(module
  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $len i32)
    (local $copy_candidate i32)
    (local $sum i32)
    (local $exp i32)
    (local $copy_len i32)
    (local.set $copy_candidate (local.get $candidate))

    ;; find length of input number
    (loop $loop
      (local.set $len (i32.add (local.get $len) (i32.const 1)))
      (local.set $copy_candidate (i32.div_u (local.get $copy_candidate) (i32.const 10)))
      (br_if $loop (i32.ne (local.get $copy_candidate) (i32.const 0)))
    )

    ;; sum (digit ** length)
    (local.set $copy_candidate (local.get $candidate))
    (loop $digits
      (local.set $copy_len (local.get $len))
      (local.set $exp (i32.const 1))

      ;; calculate (digit ** length)
      (loop $exp_loop
        (local.set $exp (i32.mul (i32.rem_u (local.get $copy_candidate) (i32.const 10)) (local.get $exp)))
        (local.set $copy_len (i32.sub (local.get $copy_len) (i32.const 1)))
        (br_if $exp_loop (i32.ne (local.get $copy_len) (i32.const 0)))
      )

      (local.set $sum (i32.add (local.get $sum) (local.get $exp)))
      (local.set $copy_candidate (i32.div_u (local.get $copy_candidate) (i32.const 10)))
      (br_if $digits (i32.ne (local.get $copy_candidate) (i32.const 0)))
    )
    (i32.eq (local.get $sum) (local.get $candidate))
  )
)
