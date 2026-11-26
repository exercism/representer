(module
    (memory (export "mem") 1)

    (func $is_lower (param i32) (result i32)
        (i32.le_u (i32.const 97) (local.get 0))
        (i32.le_u (local.get 0) (i32.const 122))
        i32.and)

    (func $is_upper (param i32) (result i32)
        (i32.le_u (i32.const 65) (local.get 0))
        (i32.le_u (local.get 0) (i32.const 90))
        i32.and)

    ;; return 1 if pangram, 0 otherwise
    (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
        (local $mask i32) (local $idx i32) (local $char i32)
        (block $break (loop $continue
            (br_if $break (i32.eq (local.get $idx) (local.get $length)))
            (local.set $char
                (i32.and (i32.const 32)
                    (i32.load8_u (i32.add (local.get $offset) (local.get $idx)))))
            (if (call $is_lower (local.get $char))
                (local.set $mask
                    (i32.or (local.get $mask)
                        (i32.shl (i32.const 1) (i32.sub (local.get $char) (i32.const 97))))))
            (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
            (br $continue)
        ))
        (i32.eq
            (i32.add (local.get $mask) (i32.const 1))
            (i32.shl (i32.const 1) (i32.const 26)))
    )
)
