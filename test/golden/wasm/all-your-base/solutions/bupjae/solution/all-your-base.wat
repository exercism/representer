(module
  (import "console" "log_i32_s" (func $log_i32_s (param i32)))

  (memory (export "mem") 1)
  
  ;; Status codes returned as res[2]
  (global $ok i32 (i32.const 0))
  (global $inputHasWrongFormat i32 (i32.const -1))
  (global $wrongInputBase i32 (i32.const -2))
  (global $wrongOutputBase i32 (i32.const -3))

  ;; Returns offset and length of resulting u32[] and a return status code
  (func (export "convert") (param $arrOffset i32) (param $arrLength i32) (param $inputBase i32) (param $outputBase i32) (result i32 i32 i32)
    (local $value i32)
    (local $temp i32)
    
    (local.get $inputBase)
    (i32.const 2)
    (i32.lt_s)
    (if (then
      (i32.const 0)
      (i32.const 0)
      (global.get $wrongInputBase)
      (return)
    ))

    (local.get $outputBase)
    (i32.const 2)
    (i32.lt_s)
    (if (then
      (i32.const 0)
      (i32.const 0)
      (global.get $wrongOutputBase)
      (return)
    ))

    (local.get $arrLength)
    (i32.eqz)
    (if (then
      (i32.const 0)
      (i32.const 0)
      (global.get $inputHasWrongFormat)
      (return)
    ))

    (local.get $arrOffset)
    (i32.load)
    (i32.eqz)
    (if (then
      (local.get $arrLength)
      (i32.const 1)
      (i32.eq)
      (if (then
        (local.get $arrOffset)
        (local.get $arrLength)
        (i32.const 0)
        (return)
      ) (else
        (i32.const 0)
        (i32.const 0)
        (global.get $inputHasWrongFormat)
        (return)
      ))
    ))

    (i32.const 0)
    (local.set $value)

    (loop $loop1      
      (local.get $arrOffset)
      (i32.load)
      (local.tee $temp)
      (local.get $inputBase)
      (i32.ge_u)
      (if (then
        (i32.const 0)
        (i32.const 0)
        (global.get $inputHasWrongFormat)
        (return)
      ))

      (local.get $value)
      (local.get $inputBase)
      (i32.mul)
      (local.get $temp)
      (i32.add)
      (local.set $value)

      (local.get $arrOffset)
      (i32.const 4)
      (i32.add)
      (local.set $arrOffset)
      (local.get $arrLength)
      (i32.const 1)
      (i32.sub)
      (local.tee $arrLength)
      (br_if $loop1)
    )

    (i32.const 65536)
    (local.set $arrOffset)
    (i32.const 0)
    (local.set $arrLength)

    (loop $loop2
      (local.get $arrLength)
      (i32.const 1)
      (i32.add)
      (local.set $arrLength)
      
      (local.get $arrOffset)
      (i32.const 4)
      (i32.sub)
      (local.tee $arrOffset)
      (local.get $value)
      (local.get $outputBase)
      (i32.rem_u)
      (i32.store)

      (local.get $value)
      (local.get $outputBase)
      (i32.div_u)
      (local.tee $value)
      (br_if $loop2)
    )

    (local.get $arrOffset)
    (local.get $arrLength)
    (global.get $ok)
  )
)
