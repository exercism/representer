(module
  (memory (export "mem") 1) ;; Exported memory, starting with 1 page (64KB)

  (func (export "reverseString") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32) ;; Local variable for iteration
    (local $j i32) ;; Local variable for iteration from the end of the string
    (local $temp i32) ;; Temporary variable for swapping characters

    ;; Initialize $i to the start of the string and $j to the end
    (local.set $i (local.get $offset))
    (local.set $j (i32.add (local.get $offset) (i32.sub (local.get $length) (i32.const 1))))

    ;; Loop to reverse the string
    (block
      (loop
        ;; Check if $i < $j
        (br_if 1 (i32.ge_s (local.get $i) (local.get $j)))

        ;; Swap characters at $i and $j
        ;; Load character at $i
        (local.set $temp (i32.load8_u (local.get $i)))

        ;; Load character at $j and store at $i
        (i32.store8 (local.get $i) (i32.load8_u (local.get $j)))

        ;; Store character from $temp at $j
        (i32.store8 (local.get $j) (local.get $temp))

        ;; Increment $i and decrement $j
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (local.set $j (i32.sub (local.get $j) (i32.const 1)))

        ;; Loop back
        (br 0)
      )
    )

    ;; Return the offset and length of the reversed string
    (return (local.get $offset) (local.get $length))
  )
)
