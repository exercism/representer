(module
  ;; Returns 1 if leap year, 0 otherwise
  (func (export "isLeap") (param $year i32) (result i32)
    (if (i32.rem_u (local.get $year) (i32.const 4))
      (then
        (return (i32.const 0))
      )
    )
    (if (i32.eqz (i32.rem_u (local.get $year) (i32.const 100)))
      (then
        (if (i32.eqz (i32.rem_u (local.get $year) (i32.const 400)))
          (then
            (return (i32.const 1))
          )
        )
        (return (i32.const 0))
      )
    )
    (return (i32.const 1))
  )  
)
