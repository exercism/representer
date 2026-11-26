(module
  ;; Returns 1 if leap year, 0 otherwise
  (func (export "isLeap") (param $year i32) (result i32)
    (local $isLeap i32) ;; Local variable to store the result

    ;; Check if year is divisible by 4
    (local.set $isLeap
      (i32.eqz
        (i32.rem_u (local.get $year) (i32.const 4))
      )
    )

    ;; Check if year is divisible by 100
    (if 
      (i32.eqz
        (i32.rem_u (local.get $year) (i32.const 100))
      )
      (then
        ;; Check if year is divisible by 400
        (local.set $isLeap
          (i32.eqz
            (i32.rem_u (local.get $year) (i32.const 400))
          )
        )
      )
    )

    ;; Return the result
    (local.get $isLeap)
  )  
)
