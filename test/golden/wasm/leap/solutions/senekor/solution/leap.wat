(module
  (func $isDivisibleBy (param $a i32) (param $b i32) (result i32)
    (i32.eqz (i32.rem_s (local.get $a) (local.get $b)))
  )

  ;; Returns 1 if leap year, 0 otherwise
  (func (export "isLeap") (param $year i32) (result i32)
    (if (call $isDivisibleBy (local.get $year) (i32.const 400))
      (then (return (i32.const 1)))
    )
    (if (call $isDivisibleBy (local.get $year) (i32.const 100))
      (then (return (i32.const 0)))
    )
    (call $isDivisibleBy (local.get $year) (i32.const 4))
  )  
)
