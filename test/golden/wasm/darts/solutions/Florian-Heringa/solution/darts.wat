(module
  (func (export "score") (param $x f32) (param $y f32) (result i32) 
    (local $d f32)
    
    (local.set $d ;;Calculate the squared distance from the middle
      (f32.add ;; x^2 + y^2
        (f32.mul (local.get $x) (local.get $x)) ;; x^2
        (f32.mul (local.get $y) (local.get $y)) ;; y^2
      )
    )

    ;; Compare the squared distance from the origin to the designated rings
    (if
      ;; Right in the center
      (f32.le (local.get $d) (f32.const 1.0))
      (return (i32.const 10))
    )

    (if
      ;; Middle ring
      (f32.le (local.get $d) (f32.const 25.0))
      (return (i32.const 5))
    )

    (if
      ;; Outer ring
      (f32.le (local.get $d) (f32.const 100.0))
      (return (i32.const 1))
    )

    ;; Miss
    (return (i32.const 0))
  )
)
