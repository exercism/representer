(module
  (func $square (param $z f32) (result f32)
    local.get $z
    local.get $z
    f32.mul)
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $n f32)
    local.get $x
    call $square
    local.get $y
    call $square
    f32.add
    f32.sqrt
    local.tee $n
    f32.const 10
    f32.gt
    (if
      (then 
        i32.const 0
        return
      )
    )
    local.get $n
    f32.const 5
    f32.gt
    (if
      (then
        i32.const 1
        return
      )
    )
    local.get $n
    f32.const 1
    f32.gt
    (if
      (then
        i32.const 5
        return
      )
      (else
        i32.const 10
        return
      )
    )
  i32.const 0
  )
)
