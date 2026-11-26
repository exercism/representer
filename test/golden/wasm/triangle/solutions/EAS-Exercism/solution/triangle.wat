(module
  (func $satisfyInequality (param f32 f32 f32) (result i32)
    ;; test for zero length side
    (if (i32.or
          (i32.or
            (f32.eq (local.get 0) (f32.const 0))
            (f32.eq (local.get 1) (f32.const 0))
          )
          (f32.eq (local.get 2) (f32.const 0))
        )
        (then
          (return (i32.const 1))
        )
    )

    ;; test triangle inequality
    (if (f32.le (f32.add (local.get 0) (local.get 1)) (local.get 2))
      (return (i32.const 1))
    )
    (if (f32.le (f32.add (local.get 0) (local.get 2)) (local.get 1))
      (return (i32.const 1))
    )
    (if (f32.le (f32.add (local.get 1) (local.get 2)) (local.get 0))
      (return (i32.const 1))
    )  
  
    (i32.const 0)
  )
  
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
    (if (call $satisfyInequality (local.get 0) (local.get 1) (local.get 2))
        (then
          (return (i32.const 0))
        )
    )
  
    (if (i32.and
          (f32.eq (local.get 0) (local.get 1))
          (f32.eq (local.get 0) (local.get 2))
        )
        (then
          (return (i32.const 1))
        )
    )
    (i32.const 0)
  )

  (func (export "isIsosceles") (param f32 f32 f32) (result i32)
    (if (call $satisfyInequality (local.get 0) (local.get 1) (local.get 2))
        (then
          (return (i32.const 0))
        )
    )

    (if (i32.or
          (i32.or
            (f32.eq (local.get 0) (local.get 1))
            (f32.eq (local.get 0) (local.get 2))
          )
          (f32.eq (local.get 1) (local.get 2))
        )
        (then
          (return (i32.const 1))
        )
    )    
    (i32.const 0)
  )

  (func (export "isScalene") (param f32 f32 f32) (result i32)
    (if (call $satisfyInequality (local.get 0) (local.get 1) (local.get 2))
        (then
          (return (i32.const 0))
        )
    )
  
    (if (i32.and
          (i32.and
            (f32.ne (local.get 0) (local.get 1))
            (f32.ne (local.get 0) (local.get 2))
          )
          (f32.ne (local.get 1) (local.get 2))
        )
        (then
          (return (i32.const 1))
        )
    )    
    (i32.const 0)
  )
)
