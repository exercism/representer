(module
  (func (export "score") (param $x f32) (param $y f32) (result i32)
    (local $distance f32)

    ;; x**2
    local.get $x
    local.get $x
    f32.mul

    ;; y**2
    local.get $y
    local.get $y
    f32.mul

    ;; distance = sqrt(x**2 + y**2)
    f32.add
    f32.sqrt
    local.set $distance

    ;; inside inner circle?
    local.get $distance
    f32.const 1
    f32.le
    (if
      (then
        ;; 10 points
        i32.const 10
        return
      )
    )

    ;; inside middle circle?
    local.get $distance
    f32.const 5
    f32.le
    (if
      (then
        ;; 5 points
        i32.const 5
        return
      )
    )

    ;; inside outer circle?
    local.get $distance
    f32.const 10
    f32.le
    (if
      (then
        ;; 1 point
        i32.const 1
        return
      )
    )

    ;; miss
    i32.const 0
    return
  )
)
