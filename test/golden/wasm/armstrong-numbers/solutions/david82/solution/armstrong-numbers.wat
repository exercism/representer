(module
  ;; 
  ;; Determine if a number is an Armstrong number.
  ;;
  ;; @param {i32} candidate - The number to check.
  ;;
  ;; @return {i32} 1 if the number is an Armstrong number, 0 otherwise.
  ;;
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    ;; Local variables: result accumulator, temporary storage, and digit count.
    (local $result i32)(local $tmp i32)(local $i i32)
    ;; Initialize $tmp with the candidate number.
    (local.set $tmp (local.get $candidate))
    ;; Loop to calculate the number of digits in $candidate.
    (loop $l
      ;; Increment digit count.
      (local.set $i (i32.add(local.get $i)(i32.const 1)))
      ;; Divide $tmp by 10 to strip off the last digit.
      (local.set $tmp (i32.div_u (local.get $tmp)(i32.const 10)))
      ;; Continue looping if $tmp is not yet 0.
      (br_if $l (local.get $tmp))
    )
    ;; Reset $tmp to the candidate number for the Armstrong sum calculation.
    (local.set $tmp (local.get $candidate))
    ;; Loop to calculate the Armstrong sum.
    (loop $l
      ;; Add the current digit raised to the power of the number of digits to $result.
      (local.set $result (i32.add
        (local.get $result)
        (call $power_of (i32.rem_u(local.get $tmp)(i32.const 10))(local.get $i))))
      ;; Divide $tmp by 10 to move to the next digit.
      (local.set $tmp (i32.div_u (local.get $tmp)(i32.const 10)))
      ;; Continue looping if $tmp is not yet 0.
      (br_if $l (local.get $tmp))
    )
    ;; Compare the Armstrong sum ($result) with the candidate number.
    ;; Return 1 if they are equal (true), 0 otherwise (false).
    (i32.eq (local.get $result)(local.get $candidate))
  )

  ;; Helper function to calculate x^y.
  (func $power_of (param $base i32)(param $to_the_power_of i32)(result i32)
    ;; Local variables for loop counter and result accumulator.
    (local $i i32) (local $ret i32)
    ;; Initialize $ret with $base as the starting value of the multiplication.
    (local.set $ret (local.get $base))
    ;; Initialize loop counter.
    (local.set $i (i32.const 1))
    ;; If $to_the_power_of is 0, return 1 immediately (x^0 = 1).
    (if(i32.eqz(local.get $to_the_power_of))(then (return (i32.const 1))))
    ;; If $to_the_power_of is greater than 1, calculate the power.
    (if(i32.gt_u (local.get $to_the_power_of)(i32.const 1)) (then(loop $l
      ;; Multiply $ret by $base for each iteration.
      (local.set $ret (i32.mul(local.get $ret)(local.get $base)))
      ;; Increment loop counter.
      (local.set $i (i32.add(local.get $i)(i32.const 1)))
      ;; Continue looping until $i equals $to_the_power_of.
      (br_if $l (i32.lt_u(local.get $i)(local.get $to_the_power_of)))
    )))
    ;; Return the calculated power.
    (local.get $ret))
)
