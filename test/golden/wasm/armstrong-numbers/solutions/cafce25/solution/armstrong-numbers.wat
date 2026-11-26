(module
  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
        (local $c i32) (local $tr i32) (local $digits i32)
    local.get $candidate
    call $ndigits
    local.set $digits
    local.get $candidate
    local.set $c
    loop
      local.get $c
      i32.const 10
      i32.rem_u
      local.get $digits
      call $pow
      local.get $tr
      i32.add
      local.set $tr
      local.get $c
      i32.const 10
      i32.div_u
      local.tee $c
      i32.const 0
      i32.ne
      br_if 0
    end
    local.get $candidate
    local.get $tr
    i32.eq
  )
  (func $ndigits (param $num i32) (result i32) (local $n i32)
    loop
      local.get $n
      i32.const 1
      i32.add
      local.set $n
      local.get $num
      i32.const 10
      i32.div_u
      local.tee $num
      i32.eqz
      i32.eqz
      br_if 0
    end
    local.get $n
  )
  (func $pow (param $x i32) (param $y i32) (result i32)
    (local $res i32)
    i32.const 1
    local.set $res
    local.get $y
    i32.eqz
    i32.eqz
    if
      loop
        local.get $res
        local.get $x
        i32.mul
        local.set $res
        local.get $y
        i32.const 1
        i32.sub
        local.tee $y
        i32.eqz
        i32.eqz
        br_if 0
      end
    end
    local.get $res
  )
)
