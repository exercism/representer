(module
  ;; squareNum is signed
  ;; Result is unsigned
  (func $square (export "square") (param $squareNum i32) (result i64)
    ;; return 0 if out of bounds
    (if (i32.or
        (i32.le_s (local.get $squareNum) (i32.const 0))
        (i32.gt_s (local.get $squareNum) (i32.const 64))
      )
      (then (return (i64.const 0)))
      )
    ;; Num grains = (1 << (squareNum-1))
    (i64.shl
      (i64.const 1)
      (i64.extend_i32_s (i32.add
                          (local.get $squareNum)
                          (i32.const -1)
                          )))
  )

  ;; Result is unsigned
  (func (export "total") (result i64)
    ;; should return 2^64 - 1, but let's loop through and calculate it
    ;; It's no fun to just return a constant
    (local $square i32)
    (local.set $square (i32.const 64)) ;; Start at 64, go down to 0
    (block $end (result i64)
      i64.const 0 ;; Store our sum on the stack
      (loop (param i64) (result i64)
        ;; Loop 64 down to 1, exit if square == 0
        (br_if $end (i32.eqz
          (local.get $square)
          ))
        ;; Add the next square to our running total (on the stack)
        (call $square (local.get $square))
        i64.add
        ;; Decrement $square
        (local.set $square (i32.add
                             (local.get $square)
                             (i32.const -1)))
        br 0 ;; Go back to top of loop
        )
      )
    )
  )
