(module
  (func $isInvalid (param f32 f32 f32) (result i32)
    (local $degenerate i32)
    (local $noIneq1 i32)
    (local $noIneq2 i32)
    (local $noIneq3 i32)

    (i32.or 
        (i32.or
            (f32.le (local.get 0) (f32.const 0))
            (f32.le (local.get 1) (f32.const 0))
          )
        (f32.le (local.get 2) (f32.const 0))
      )
    (local.set $degenerate)
    
    
    (f32.lt (f32.add (local.get 0) (local.get 1)) (local.get 2))
    (local.set $noIneq1)
      
    
    (f32.lt (f32.add (local.get 1) (local.get 2)) (local.get 0))
    (local.set $noIneq2)
    
    
    (f32.lt (f32.add (local.get 2) (local.get 0)) (local.get 1))
    (local.set $noIneq3)

  (return (i32.or
      (i32.or (local.get $degenerate) (local.get $noIneq1))
      (i32.or (local.get $noIneq2) (local.get $noIneq3))
    ))
  )
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
  (if (call $isInvalid (local.get 0) (local.get 1) (local.get 2)) (then (return (i32.const 0))))

        (i32.and
          (f32.eq (local.get 0) (local.get 1))
          (f32.eq (local.get 1) (local.get 2))
          )

      )

  (func $iso (export "isIsosceles") (param f32 f32 f32) (result i32)

    (if (call $isInvalid (local.get 0) (local.get 1) (local.get 2)) (then (return (i32.const 0))))
    

    (i32.or
      (i32.or 
        (f32.eq (local.get 0) (local.get 1))
        (f32.eq (local.get 0) (local.get 2))
        )
      (f32.eq (local.get 1) (local.get 2))
      )
  )

  (func (export "isScalene") (param f32 f32 f32) (result i32)
    
    (if (call $isInvalid (local.get 0) (local.get 1) (local.get 2)) (then (return (i32.const 0))))
      (call $iso (local.get 0) (local.get 1) (local.get 2))
      i32.const 1
      i32.xor
      return
  )
)
