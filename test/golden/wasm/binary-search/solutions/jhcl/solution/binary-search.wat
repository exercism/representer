(module
  (memory (export "mem") 1)
 
  ;; Assumes size of i32 thus loads and stores in 4-byte-sections
  (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
    (local $low i32)
    (local $high i32)
    (local $mid i32)
    (local.set $high (i32.sub (local.get $nelems) (i32.const 1)))
    (loop $loop
      (local.set $mid (i32.div_u (i32.add (local.get $low) (local.get $high)) (i32.const 2)))
      (if (i32.eq (i32.load (i32.add (local.get $base) (i32.mul (local.get $mid) (i32.const 4)))) 
                  (local.get $needle))
          (return (local.get $mid)))
      (if (i32.lt_u (i32.load (i32.add (local.get $base) (i32.mul (local.get $mid) (i32.const 4)))) 
                    (local.get $needle))
        (then (local.set $low (i32.add (local.get $mid) (i32.const 1))))
        (else (local.set $high (i32.sub (local.get $mid) (i32.const 1)))))
      (br_if $loop (i32.le_s (local.get $low) (local.get $high)))
    )
    (i32.const -1)
  )
)
