(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $xx f32)
    (local $yy f32)
    (local $sqrdist f32)
    (local.set $xx (f32.mul (local.get $x) (local.get $x)))
    (local.set $yy (f32.mul (local.get $y) (local.get $y)))
    (local.set $sqrdist (f32.add (local.get $xx)(local.get $yy)))
    (if
      (f32.le (local.get $sqrdist) (f32.const 1.0))
      (return (i32.const 10))
    )
    (if
      (f32.le (local.get $sqrdist) (f32.const 25.0))
      (return (i32.const 5))
    )
    (if
      (f32.le (local.get $sqrdist) (f32.const 100.0))
      (return (i32.const 1))
    )
    (return (i32.const 0))
  )
)
