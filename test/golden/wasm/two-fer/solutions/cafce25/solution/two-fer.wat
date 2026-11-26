(module
  (memory (export "mem") 1)
  (global $one_for i32 (i32.const 0))
  (global $you i32 (i32.const 8))
  (global $one_for_me i32 (i32.const 11))
  (global $end i32 (i32.const 24))
  (data (i32.const 0) "One for you, one for me.")
  (data (i32.const 56) "One for ")

  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (local $pos i32)
    local.get $length
    i32.eqz
    if (result i32 i32)
      global.get $one_for
      global.get $end
    else
      local.get $offset
      local.get $length
      i32.add
      local.tee $offset
      local.set $pos
      loop
        local.get $pos

        local.get $pos
        local.get $offset
        i32.sub
        global.get $one_for_me
        i32.add

        i32.load8_u
        i32.store8

        local.get $pos
        i32.const 1
        i32.add
        local.tee $pos
        local.get $offset
        i32.sub
        i32.const 13
        i32.ne

        br_if 0
      end
      i32.const 56
      local.get $length
      i32.const 21
      i32.add
    end
  )
)
