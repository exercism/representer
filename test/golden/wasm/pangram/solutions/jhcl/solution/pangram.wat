(module
  (memory (export "mem") 1)

  ;; return 1 if pangram, 0 otherwise
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    (local $temp i32)
    (local $char i32)
    (local $az i32)
    (if (i32.eqz (local.get $length)) (return (i32.const 0)))
    ;; input toLowercase
    (loop $loop
      (local.set $char (i32.load8_u (i32.add (local.get $temp) (local.get $offset))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 65))
                  (i32.le_u (local.get $char) (i32.const 90)))
        (i32.store8 (i32.add (local.get $temp) (local.get $offset)) (i32.add (local.get $char) (i32.const 32)))
      )
      (local.set $temp (i32.add (local.get $temp) (i32.const 1)))
      (br_if $loop (i32.ne (local.get $temp) (local.get $length)))
    )
    
    (block $blk
      ;; per alphabetic letter check whether it is in input
      (loop $abc
        (br_if $blk (i32.eq (local.get $az) (i32.const 26)))
        (local.set $temp (i32.const 0))
        (loop $input
          (if (i32.eq (i32.load8_u (i32.add (local.get $offset) (local.get $temp)))
                      (i32.add (i32.const 97) (local.get $az)))
            (then 
              (local.set $az (i32.add (local.get $az) (i32.const 1))) (br $abc))
          )
          (local.set $temp (i32.add (local.get $temp) (i32.const 1)))
          (br_if $input (i32.le_s (local.get $temp) (local.get $length)))
          (return (i32.const 0))
        )
      ) 
    )
    (i32.const 1)
  )
)
