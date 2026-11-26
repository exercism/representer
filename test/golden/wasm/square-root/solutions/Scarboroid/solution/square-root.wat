(module
  ;;
  ;; Return the square root of the given number.
  ;;
  ;; @param {i32} radicand
  ;;
  ;; @returns {i32} square root of radicand
  ;;
  (func (export "squareRoot") (param $radicand i32) (result i32)
    (i32.trunc_f32_s (f32.sqrt (f32.convert_i32_s (local.get $radicand))))
  )
)
