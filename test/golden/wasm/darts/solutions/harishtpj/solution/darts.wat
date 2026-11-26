(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $d f32)
    (f32.mul (local.get $x) (local.get $x))
    (f32.mul (local.get $y) (local.get $y))
    f32.add
    local.set $d
    (if (f32.le (local.get $d) (f32.const 1)) (then (return (i32.const 10))))
    (if (f32.le (local.get $d) (f32.const 25)) (then (return (i32.const 5))))
    (if (f32.le (local.get $d) (f32.const 100)) (then (return (i32.const 1))))
    (return (i32.const 0))
  )
)
