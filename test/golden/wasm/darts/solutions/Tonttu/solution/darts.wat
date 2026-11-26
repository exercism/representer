(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $distance f32)
    
    ;; calculate distance
    ;; sqrt(x^2 + y^2)
    local.get $x
    local.get $x
    f32.mul
    local.get $y
    local.get $y
    f32.mul
    f32.add
    f32.sqrt
    local.set $distance
    
    ;; evaluate score
    
    local.get $distance
    f32.const 1
    f32.le
    (if
      (then 
        i32.const 10
        return
      )
    )
  
    local.get $distance
    f32.const 5
    f32.le
    (if 
      (then
        i32.const 5
        return
      )
    )
  
    local.get $distance
    f32.const 10
    f32.le
    (if 
      (then
        i32.const 1
        return
      )
    )
  
    i32.const 0
  )
)
