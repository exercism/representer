(module
  ;; all three sides the same length
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
    (call $isInvalid (local.get 0) (local.get 1) (local.get 2))
    (if
      (then
        (return (i32.const 0)))  
    )
    (i32.eq
      (i32.const 3)  
      (call $countSideEquality (local.get 0) (local.get 1) (local.get 2)))
  )
  ;; at least two sides the same length
  (func (export "isIsosceles") (param f32 f32 f32) (result i32)
    (call $isInvalid (local.get 0) (local.get 1) (local.get 2))
    (if
      (then
        (return (i32.const 0))))
    (i32.gt_s
      (call $countSideEquality (local.get 0) (local.get 1) (local.get 2))
      (i32.const 0))
  )
  ;; all sides of different lengths.
  (func (export "isScalene") (param f32 f32 f32) (result i32)
    (call $isInvalid (local.get 0) (local.get 1) (local.get 2))
    (if
      (then
        (return (i32.const 0)))  
    )
    (i32.eq
      (call $countSideEquality (local.get 0) (local.get 1) (local.get 2))
      (i32.const 0))
  )
  ;; return the number of sides of the same length
  (func $countSideEquality (param f32 f32 f32) (result i32) (local $c i32)
      (i32.add
      	(f32.eq (local.get 0) (local.get 1))
        (local.get $c))
      (local.set $c)
      (i32.add
      	(f32.eq (local.get 0) (local.get 2))
        (local.get $c))
      (local.set $c)
      (i32.add
      	(f32.eq (local.get 1) (local.get 2))
        (local.get $c))
  )
  (func $isInvalid (param f32 f32 f32) (result i32)
    (i32.or
        ;; all sides == 0
      	(f32.eq
          (f32.add
            (f32.add
              (local.get 0)
              (local.get 1))
            (local.get 2))
          (f32.const 0))
        ;; triangle inequality
    	(i32.or
          (i32.or
            (f32.gt
              	(local.get 2)
            	(f32.add (local.get 0) (local.get 1)))
  			(f32.gt
              	(local.get 1)
            	(f32.add (local.get 2) (local.get 0)))
          )
          (f32.gt
              	(local.get 0)
            	(f32.add (local.get 1) (local.get 2))))))

)
