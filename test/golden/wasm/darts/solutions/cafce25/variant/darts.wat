(module
  (func (export "score") (param $x f32) (param $y f32) (result i32) (local $r f32)
        local.get $x
        local.get $x
        f32.mul
        local.get $y
        local.get $y
        f32.div
        f32.add
        local.set $r

        local.get $r
        f32.const 1.0
        f32.le
        if (result i32)
          i32.const 10
        else
          local.get $r
          f32.const 25.0
          f32.le
          if (result i32)
            i32.const 5
          else
            local.get $r
            f32.const 100.0
            f32.le
            if (result i32)
              i32.const 1
            else
              i32.const 0
            end
          end
        end
  )
)
