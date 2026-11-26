(module
  (func $squareOfSum (export "squareOfSum") (param $max i32) (result i32)
    (local $sum i32)
    ;; 1+2+...+n = n(n+1)/2
    local.get $max
    local.get $max
    i32.const 1
    i32.add
    i32.mul
    i32.const 2
    i32.div_u
    local.tee $sum
    local.get $sum
    i32.mul
  )

  (func $sumOfSquares (export "sumOfSquares") (param $max i32) (result i32)
    ;; 1^2+2^2+...+n^2 = n(n+1)(2n+1)/6
    local.get $max
    local.get $max
    i32.const 1
    i32.add
    i32.mul
    local.get $max
    local.get $max
    i32.add
    i32.const 1
    i32.add
    i32.mul
    i32.const 6
    i32.div_u
  )

  (func (export "difference") (param $max i32) (result i32)
    local.get $max
    call $squareOfSum
    local.get $max
    call $sumOfSquares
    i32.sub
  )
)
