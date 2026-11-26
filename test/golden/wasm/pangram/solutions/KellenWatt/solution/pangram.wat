(module
  (memory (export "mem") 1)
  
  (func $alpha-index (param $c i32) (result i32)
    ;; ascii to_lower or to_junk if non-alpha
    i32.const 0x20
    local.get $c
    i32.or
   
    i32.const 97
    i32.sub
  )

  (func $clr (param $bitset i32) (param $index i32) (result i32)
    ;; set up bitmask for clear
    i32.const 1
    local.get $index
    i32.shl
    i32.const -1
    i32.xor

    local.get $bitset
    i32.and
  )

  ;; return 1 if pangram, 0 otherwise
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    (local $alphaset i32)
    (local $i i32)

    i32.const 0
    local.set $i
    i32.const 0x3FFFFFF ;; first 26 bits set
    local.tee $alphaset ;; alphabet bitset bitset

    (loop $check-letters (param i32)
      i32.eqz
      local.get $i
      local.get $length
      i32.eq
      i32.or
      (if
        (then
          local.get $alphaset
          i32.eqz
          return
        )
      )

      local.get $alphaset

      local.get $offset
      local.get $i
      i32.add
      i32.load8_u
      call $alpha-index

      call $clr
      local.tee $alphaset

      local.get $i
      i32.const 1
      i32.add
      local.set $i
      br $check-letters
    )
    unreachable
  )
)
