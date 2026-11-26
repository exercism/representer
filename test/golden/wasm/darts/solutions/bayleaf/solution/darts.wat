(module
  (func $pow2 (param $n f32) (result f32)
    (return (f32.mul (local.get $n) (local.get $n))))

  (func $is_inside (param $r i32) (param $x f32) (param $y f32) (result i32)
    ;; Add result to the stack
    (f32.add
      (call $pow2 (local.get $x))
      (call $pow2 (local.get $y)))

    (return (f32.le
      (call $pow2
        (f32.convert_i32_u (local.get $r))))))

  (func (export "score") (param $x f32) (param $y f32) (result i32)
    ;; Inner circle
    (call $is_inside (i32.const 1) (local.get $x) (local.get $y))
    (if (then (return (i32.const 10))))

    ;; Middle circle
    (call $is_inside (i32.const 5) (local.get $x) (local.get $y))
    (if (then (return (i32.const 5))))

    ;; Outside circle
    (call $is_inside (i32.const 10) (local.get $x) (local.get $y))
    (if (then (return (i32.const 1))))

    (return (i32.const 0))))
