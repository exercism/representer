(module
  ;; Returns 1 if leap year, 0 otherwise
  (func (export "isLeap") (param $year i32) (result i32)
    local.get $year
    i32.const 4
    i32.rem_s
    i32.const 0
    i32.ne
    if (result i32)
      i32.const 0
    else
      local.get $year
      i32.const 100
      i32.rem_s
      i32.const 0
      i32.eq
      if (result i32)
        local.get $year
        i32.const 400
        i32.rem_s
        i32.const 0
        i32.eq
        if (result i32)
          i32.const 1
        else
          i32.const 0
        end
      else
        i32.const 1
      end
    end
  )
)
