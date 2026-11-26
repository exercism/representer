(module
  (memory (export "mem") 1)

  (func $map (param $nuc i32) (result i32 i32)
    local.get $nuc
    i32.const 65
    i32.eq
    (if
      (then
        i32.const 85
        i32.const 1
        return
      )
    )
    local.get $nuc
    i32.const 84
    i32.eq
    (if
      (then
        i32.const 65
        i32.const 1
        return
      )
    )
    local.get $nuc
    i32.const 67
    i32.eq
    (if
      (then
        i32.const 71
        i32.const 1
        return
      )
    )
    local.get $nuc
    i32.const 71
    i32.eq
    (if
      (then
        i32.const 67
        i32.const 1
        return
      )
    )
    i32.const 0
    i32.const 0
  )

  (func (export "toRna") (param $offset i32) (param $length i32) (result i32 i32)
    (local $output i32)
    (local $i i32)
    local.get $offset
    local.get $length
    local.set $output
    i32.const 0
    local.set $i
    (loop $translate
      local.get $i
      local.get $length
      i32.eq
      (if
        (then
          local.get $output
          local.get $length
          return
        )
      )

      ;; dest address
      local.get $output
      local.get $i
      i32.add
      ;; load data
      local.get $offset
      local.get $i
      i32.add
      i32.load8_u
      call $map
      drop ;; we've got error checks, but there's no way provided to use them

      i32.store8

      local.get $i
      i32.const 1
      i32.add
      local.set $i
      br $translate
    )
    unreachable
  )
)
