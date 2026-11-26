(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
      (local $r f32)
      local.get $x
      local.get $x
      f32.mul

      local.get $y
      local.get $y
      f32.mul

      f32.add
      (local.set $r (f32.sqrt))

      local.get $r
      f32.const 10.0
      
      (if (f32.gt)
        (then
          i32.const 0
          return
        )        
      )

      local.get $r
      f32.const 5.0
      (if (f32.gt)
        (then
          i32.const 1
          return
        )        
      )

      local.get $r
      f32.const 1.0
      (if (f32.gt)
        (then
          i32.const 5
          return
        )        
      )

      i32.const 10
      return
  )
)
