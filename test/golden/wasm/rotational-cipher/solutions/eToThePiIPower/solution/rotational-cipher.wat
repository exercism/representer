(module
  (memory (export "mem") 1)

  (func $shift (param $char i32) (param $shiftKey i32) (result i32)
        local.get $char
        i32.const 65
        i32.ge_s
        local.get $char
        i32.const 90
        i32.le_s
        i32.and
        (if
          (then
            ;; Uppercase A-Z ($char between 64-90 inclusive)
            i32.const 65
              local.get $shiftKey
              local.get $char
              i32.const 65
              i32.sub
              i32.add 
              i32.const 26
              i32.rem_u
            i32.add
            return
            ))

        local.get $char
        i32.const 97
        i32.ge_s
        local.get $char
        i32.const 122
        i32.le_s
        i32.and
        (if
          (then
            ;; Uppercase A-Z (char between 97-122 inclusive)
            i32.const 97
              local.get $shiftKey
              local.get $char
              i32.const 97
              i32.sub
              i32.add 
              i32.const 26
              i32.rem_u
            i32.add
            return
            ))

        local.get $char
        return
        )

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
        (local $loc i32)

        local.get $textOffset
        local.set $loc

        (loop $loop
              local.get $loc
                local.get $loc
                i32.load8_u
                local.get $shiftKey
                call $shift
              i32.store8

              local.get $loc
              i32.const 1
              i32.add
              local.set $loc

              local.get $loc
              local.get $textOffset
              local.get $textLength
              i32.add
              i32.lt_s
              br_if $loop
              )

        local.get $textOffset
        local.get $textLength
        return
  )
)
