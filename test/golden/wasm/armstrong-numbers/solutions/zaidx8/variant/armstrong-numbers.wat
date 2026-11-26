(module
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $temp i32)
    (local $num_digits i32)
    (local $sum i32)
    (local $digit i32)
    (local $pow_res i32)
    (local $i i32)

    ;; Handle 0 immediately
    local.get $candidate
    i32.eqz
    if (result i32)
      i32.const 1
    else
      ;; Step 1: Count number of digits
      local.get $candidate
      local.set $temp
      loop $count
        local.get $num_digits
        i32.const 1
        i32.add
        local.set $num_digits
        local.get $temp
        i32.const 10
        i32.div_u
        local.set $temp
        local.get $temp
        br_if $count
      end

      ;; Step 2: Sum each digit raised to the power of $num_digits
      local.get $candidate
      local.set $temp
      loop $calc_sum
        local.get $temp
        i32.const 10
        i32.rem_u
        local.set $digit
        
        ;; Manual exponentiation: digit ^ num_digits
        i32.const 1
        local.set $pow_res
        local.get $num_digits
        local.set $i
        loop $power
          local.get $i
          if
            local.get $pow_res
            local.get $digit
            i32.mul
            local.set $pow_res
            local.get $i
            i32.const 1
            i32.sub
            local.set $i
            br $power
          end
        end
        
        local.get $sum
        local.get $pow_res
        i32.mul
        local.set $sum
        
        local.get $temp
        i32.const 10
        i32.div_u
        local.set $temp
        local.get $temp
        br_if $calc_sum
      end

      ;; Step 3: Check if sum equals original candidate
      local.get $sum
      local.get $candidate
      i32.eq
    end
  )
)
