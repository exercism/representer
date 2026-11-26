(module
  (memory (export "mem") 1)

  (func $load_u8 (param $addr i32) (result i32) 
    local.get $addr
    i32.load
    i32.const 255
    i32.and
  )
  
  (func $dist (param $addr1 i32) (param $addr2 i32) (result i32)
      local.get $addr1
      call $load_u8
      local.get $addr2
      call $load_u8
      i32.ne
  )

  (func (export "compute") 
    (param $firstOffset i32) (param $firstLength i32) (param $secondOffset i32) (param $secondLength i32) (result i32)
    (local $value i32)
    (local $i i32)
    
    ;; get max length
    local.get $firstLength
    local.get $secondLength
    (if (i32.eq) (then (return (i32.const -1))) (else nop))

    ;; loop
    (loop $start
      (block $end
        ;; break if i >= length
        local.get $i
        local.get $firstLength
        i32.ge_u
        br_if $end

        ;; dist
        local.get $i
        local.get $firstOffset
        i32.add
        local.get $i
        local.get $secondOffset
        i32.add
        call $dist

        ;; value += dist
        local.get $value
        i32.add
        local.set $value

        ;; i++
        local.get $i
        i32.const 1
        i32.add
        local.set $i
        br $start
      )
    )
    local.get $value
  )
)
