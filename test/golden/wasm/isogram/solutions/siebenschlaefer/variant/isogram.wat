(module
  (memory (export "mem") 1)
  (global $ascii_a_lowercase i32 (i32.const 0x61))
  (global $ascii_z_lowercase i32 (i32.const 0x7A))
  (global $ascii_lowercase_bit i32 (i32.const 0x20))

  ;;
  ;; Determine if a word or phrase is an isogram.
  ;;
  ;; @param {i32} offset - offset of string in linear memory
  ;; @param {i32} length - length of string in linear memory
  ;;
  ;; @returns {i32} 1 if pangram, 0 otherwise
  ;;
  (func (export "isIsogram")
    (param $offset i32) (param $length i32) (result i32)
    (local $idx i32)
    (local $c i32)
    (local $bitmask i32)
    (local $bitset i32)

    ;; loop over the string, "remember" letters in a bitset
    (block $loop_end (loop $loop
      (br_if $loop_end (i32.eq (local.get $idx) (local.get $length)))
      (local.set $c (i32.load8_u (i32.add (local.get $offset) (local.get $idx))))

      ;; convert $c to lowercase
      (local.set $c (i32.or (local.get $c) (global.get $ascii_lowercase_bit)))

      ;; handle letters, ignore everything else
      (if (i32.and
          (i32.ge_s (local.get $c) (global.get $ascii_a_lowercase))
          (i32.le_s (local.get $c) (global.get $ascii_z_lowercase)))
        (then
          (local.set $bitmask (i32.shl (i32.const 1) (i32.sub
            (local.get $c) (global.get $ascii_a_lowercase))))

          ;; return false if we've seen the letter before
          ;; (i.e. if the corresponding bit in the bitset has been set)
          (if (i32.and (local.get $bitset) (local.get $bitmask))
            (then (return (i32.const 0))))

          ;; otherwise set that bit
          (local.set $bitset (i32.and (local.get $bitset) (local.get $bitmask)))
      ))

      (local.set $idx (i32.add (local.get $idx) (i32.const 1)))
      (br $loop)
    ))

    ;; no duplicate letters have been found, return true
    (return (i32.const 1))
  )
)