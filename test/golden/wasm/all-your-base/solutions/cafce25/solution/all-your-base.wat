(module
  (memory (export "mem") 1)
  
  ;; Status codes returned as res[2]
  (global $ok i32 (i32.const 0))
  (global $inputHasWrongFormat i32 (i32.const -1))
  (global $wrongInputBase i32 (i32.const -2))
  (global $wrongOutputBase i32 (i32.const -3))

  ;; Returns offset and length of resulting u32[] and a return status code
  (func (export "convert") (param $arrOffset i32) (param $arrLength i32) (param $inputBase i32) (param $outputBase i32) (result i32 i32 i32)
    (local $number i32) (local $pos i32) (local $digit i32) (local $digitVal i32)
    local.get $inputBase
    i32.const 1
    i32.le_s
    if
      (return (i32.const 0) (i32.const 0) (i32.const -2))
    end
    local.get $outputBase
    i32.const 1
    i32.le_s
    if
      (return (i32.const 0) (i32.const 0) (i32.const -3))
    end

    (i32.or
      (i32.eqz
        (local.get $arrLength))
      (i32.and
        (i32.ne
          (local.get $arrLength)
          (i32.const 1))
        (i32.eqz
          (i32.load
            (local.get $arrOffset)))))
    if
      (return (i32.const 0) (i32.const 0) (i32.const -1))
    end
    loop
      (local.set $digit
        (i32.load
          (i32.add
            (local.get $arrOffset)
            (i32.mul
              (local.get $pos)
              (i32.const 4)))))
      (i32.lt_s
        (local.get $digit)
        (i32.const 0))
      if
        (return (i32.const 0) (i32.const 0) (i32.const -1))
      end

      (i32.ge_s
        (local.get $digit)
        (local.get $inputBase))
      if
        (return (i32.const 0) (i32.const 0) (i32.const -1))
      end
      (i32.add
        (local.get $digit)
        (i32.mul
          (local.get $number)
          (local.get $inputBase)))
      local.set $number

      (br_if 0
        (i32.lt_s
          (local.tee $pos
            (i32.add
              (local.get $pos)
              (i32.const 1)))
          (local.get $arrLength)))
    end

    i32.const 1
    local.set $digitVal
    loop
      local.get $number
      local.get $digitVal
      local.get $outputBase
      i32.mul
      local.tee $digitVal
      i32.div_u
      br_if 0
    end

    local.get $digitVal
    local.get $outputBase
    i32.div_u
    local.set $digitVal

    i32.const 0
    local.set $arrLength

    loop
      (;next position;)
      local.get $arrOffset
      local.get $arrLength
      i32.const 4
      i32.mul
      i32.add

      (;next digit;)
      local.get $number
      local.get $digitVal
      i32.div_u
      local.get $outputBase
      i32.rem_u

      i32.store

      (;increase length;)
      local.get $arrLength
      i32.const 1
      i32.add
      local.set $arrLength

      (;reduce digitVal;)
      local.get $digitVal
      local.get $outputBase
      i32.div_u
      local.tee $digitVal

      br_if 0
    end
    (return (local.get $arrOffset) (local.get $arrLength) (i32.const 0))
  )
)
