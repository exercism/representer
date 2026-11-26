(module
  (memory (export "mem") 1)

  (data (i32.const 0) "One for you, one for me.")

  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    ;; No name Check
    local.get $length
    i32.eqz
    if
      i32.const 0
      i32.const 24
      return
    end

    local.get $offset
    local.get $length
    i32.add
    local.set $length

    local.get $offset
    i32.const 8
    i32.sub
    local.tee $offset
    i64.const 0x20726f6620656e4f
    i64.store

    local.get $length
    i64.const 0x6f6620656e6f202c
    i64.store

    local.get $length
    i32.const 8
    i32.add
    local.tee $length
    i64.const 0x2e656d2072
    i64.store

    local.get $offset
    local.get $length
    local.get $offset
    i32.sub
    i32.const 5
    i32.add
  )
)
