(module
  (memory (export "mem") 1)
  (data (i32.const 192) "One for ")
  (data (i32.const 0) "you, one for me.")

  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (if (i32.eqz (local.get $length))
      (then (memory.copy (i32.const 200) (i32.const 0) (i32.const 16))
            (return (i32.const 192) (i32.const 24))))

    (memory.copy (i32.const 200) (local.get $offset) (local.get $length))
    (memory.copy (i32.add (i32.const 200) (local.get $length)) 
                 (i32.const 3) (i32.const 13))
    (return (i32.const 192) (i32.add (i32.const 21) (local.get $length)))))
