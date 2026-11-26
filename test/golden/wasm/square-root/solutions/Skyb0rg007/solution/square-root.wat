(module
  (func (export "squareRoot") (param $radicand i32) (result i32)
    local.get $radicand
    f32.convert_i32_s
    f32.sqrt
    i32.trunc_f32_s
    return
  )
)
