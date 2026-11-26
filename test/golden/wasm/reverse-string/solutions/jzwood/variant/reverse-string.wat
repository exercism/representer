(module
  (memory (export "mem") 1)

  (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)

    (local $i i32) ;; init as 0
    (local $stop i32)
    local.get $length
    i32.const 2
    i32.rem_s ;; floor of /2
    local.set $stop

    (loop $loop

      ;; get low pointer
      local.get $offset
      local.get $i
      i32.add

      ;; get high pointer
      local.get $offset
      local.get $length
      i32.const 1
      local.get $i
      i32.add
      i32.sub
      i32.add

      call $swap

      ;; add one to $i
      local.get $i
      i32.const 1
      i32.add
      local.set $i

      ;; if $i is less than $stop branch to loop
      local.get $i
      local.get $stop
      i32.lt_s
      br_if $loop
    )

    local.get $offset
    local.get $length
    return
  )

  (func $swap (param $lo i32) (param $hi i32)
    (local $lo' i32)
    (local $hi' i32)

    local.get $hi
    i32.load
    local.set $hi'

    local.get $lo
    i32.load
    local.set $lo'

    local.get $hi
    local.get $lo'
    i32.store8

    local.get $lo
    local.get $hi'
    i32.store8
  )
)
