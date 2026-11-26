(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $radius f32)
    ;; calculate circle radius to get area
    (local.set $radius (f32.sqrt (f32.add (f32.mul (local.get $x) (local.get $x)) (f32.mul (local.get $y) (local.get $y)))))

    ;; dart hits the inner circle (r=1). get 10 points
    (f32.le (local.get $radius) (f32.const 1))
    (if 
      (then 
        (return (i32.const 10))  
      )  
    )

    ;; dart hits the middle circle (r=5). get 5 points
    (f32.le (local.get $radius) (f32.const 5))
    (if
      (then
        (return (i32.const 5))  
      )  
    )

    ;; dart hits the outer circle (r=10). get 1 points
    (f32.le (local.get $radius) (f32.const 10))
    (if 
      (then 
        (return (i32.const 1))  
      )  
    )

    ;; outside the target
    (i32.const 0)
    return 
  )
)
