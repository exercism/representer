(module
  (func (export "steps") (param $number i32) (result i32)
    (local $steps i32)
    (local.set $steps (i32.const 0))
    (if (i32.lt_s (local.get $number) (i32.const 1))
      (then (return (i32.const -1))))
    (block $iter
      (br_if $iter (i32.eq (local.get $number) (i32.const 1)))
    (loop $iter1
      (local.set $steps (i32.add (local.get $steps) (i32.const 1)))
      (br_if $iter1
        (i32.ne
          (local.tee $number
            (select
              (i32.add (i32.mul (local.get $number) (i32.const 3)) (i32.const 1))
              (i32.div_s (local.get $number) (i32.const 2))
              (i32.and (local.get $number) (i32.const 1))))
          (i32.const 1)))))
    (local.get $steps)
  )
)