(module
  
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $radius f32)
    (f32.mul (local.get $x) (local.get $x))
    (f32.mul (local.get $y) (local.get $y))
    (f32.add)
    (f32.sqrt)
    (local.set $radius)
    (f32.le (local.get $radius) (f32.const 1.0))
    (if
      (then
        (return (i32.const 10))
      )
    )
    (f32.le (local.get $radius) (f32.const 5.0))
    (if
      (then
        (return (i32.const 5))
      )
    )
    (f32.le (local.get $radius) (f32.const 10.0))
    (if
      (then
        (return (i32.const 1))
      )
    )

    (return (i32.const 0))
  )
)
