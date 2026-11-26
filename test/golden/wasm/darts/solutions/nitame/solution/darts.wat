(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $dart_radius f32)
    ;; Calculate dart_radius => n = sqrt((x * x) + (y * y))
    (local.set $dart_radius (
      f32.sqrt (
          f32.add
          (f32.mul
            (local.get $x)
            (local.get $x)
          )
          (f32.mul
            (local.get $y)
            (local.get $y)
          )
        )
      )
    )

    ;; if dart_radius less or equal 1
    (if
      (f32.le
        (local.get $dart_radius)
        (f32.const 1)
      )
      (then
        (return (i32.const 10))
      )
      (else
        ;; if dart_radius less or equal 5
        (if
          (f32.le
            (local.get $dart_radius)
            (f32.const 5)
          )
          (then
            (return (i32.const 5))
          )
          (else
            ;; if dart radius less or equal 10
            (if
              (f32.le
                (local.get $dart_radius)
                (f32.const 10)
              )
              (then
                (return (i32.const 1))
              )
              (else)
            )
          )
        )
      )
    )
  
    (return (i32.const 0))
  )
)
