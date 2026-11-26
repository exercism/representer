(module

  (func (export "steps") (param $number i32) (result i32)
    (local $steps i32)
    i32.const 1
    local.get $number
    i32.eq
    (if 
      (then
       (return (i32.const 0))
      )
    )
    local.get $number
    i32.const 1
    i32.lt_s
    (if 
      (then
       (return (i32.const -1))
      )
    )
    (loop $loop
      local.get $number
      i32.const 2
      i32.rem_u
      (if 
        (then
          local.get $number
          i32.const 3
          i32.mul
          i32.const 1
          i32.add
          local.set $number
        )
        (else
          local.get $number
          i32.const 2
          i32.div_s
          local.set $number
        )
      )
      i32.const 1
      local.get $steps
      i32.add 
      local.set $steps
      i32.const 1
      local.get $number
      i32.ne
      br_if $loop
    )
    local.get $steps
  )
)