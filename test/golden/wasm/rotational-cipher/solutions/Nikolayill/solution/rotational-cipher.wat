(module
  (import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))
  (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (import "console" "log_i32_s" (func $log_i32_s (param i32)))

  (memory (export "mem") 1)

  (global $aCode i32 (i32.const 97))
  (global $zCode i32 (i32.const 122))

  (global $aUpCode i32 (i32.const 65))
  (global $zUpCode i32 (i32.const 90))

  (func $encode (param $char i32) (param $shift i32) (result i32)
    (local $a i32)
    (local $z i32)

    (block $is_aplha
      (if (i32.and
          (i32.ge_u (local.get $char) (global.get $aCode))
          (i32.le_u (local.get $char) (global.get $zCode))
        )
        (then 
          (local.set $a (global.get $aCode))
          (local.set $z (global.get $zCode))
          (br $is_aplha)
        )
      )
      (if (i32.and
            (i32.ge_u (local.get $char) (global.get $aUpCode))
            (i32.le_u (local.get $char) (global.get $zUpCode))
        )
        (then 
          (local.set $a (global.get $aUpCode))
          (local.set $z (global.get $zUpCode))
          (br $is_aplha)
        )
      )
      ;; it is not alpha character
      (return (local.get $char))
    )

    (i32.add (local.get $a)
      (i32.rem_u 
        (i32.add 
          (i32.sub (local.get $char) (local.get $a))
          (local.get $shift))
        (i32.const 26)
      )
    )    
  )

  (func (export "rotate") 
    (param $textOffset i32) (param $textLength i32) 
    (param $shiftKey i32) 
    (result i32 i32)
    (local $i i32)
    
    ;; (call $log_mem_as_utf8 (local.get $textOffset) (local.get $textLength))
    ;; (call $log_i32_u (i32.load8_u (i32.const 100)))
    ;; (call $log_i32_u (i32.load8_u (i32.const 101)))    

    (local.tee $i (i32.const 0))

    (block $loop_end
      (loop $loop_next
        ;; (call $log_i32_u (local.get $i))

        (i32.store8 
          (i32.add (local.get $textOffset) (local.get $i))
          (call $encode 
            (i32.load8_u (i32.add (local.get $textOffset) (local.get $i))) 
            (local.get $shiftKey))
        )

        ;; (call $log_mem_as_utf8 (local.get $textOffset) (local.get $textLength))

        (i32.add (local.get $i) (i32.const 1))
        (local.tee $i)
        (local.get $textLength)
        (i32.ge_u)
        (br_if $loop_end)

        (br $loop_next)
      )
    )

    (return (local.get $textOffset) (local.get $textLength))
  )
)
