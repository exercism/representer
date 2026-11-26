(module
  (func (export "squareRoot") (param $radicand i32) (result i32)
    (local $guess f32)
    (local $new_guess f32)
    (local $diff f32)
    (local.set $guess (f32.const 10))

    ;; iterate with: new_guess = (guess + radicand / guess) / 2
    (loop $loop
      (local.set $new_guess 
        (f32.div (f32.add (local.get $guess) 
                          (f32.div (f32.convert_i32_u (local.get $radicand)) (local.get $guess)))
                 (f32.const 2)))
      (local.set $diff (f32.sub (local.get $new_guess) (local.get $guess)))
      (if (f32.lt (local.get $diff) (f32.const 0))
        (local.set $diff (f32.neg (local.get $diff))))
      (local.set $guess (local.get $new_guess))
      (br_if $loop (f32.gt (local.get $diff) (f32.const 0.1)))
    )
    (i32.trunc_f32_u (f32.nearest (local.get $new_guess)))
  )
)
