(module
  (import "math" "random" (func $random (result f64)))
  ;; We need 2 pages (128KB) to store our bitset (~84.5KB) and the output string
  (memory (export "mem") 2)

  ;; Constants
  ;; Offset 0-84499: Bitset (used names)
  ;; Offset 84500: Output string buffer (5 bytes)
  (global $BITSET_SIZE i32 (i32.const 676000))
  (global $STR_OFFSET i32 (i32.const 84500))

  (func (export "generateName") (result i32 i32)
    (local $index i32)
    (local $byteIdx i32)
    (local $bitIdx i32)
    (local $mask i32)
    (local $temp i32)

    (loop $find_unique
      ;; Generate random index: floor(random() * 676000)
      (local.set $index 
        (i32.trunc_f64_u 
          (f64.mul (call $random) (f64.convert_i32_u (global.get $BITSET_SIZE)))
        )
      )

      ;; Calculate bitset location
      (local.set $byteIdx (i32.div_u (local.get $index) (i32.const 8)))
      (local.set $bitIdx (i32.rem_u (local.get $index) (i32.const 8)))
      (local.set $mask (i32.shl (i32.const 1) (local.get $bitIdx)))

      ;; Check if bit is set: (memory[byteIdx] & mask)
      (if (i32.and (i32.load8_u (local.get $byteIdx)) (local.get $mask))
        (then (br $find_unique)) ;; Already used, try again
      )

      ;; Mark as used: memory[byteIdx] |= mask
      (i32.store8 
        (local.get $byteIdx) 
        (i32.or (i32.load8_u (local.get $byteIdx)) (local.get $mask))
      )
    )

    ;; Convert index to Name (e.g., 0 -> AA000)
    ;; Char 1: index / (26 * 10 * 10 * 10) + 65 ('A')
    (i32.store8 
      (global.get $STR_OFFSET) 
      (i32.add (i32.div_u (local.get $index) (i32.const 26000)) (i32.const 65))
    )
    ;; Char 2: (index / 1000) % 26 + 65
    (i32.store8 
      (i32.add (global.get $STR_OFFSET) (i32.const 1)) 
      (i32.add (i32.rem_u (i32.div_u (local.get $index) (i32.const 1000)) (i32.const 26)) (i32.const 65))
    )
    ;; Digits
    (local.set $temp (i32.rem_u (local.get $index) (i32.const 1000)))
    ;; Char 3: (temp / 100) + 48 ('0')
    (i32.store8 
      (i32.add (global.get $STR_OFFSET) (i32.const 2)) 
      (i32.add (i32.div_u (local.get $temp) (i32.const 100)) (i32.const 48))
    )
    ;; Char 4: (temp / 10) % 10 + 48
    (i32.store8 
      (i32.add (global.get $STR_OFFSET) (i32.const 3)) 
      (i32.add (i32.rem_u (i32.div_u (local.get $temp) (i32.const 10)) (i32.const 10)) (i32.const 48))
    )
    ;; Char 5: temp % 10 + 48
    (i32.store8 
      (i32.add (global.get $STR_OFFSET) (i32.const 4)) 
      (i32.add (i32.rem_u (local.get $temp) (i32.const 10)) (i32.const 48))
    )

    (global.get $STR_OFFSET) (i32.const 5)
  )

  ;; Wipe the bitset memory to allow all names to be used again
  (func (export "releaseNames")
    (memory.fill (i32.const 0) (i32.const 0) (i32.const 84500))
  )
)
