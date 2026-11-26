(module
  (memory (export "mem") 1)
 
  (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)
    (local $offset_begin i32)
    (local $offset_end i32)
  
    (local.set $offset_begin (local.get $offset))
    (local.set $offset_end
      (i32.add
        (local.get $offset)
        (i32.sub (local.get $length) (i32.const 1))
      )
    )

    (loop $reverse_loop (block $break
      (br_if $break
        (i32.ge_u
          (local.get $offset_begin)
          (local.get $offset_end)
        )
      )

      (local.get $offset_begin)
      (i32.load8_u (local.get $offset_end))
      (local.get $offset_end)
      (i32.load8_u (local.get $offset_begin))
      i32.store8
      i32.store8

      (local.set $offset_begin
        (i32.add (local.get $offset_begin) (i32.const 1))
      )
      (local.set $offset_end
        (i32.sub (local.get $offset_end) (i32.const 1))
      )

      br $reverse_loop
    ))
    (return (local.get $offset) (local.get $length))
  )
)
