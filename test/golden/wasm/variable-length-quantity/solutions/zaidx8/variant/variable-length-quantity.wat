(module
  (memory (export "mem") 1)
  (global $incompleteSequence i32 (i32.const -1))

  ;; Start output buffers after input space (assume 1024 as safe margin)
  (global $BUFFER_START i32 (i32.const 1024))

  (func (export "encode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $i i32)
    (local $val i32)
    (local $outPtr i32)
    (local $tempPtr i32)
    (local $byteCount i32)

    (local.set $outPtr (global.get $BUFFER_START))
    (local.set $i (i32.const 0))

    (loop $input_loop
      (if (i32.lt_u (local.get $i) (local.get $inputLength))
        (then
          (local.set $val (i32.load (i32.add (local.get $inputOffset) (i32.mul (local.get $i) (i32.const 4)))))
          
          ;; Encode one u32 (Big Endian)
          ;; We use a temporary stack-like approach: 7 bits at a time
          (local.set $byteCount (i32.const 0))
          (local.set $tempPtr (i32.add (local.get $outPtr) (i32.const 10))) ;; temp space

          (loop $encode_val
            (local.set $tempPtr (i32.sub (local.get $tempPtr) (i32.const 1)))
            (local.set $byteCount (i32.add (local.get $byteCount) (i32.const 1)))
            
            ;; Set MSB to 1 if not the last byte (we'll fix the very last one later)
            (i32.store8 (local.get $tempPtr) (i32.or (i32.and (local.get $val) (i32.const 0x7F)) (i32.const 0x80)))
            
            (local.set $val (i32.shr_u (local.get $val) (i32.const 7)))
            (br_if $encode_val (i32.gt_u (local.get $val) (i32.const 0)))
          )

          ;; Fix the last byte (MSB should be 0)
          (i32.store8 
            (i32.add (local.get $tempPtr) (i32.sub (local.get $byteCount) (i32.const 1)))
            (i32.and (i32.load8_u (i32.add (local.get $tempPtr) (i32.sub (local.get $byteCount) (i32.const 1)))) (i32.const 0x7F))
          )

          ;; Copy from temp to outPtr
          (memory.copy (local.get $outPtr) (local.get $tempPtr) (local.get $byteCount))
          (local.set $outPtr (i32.add (local.get $outPtr) (local.get $byteCount)))
          
          (local.set $i (i32.add (local.get $i) (i32.const 1)))
          (br $input_loop)
        )
      )
    )

    (global.get $BUFFER_START)
    (i32.sub (local.get $outPtr) (global.get $BUFFER_START))
  )

  (func (export "decode") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $i i32)
    (local $byte i32)
    (local $acc i32)
    (local $outPtr i32)
    (local $count i32)

    (local.set $outPtr (global.get $BUFFER_START))
    (local.set $acc (i32.const 0))
    (local.set $i (i32.const 0))
    (local.set $count (i32.const 0))

    (loop $decode_loop
      (if (i32.lt_u (local.get $i) (local.get $inputLength))
        (then
          (local.set $byte (i32.load8_u (i32.add (local.get $inputOffset) (local.get $i))))
          
          ;; Shift accumulator and add 7 bits
          (local.set $acc (i32.or (i32.shl (local.get $acc) (i32.const 7)) (i32.and (local.get $byte) (i32.const 0x7F))))
          
          ;; Check MSB
          (if (i32.eqz (i32.and (local.get $byte) (i32.const 0x80)))
            (then
              ;; End of number found
              (i32.store (local.get $outPtr) (local.get $acc))
              (local.set $outPtr (i32.add (local.get $outPtr) (i32.const 4)))
              (local.set $acc (i32.const 0))
              (local.set $count (i32.add (local.get $count) (i32.const 1)))
            )
          )

          (local.set $i (i32.mul (local.get $i) (i32.const 1)))
          (br $decode_loop)
        )
      )
    )

    ;; Final Error Check: If last byte processed had MSB=1, it's an incomplete sequence
    (if (i32.and (i32.load8_u (i32.add (local.get $inputOffset) (i32.sub (local.get $inputLength) (i32.const 1)))) (i32.const 0x80))
      (then (return (global.get $incompleteSequence) (i32.const 0)))
    )

    (global.get $BUFFER_START)
    (local.get $count)
  )
)
