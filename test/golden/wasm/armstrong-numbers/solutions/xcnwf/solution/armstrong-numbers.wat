(module
  (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (func $digits (param $n i32) (result i32)
    (local $val i32) 
    (local.set $val (i32.const 0))
    (loop $start
      (block $end
        local.get $n
        i32.eqz
        br_if $end
        
        ;; i++
        (local.get $val)
        i32.const 1
        i32.add
        local.set $val

        ;; n /= 10
        local.get $n
        i32.const 10
        i32.div_u
        local.set $n

        br $start
      )  
    )
  local.get $val
  )

  ;; fast exponentiation (by squaring)
  (func $pow (param $n i32) (param $p i32) (result i32)
    (local $val i32)
    (local.set $val (i32.const 1))
    (loop $start
      (block $end
        ;; break if p == 0
        local.get $p
        i32.eqz
        br_if $end
        
        ;; p&1 ? n : 1
        local.get $n
        i32.const 1
        local.get $p
        i32.const 1
        i32.and
        select

        ;; val *= n if p&1 (see above)
        local.get $val
        i32.mul
        local.set $val
        
        ;; n²
        local.get $n
        local.get $n
        i32.mul
        local.set $n

        ;; p >>= 1
        local.get $p
        i32.const 1
        i32.shr_u
        local.set $p

        br $start
      )  
    )
    local.get $val
  )

  ;; returns 1 if armstrong number, 0 otherwise
  (func (export "isArmstrongNumber") (param $candidate i32) (result i32)
    (local $ndigits i32)
    (local $val i32)
    (call $digits (local.get $candidate))
    local.set $ndigits
    local.get $candidate
    
    (loop $start
      (block $end
        ;; break if candidate == 0
        local.get $candidate
        i32.eqz
        br_if $end

        ;; result += pow(candidate % 10,ndigits)
        local.get $candidate
        i32.const 10
        i32.rem_u
        local.get $ndigits
        call $pow
        local.get $val
        i32.add
        local.set $val
        
        ;; candidate /= 10
        local.get $candidate
        i32.const 10
        i32.div_u
        local.set $candidate

        br $start
      )  
    )
    local.get $val
    i32.eq
  )
)
