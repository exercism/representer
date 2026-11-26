(module
    (func (export "eggCount") (param $n i32) (result i32) (local $cnt i32)
        (loop
            (local.set $cnt (i32.add (local.get $cnt) (i32.and (local.get $n) (i32.const 1))))
            (local.set $n (i32.shr_u (local.get $n) (i32.const 1)))
            (br_if 0 (i32.gt_u (local.get $n) (i32.const 0)))
        )
        (local.get $cnt)
    )
)
