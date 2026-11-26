(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)

    (local $xx f32) ;; x squared
    (local $yy f32) ;; y squared
    (local $dist f32) ;; distance

    (local.set $xx (f32.mul (local.get $x) (local.get $x)))
    (local.set $yy (f32.mul (local.get $y) (local.get $y)))
    (local.set $dist (f32.sqrt (f32.add (local.get $xx) (local.get $yy))))

    (if (f32.le (local.get $dist) (f32.const 1.0))
      (then (return (i32.const 10))))
    (if (f32.le (local.get $dist) (f32.const 5.0)) 
      (then (return (i32.const 5))))
    (if (f32.le (local.get $dist) (f32.const 10.0))
      (then (return (i32.const 1))))
    (return (i32.const 0))
    )
)