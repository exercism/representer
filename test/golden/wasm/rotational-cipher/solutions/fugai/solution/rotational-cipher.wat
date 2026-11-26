(module
  (memory (export "mem") 1)
  (func
    (export "rotate")
    (param $offset i32) (param $length i32) (param $key i32)
    (result i32 i32)
    (local $init_offset i32)
    (local $init_length i32)
    (local $current_char i32)
    (local $alpha_char i32)
    (local.set $init_offset (local.get $offset))
    (local.set $init_length (local.get $length))
    (loop $my_loop
      
      (local.set $current_char
        (i32.load8_u (local.get $offset)))
  
      (if
        (i32.and
          (i32.ge_u (local.get $current_char) (i32.const 65))
          (i32.le_u (local.get $current_char) (i32.const 90)))
        (then (local.set $alpha_char (i32.const 65)))
        (else
          (if
            (i32.and
              (i32.ge_u (local.get $current_char) (i32.const 97))
              (i32.le_u (local.get $current_char) (i32.const 122)))
            (then (local.set $alpha_char (i32.const 97)))
            (else (local.set $alpha_char (i32.const 0))))))
      (if (i32.eqz (local.get $alpha_char))
        (then)
        (else
          (local.set $current_char
            (i32.add
              (local.get $alpha_char)
              (i32.rem_u
                (i32.add
                  (local.get $key)
                  (i32.sub
                    (local.get $current_char)
                    (local.get $alpha_char)))
                (i32.const 26))))
          (i32.store8
            (local.get $offset)
            (local.get $current_char))))
      (local.set $offset
        (i32.add (local.get $offset) (i32.const 1)))
      (local.set $length
        (i32.sub (local.get $length) (i32.const 1)))
      (if (i32.eqz (local.get $length))
        (then)
        (else (br $my_loop))))
    
    (return (local.get $init_offset) (local.get $init_length))))
