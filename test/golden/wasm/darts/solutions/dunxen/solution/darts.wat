(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $root f32)
    local.get $x
    local.get $x
    f32.mul
    local.get $y
    local.get $y
    f32.mul
    f32.add
    f32.sqrt
    local.tee $root
    f32.const 10.0
    f32.gt
    (if (then (return (i32.const 0))))
    local.get $root
    f32.const 5.0
    f32.gt
    (if (then (return (i32.const 1))))
    local.get $root
    f32.const 1.0
    f32.gt
    (if (then (return (i32.const 5))))
    (return (i32.const 10))
  )
)
