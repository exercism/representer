(module
    (memory (export "mem") 1)
    (func $succ (param i32) (result i32) (i32.add (local.get 0) (i32.const 1)))

    (func (export "countNucleotides") (param $begin i32) (param $length i32) (result i32 i32 i32 i32)
        (local $A i32) (local $C i32) (local $G i32) (local $T i32)
        (local $end i32)
        (local $base i32)
        (local.set $end (i32.add (local.get $begin) (local.get $length)))
        (block $break (loop $continue
            (br_if $break (i32.ge_u (local.get $begin) (local.get $end)))
            (local.set $base (i32.load8_u (local.get $begin)))
            (local.set $begin (call $succ (local.get $begin)))
            (if (i32.eq (local.get $base) (i32.const 65))
                (then
                    (local.set $A (call $succ (local.get $A)))
                    (br $continue))
            )
            (if (i32.eq (local.get $base) (i32.const 67))
                (then
                    (local.set $C (call $succ (local.get $C)))
                    (br $continue))
            )
            (if (i32.eq (local.get $base) (i32.const 71))
                (then
                    (local.set $G (call $succ (local.get $G)))
                    (br $continue))
            )
            (if (i32.eq (local.get $base) (i32.const 84))
                (then
                    (local.set $T (call $succ (local.get $T)))
                    (br $continue))
            )
            (return 
              (i32.const -1)
              (i32.const -1)
              (i32.const -1)
              (i32.const -1)
            )
        ))
        (return (local.get $A) (local.get $C) (local.get $G) (local.get $T))
    )
)
