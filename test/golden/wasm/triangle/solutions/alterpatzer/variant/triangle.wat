(module
  (func $nonzero (param f32 f32 f32) (result i32)
    (i32.and (i32.and (f32.ne (local.get 0) (f32.const 0))
		      (f32.ne (local.get 1) (f32.const 0)))
	     (f32.ne (local.get 2) (f32.const 0))))

  (func $sides_fit (param f32 f32 f32) (result i32)
    (i32.and (i32.and (f32.lt (local.get 0)
			      (f32.add (local.get 1) (local.get 2)))
		      (f32.lt (local.get 1)
			      (f32.sub (local.get 0) (local.get 2))))
	     (f32.lt (local.get 2) (f32.add (local.get 0) (local.get 1)))))

  (func $valid (param f32 f32 f32) (result i32)
    (i32.and (call $nonzero (local.get 0) (local.get 1) (local.get 2))
	     (call $sides_fit (local.get 0) (local.get 1) (local.get 2))))

  (func $equal_sides (param f32 f32 f32) (result i32)
     (local $eq i32)
     (local.set $eq (i32.const 0))
     (local.set $eq (i32.add (local.get $eq)
			     (f32.eq (local.get 0) (local.get 1))))
     (local.set $eq (i32.add (local.get $eq)
			     (f32.eq (local.get 0) (local.get 2))))
     (local.set $eq (i32.add (local.get $eq)
			     (f32.eq (local.get 1) (local.get 2))))
     (local.get $eq))

  ;;
  ;; Is the triangle equilateral?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if equalateral, 0 otherwise
  ;;
  (func (export "isEquilateral") (param f32 f32 f32) (result i32)
    (if (result i32)
        (i32.eqz (call $valid (local.get 0) (local.get 1) (local.get 2)))
        (then (i32.const 0))
	(else
            (i32.eq
	      (call $equal_sides (local.get 0) (local.get 1) (local.get 2))
	      (i32.const 3)))))

  ;;
  ;; Is the triangle isosceles?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if isosceles, 0 otherwise
  ;;
  (func (export "isIsosceles") (param f32 f32 f32) (result i32)
    (if (result i32)
        (i32.eqz (call $valid (local.get 0) (local.get 1) (local.get 2)))
	(then (i32.const 0))
	(else
	  (i32.ge_u
	      (call $equal_sides (local.get 0) (local.get 1) (local.get 2))
	      (i32.const 1)))))

  ;;
  ;; Is the triangle scalene?
  ;;
  ;; @param {i32} length of side a
  ;; @param {i32} length of side b
  ;; @param {i32} length of side c
  ;;
  ;; @returns {i32} 1 if scalene, 0 otherwise
  ;;
  (func (export "isScalene") (param f32 f32 f32) (result i32)
    (if (result i32)
        (i32.eqz (call $valid (local.get 0) (local.get 1) (local.get 2)))
        (then (i32.const 0))
	(else
            (i32.eqz
	      (call $equal_sides (local.get 0) (local.get 1) (local.get 2))))))
)
