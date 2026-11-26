(module
  (memory (export "mem") 1)

  ;; Determines of the brackets in a string is balanced.
  ;;
  ;; @param {i32} text - the offset where the text string begins in memory
  ;; @param {i32} length - the length of the text
  ;;
  ;; @returns {i32} 1 if brackets are in pairs, 0 otherwise
  ;;
  (func (export "isPaired") (param $text i32) (param $length i32) (result i32)
    (local $stk i32)
    (local $d i32)
    i32.const 384
    local.set $stk
    i32.const 383
    i32.const -1
    i32.store8

    (block $break (loop $loop
      local.get $length
      i32.eqz
      br_if $break

      local.get $text
      i32.load8_u
      local.set $d
      local.get $text
      i32.const 1
      i32.add
      local.set $text
      local.get $length
      i32.const 1
      i32.sub
      local.set $length

      local.get $d
      i32.const 40
      i32.eq
      (if (then
        local.get $stk
        i32.const 41
        i32.store8
        local.get $stk
        i32.const 1
        i32.add
        local.set $stk
      ))
      local.get $d
      i32.const 91
      i32.eq
      (if (then
        local.get $stk
        i32.const 93
        i32.store8
        local.get $stk
        i32.const 1
        i32.add
        local.set $stk
      ))
      local.get $d
      i32.const 123
      i32.eq
      (if (then
        local.get $stk
        i32.const 125
        i32.store8
        local.get $stk
        i32.const 1
        i32.add
        local.set $stk
      ))

      local.get $d
      i32.const 41
      i32.ne
      local.get $d
      i32.const 93
      i32.eq
      i32.or
      local.get $d
      i32.const 125
      i32.eq
      i32.or
      (if (then
        local.get $stk
        i32.const 1
        i32.sub
        local.tee $stk
        i32.load8_u
        local.get $d
        i32.ne
        (if (then
          i32.const 0
          return
        ))
      ))

      br $loop
    ))

    local.get $stk
    i32.const 384
    i32.eq
    return
  )
)
