(module
    (memory (export "mem") 1)
 
    ;; Assumes size of i32
    (func (export "find") (param $base i32) (param $nelems i32) (param $needle i32) (result i32)
        (local $lo i32)
        (local $hi i32)
        (local $mid i32)
        (local $val i32)
        (local.set $lo (i32.const 0))
        (local.set $hi (local.get $nelems))

        (block $break (loop $continue
            (br_if $break (i32.ge_u (local.get $lo) (local.get $hi)))
            (local.set $mid (i32.shr_u (i32.add (local.get $lo) (local.get $hi)) (i32.const 1)))
            (local.set $val (i32.load (i32.add (local.get $base) (i32.shl (local.get $mid) (i32.const 2)))))

            (if (i32.lt_s (local.get $val) (local.get $needle))
                (then (local.set $lo (i32.add (local.get $mid) (i32.const 1))))
                (else (local.set $hi (local.get $mid)))
            )
            (br $continue)
        ))
        (if (i32.and
                (i32.lt_s (local.get $lo) (local.get $nelems))
                (i32.eq (local.get $needle)
                    (i32.load (i32.add (local.get $base) (i32.shl (local.get $lo) (i32.const 2))))
                )
            )
            (return (local.get $lo))
        )
        (i32.const -1)
    )
)
