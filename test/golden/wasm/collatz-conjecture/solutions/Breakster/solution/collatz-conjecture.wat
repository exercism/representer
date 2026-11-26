(module
  (func $steps (export "steps") (param $number i32) (result i32)
    ;; Zero steps for the number one
    (if (i32.eq (local.get $number) (i32.const 1)) (return (i32.const 0)))
    ;; Error check
    (if (i32.le_s (local.get $number) (i32.const 0)) (return (i32.const -1)))

    ;; The number is larger than one. We need to perform a step 
    (i32.and (i32.const 1) (local.get $number)) ;; Check if the number is odd
    (if (result i32)
      (then
        (i32.add (i32.const 1) (i32.mul (i32.const 3) (local.get $number))))
      (else
        (i32.div_u (local.get $number) (i32.const 2))))

    ;; We just performed a step, so return one step more than the number of steps for the new number
    call $steps
    i32.const 1
    i32.add))