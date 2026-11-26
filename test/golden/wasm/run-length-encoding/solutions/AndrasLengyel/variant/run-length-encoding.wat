(module
  (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))

  (memory (export "mem") 1)

  ;;
  ;; Encode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the input string in linear memory
  ;; @param {i32} inputLength - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)

    (local $outputOffset i32)
    (local $outputLength i32)
    (local $inputIndex   i32)
    (local $currChar     i32)
    (local $char         i32)
    (local $currCount    i32)
    (local $writeLen     i32)

    (local.set $outputOffset (i32.const 320))
    (local.set $outputLength (i32.const 0))
    (local.set $currCount    (i32.const 0))

    (block $loop
      (loop $repeat
        (if (i32.eq (local.get $inputIndex) (local.get $inputLength))
          (then (br $loop)))
  
        (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $inputIndex))))
        (if (i32.ne (local.get $char) (local.get $currChar)) 
          (then 
            (if (i32.gt_u (local.get $currCount) (i32.const 0))
              (then 
                (if (i32.gt_u (local.get $currCount) (i32.const 1)) 
                  (then
                    (local.set $writeLen (call $writeInt (i32.add (local.get $outputOffset) (local.get $outputLength)) (local.get $currCount)))
                    (local.set $outputLength (i32.add (local.get $outputLength) (local.get $writeLen)))
                ))
                (i32.store8 (i32.add (local.get $outputOffset) (local.get $outputLength)) (local.get $currChar))
                (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
                (local.set $currCount (i32.const 0))
              ))
          )
        )
  
        (local.set $currChar (local.get $char))
        (local.set $currCount (i32.add (local.get $currCount) (i32.const 1)))
  
        (local.set $inputIndex (i32.add (local.get $inputIndex) (i32.const 1)))

        (call $log_i32_u (local.get $currChar))
        (call $log_i32_u (local.get $currCount))

        (br $repeat)
      )
    )

    (if (i32.gt_u (local.get $currCount) (i32.const 0))
      (then 
        (if (i32.gt_u (local.get $currCount) (i32.const 1)) 
          (then
            (local.set $writeLen (call $writeInt (i32.add (local.get $outputOffset) (local.get $outputLength)) (local.get $currCount)))
            (local.set $outputLength (i32.add (local.get $outputLength) (local.get $writeLen)))
        ))
        (i32.store (i32.add (local.get $outputOffset) (local.get $outputLength)) (local.get $currChar))
        (local.set $outputLength (i32.add (local.get $outputLength) (i32.const 1)))
        (local.set $currCount (i32.const 0))
      ))

    (return (local.get $outputOffset) (local.get $outputLength))
  )

  (func $writeInt (param $outputOffset i32) (param $value i32)
    (result i32)

    (local $digitCount  i32)
    (local $remValue    i32)
    (local $outputIndex i32)
    (local $digit       i32)

    (local.set $digitCount (i32.const 0))
    (local.set $remValue   (local.get $value))

    (loop $lengthLoop
      (local.set $digitCount (i32.add (local.get $digitCount) (i32.const 1)))
      (local.set $remValue (i32.rem_u (local.get $remValue) (i32.const 10)))
      (br_if $lengthLoop (local.get $remValue))
    )

    (local.set $outputIndex (i32.sub (local.get $digitCount) (i32.const 1)))
    (local.set $remValue (local.get $value))

    (loop $digitLoop
      (local.set $digit    (i32.rem_u (local.get $remValue) (i32.const 10)))
      (local.set $remValue (i32.div_u (local.get $remValue) (i32.const 10)))

      (i32.store8 (i32.add (local.get $outputOffset) (local.get $outputIndex))
        (i32.add (local.get $digit) (i32.const 48)))
      (local.set $outputIndex (i32.sub (local.get $outputIndex) (i32.const 1)))

      (br_if $digitLoop (local.get $remValue))
    )

    (return (local.get $digitCount))
  ) 

  ;;
  ;; Decode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the string in linear memory
  ;; @param {i32} inputLength - The length of the string in linear memory
  ;;
  ;; returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)

    (local $inputIndex   i32)
    (local $outputBase   i32) 
    (local $outputIndex  i32) 
    (local $char         i32) 
    (local $currCount    i32)

    (if (i32.eqz (local.get $inputLength))
      (then (return (local.get $inputOffset) (i32.const 0))))

    (local.set $inputIndex   (i32.const 0))
    (local.set $outputBase   (i32.const 320))
    (local.set $outputIndex  (i32.const 0))
    (local.set $currCount    (i32.const 0))

    (loop $loop
      (local.set $char       (i32.load8_u (i32.add (local.get $inputOffset) (local.get $inputIndex))))
      (local.set $inputIndex (i32.add (local.get $inputIndex) (i32.const 1)))

      (if (i32.and 
            (i32.ge_u (local.get $char) (i32.const 48))
            (i32.le_u (local.get $char) (i32.const 57)))
        (then 
          (local.set $currCount (i32.add 
            (i32.mul (local.get $currCount) (i32.const 10)) 
            (i32.sub (local.get $char) (i32.const 48))
          ))
        )
        (else 
          (loop $repeat
            (i32.store8 (i32.add (local.get $outputBase) (local.get $outputIndex)) (local.get $char))
            (local.set $outputIndex (i32.add (local.get $outputIndex) (i32.const 1)))
            (local.set $currCount       (i32.sub (local.get $currCount) (i32.const 1)))
            
            (br_if $repeat (i32.ge_s (local.get $currCount) (i32.const 1)))
          )
          (local.set $currCount (i32.const 0))
        )
      )
    
      (br_if $loop (i32.lt_u (local.get $inputIndex) (local.get $inputLength)))
    )

    (return (local.get $outputBase) (local.get $outputIndex))
  )
)
