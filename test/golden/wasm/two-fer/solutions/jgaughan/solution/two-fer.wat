(module
  (memory (export "mem") 1)
  (data (i32.const 8) "One for you, one for me.")
  (global $phraseOffset i32 (i32.const 8))
  (global $phraseLength i32 (i32.const 24))  ;; full phrase
  (global $prefixLength i32 (i32.const 8))   ;; "One for "
  (global $endingOffset i32 (i32.const 19))
  (global $endingLength i32 (i32.const 13))  ;; ", one for me."
  (global $outputOffset i32 (i32.const 256))

  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (local $outputPosition i32)
    (local $outputLength i32)

    (if (i32.eqz (local.get $length))
      (then
        (return (global.get $phraseOffset) (global.get $phraseLength))
      )
    )

    (local.set $outputPosition (global.get $outputOffset))

    ;; copy prefix
    (call $copy (global.get $phraseOffset) (local.get $outputPosition) (global.get $prefixLength))

    (local.set $outputPosition
      (i32.add (local.get $outputPosition) (global.get $prefixLength))
    )

    ;; copy name
    (call $copy (local.get $offset) (local.get $outputPosition) (local.get $length))

    (local.set $outputPosition
      (i32.add (local.get $outputPosition) (local.get $length))
    )

    ;; copy ending
    (call $copy (global.get $endingOffset) (local.get $outputPosition) (global.get $endingLength))

    (local.set $outputLength
      (i32.add
        (i32.add
          (global.get $prefixLength)
          (local.get $length)
        )
        (global.get $endingLength)
      )
    )

    (return (global.get $outputOffset) (local.get $outputLength))
  )

  (func $copy (param $src i32) (param $dst i32) (param $len i32)
    (local $lastSrcByte i32)

    (local.set $lastSrcByte
      (i32.add (local.get $src) (local.get $len))
    )

    (loop $copyLoop (block $break
      local.get $dst
      (i32.load8_u (local.get $src))
      i32.store8

      (local.set $src
        (i32.add (local.get $src) (i32.const 1))
      )

      (local.set $dst
        (i32.add (local.get $dst) (i32.const 1))
      )

      (br_if $break
        (i32.eq (local.get $src) (local.get $lastSrcByte))
      )

      (br $copyLoop)
    ))
  )
)
