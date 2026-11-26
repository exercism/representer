(module
  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $result i32)(local $tmp i32)(local $i i32)
    (local.set $tmp (local.get $candidate))
    (loop $l
      (local.set $i (i32.add(local.get $i)(i32.const 1)))
      (local.set $tmp (i32.div_u (local.get $tmp)(i32.const 10)))
      (br_if $l (local.get $tmp))
    )
    (local.set $tmp (local.get $candidate))
    (loop $l
      (local.set $result (i32.add
        (local.get $result)
        (call $power_of (i32.rem_u(local.get $tmp)(i32.const 10))(local.get $i))))
      (local.set $tmp (i32.div_u (local.get $tmp)(i32.const 10)))
      (br_if $l (local.get $tmp))
    )
    (i32.eq (local.get $result)(local.get $candidate))
  )

  ;; Calculate x to the power of y
  (func $power_of (param $base i32)(param $to_the_power_of i32)(result i32)
    (local $i i32) (local $ret i32)
    (local.set $ret (local.get $base))
    (local.set $i (i32.const 1))
    (if(i32.eqz(local.get $to_the_power_of))(then (return (i32.const 1))))
    (if(i32.gt_u (local.get $to_the_power_of)(i32.const 1)) (then(loop $l
      (local.set $ret (i32.mul(local.get $ret)(local.get $base)))
      (local.set $i (i32.add(local.get $i)(i32.const 1)))
      (br_if $l (i32.lt_u(local.get $i)(local.get $to_the_power_of)))
    )
  ))(local.get $ret))
)
