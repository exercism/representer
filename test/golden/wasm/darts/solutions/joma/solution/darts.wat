(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $r2 f32)
    (local $points i32)

    local.get $x
    local.get $x
    f32.mul 
    local.get $y
    local.get $y
    f32.mul 
    f32.add
    (local.set $r2)
    
    i32.const 10
    local.set $points

    block
        local.get $r2
        f32.const 1
        f32.le
        br_if 0

        i32.const 5
        local.set $points

        local.get $r2
        f32.const 25
        f32.le
        br_if 0

        local.get $r2
        f32.const 100
        f32.le
        local.set $points

    end

  local.get $points
  )
)
