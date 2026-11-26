(module
  (func (export "steps") (param $number i32) (result i32)
    (local $count i32)
    (if (i32.le_s (local.get $number) (i32.const 0))
      (return (i32.const -1)))

    ;; if even divide by 2, else times 3 plus 1. Should eventually end in 1
    (loop $loop 
      (if (i32.eq (local.get $number) (i32.const 1)) 
        (return (local.get $count)))

      (local.set $count (i32.add (local.get $count) (i32.const 1)))
      (if (i32.gt_s (i32.ctz (local.get $number)) (i32.const 0))
        (then 
          (local.set $number (i32.shr_u (local.get $number) (i32.const 1))))
        (else 
          (local.set $number (i32.add (i32.mul (local.get $number) (i32.const 3)) (i32.const 1))))
      )
      (br $loop)
    )
    (local.get $count)
  )
)
