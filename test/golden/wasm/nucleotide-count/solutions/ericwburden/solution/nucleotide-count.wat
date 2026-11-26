(module
  (memory (export "mem") 1)

  ;; Character codes for the nucleotides
  (global $A i32 (i32.const 65))
  (global $C i32 (i32.const 67))
  (global $G i32 (i32.const 71))
  (global $T i32 (i32.const 84))

  (func $incr (param $n i32) (result i32)
    (i32.add (local.get $n) (i32.const 1)))

  (func (export "countNucleotides") (param $offset i32) (param $length i32) (result i32 i32 i32 i32)
    (local $ACount i32)
    (local $CCount i32)
    (local $GCount i32)
    (local $TCount i32)
    (local $char   i32)
    (local $index  i32)
    (local $valid  i32)

    ;; Initialize nucleotide counts and string index to zero
    (local.set $ACount (i32.const 0))
    (local.set $CCount (i32.const 0))
    (local.set $GCount (i32.const 0))
    (local.set $TCount (i32.const 0))
    (local.set $index  (i32.const 0))

    ;; For each character in the string, if it matches one of the nucleotides,
    ;; increase the count of that nucleotide. If no nucleotide is matched, the
    ;; string is invalid and should be reported as such.
    (if (i32.gt_s (local.get $length) (i32.const 0)) 
      (loop
        (local.set $valid (i32.const 0))
        (local.set $char (i32.load8_s (i32.add (local.get $offset) (local.get $index))))
        (if (i32.eq (local.get $char) (global.get $A)) (then
          (local.set $ACount (call $incr (local.get $ACount)))
          (local.set $valid (i32.const 1))
        ))
        (if (i32.eq (local.get $char) (global.get $C)) (then
          (local.set $CCount (call $incr (local.get $CCount)))
          (local.set $valid (i32.const 1))
        ))
        (if (i32.eq (local.get $char) (global.get $G)) (then
          (local.set $GCount (call $incr (local.get $GCount)))
          (local.set $valid (i32.const 1))
        ))
        (if (i32.eq (local.get $char) (global.get $T)) (then
          (local.set $TCount (call $incr (local.get $TCount)))
          (local.set $valid (i32.const 1))
        ))

        (local.set $index (call $incr (local.get $index)))

        ;; If no nucleotide is matched, the string is invalid
        (if (i32.eqz (local.get $valid))
          (return (i32.const -1) (i32.const -1) (i32.const -1) (i32.const -1)))
          
        (br_if 0 (i32.lt_s (local.get $index) (local.get $length)))        
      )
    )
    
    (return (local.get $ACount) (local.get $CCount) (local.get $GCount) (local.get $TCount))
  )
)
