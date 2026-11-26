(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $d f32)

    (f32.le
      (local.tee $d (f32.add (f32.mul (local.get $x) (local.get $x)) (f32.mul (local.get $y) (local.get $y))))
      (f32.const 100))
    (i32.mul
      (f32.le (local.get $d) (f32.const 25))
      (i32.const 4))
    i32.add
    (i32.mul
      (f32.le (local.get $d) (f32.const 1))
      (i32.const 5))
    i32.add
  )
)
