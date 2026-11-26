(module
  (memory (export "mem") 1)

  (func (export "countNucleotides") (param $offset i32) (param $length i32) (result i32 i32 i32 i32)

    (local $as i32)
    (local $cs i32)
    (local $gs i32)
    (local $ts i32)

    (local $id i32)
    (local $char i32)

    (loop $loop
        (local.set $char (i32.load8_u (i32.add (local.get $offset) (local.get $id))))

        (if (i32.eq (local.get $char) (i32.const 65))

            (then
            (local.set $as (i32.add (local.get $as) (i32.const 1))))
            (else

            (if (i32.eq (local.get $char) (i32.const 67))
            (then
                (local.set $cs (i32.add (local.get $cs) (i32.const 1))))
            (else

            (if (i32.eq (local.get $char) (i32.const 71))
            (then
            (local.set $gs (i32.add (local.get $gs) (i32.const 1))))
            (else
            (if (i32.eq (local.get $char) (i32.const 84))
            (then
            (local.set $ts (i32.add (local.get $ts) (i32.const 1))))
            (else
            (if (i32.gt_u (local.get $char) (i32.const 32))
            (then
                (return
                  (i32.const -1)
                  (i32.const -1)
                  (i32.const -1)
                  (i32.const -1))
               ))
            ))))))))

        (local.set $id (i32.add (local.get $id) (i32.const 1)))
        (br_if $loop (i32.lt_u (local.get $id) (local.get $length)))
    )

    (return 
      (local.get $as)
      (local.get $cs)
      (local.get $gs)
      (local.get $ts)
    )
  )
)
