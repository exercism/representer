(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $len f32)

    local.get $x
    local.get $x
    f32.mul

    local.get $y
    local.get $y
    f32.mul

    f32.add

    f32.sqrt
    local.set $len

    (block $b (result i32)
      i32.const 0

      local.get $len
      f32.const 10
      f32.gt

      br_if $b

      drop

      i32.const 1
      local.get $len
      f32.const 5
      f32.gt

      br_if $b

      drop

      i32.const 5
      local.get $len
      f32.const 1
      f32.gt

      br_if $b

      i32.const 10
      br $b
    )
  )
)
