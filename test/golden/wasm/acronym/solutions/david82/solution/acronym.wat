(module
  ;; Export a single page of memory for the host environment.
  (memory (export "mem") 1)

  ;;
  ;; Converts a phrase into an acronym
  ;; i.e. "Ruby on Rails" -> "ROR"
  ;;
  ;; @param {i32} offset - offset of phrase in linear memory
  ;; @param {i32} length - length of phrase in linear memory
  ;;
  ;; @return {(i32, i32)} - offset and length of acronym
  ;;
  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    ;; Local variables:
    (local $acronym_length i32) ;; To store the length of the acronym.
    (local $i i32) ;; Iterator for the loop, to go through each character.
    (local $char i32) ;; To store the current character being processed.
    (local $pick_next i32) ;; Flag to indicate whether the next character should be picked for the acronym.

    ;; Initially, we want to pick the first character of the phrase.
    (local.set $pick_next (i32.const 1))

    ;; Loop to iterate through each character of the phrase.
    (loop $l
      ;; Load the current character from memory.
      (local.set $char (i32.load8_u (i32.add(local.get $offset)(local.get $i))))

      ;; Check if the current character should be added to the acronym.
      (if (i32.and(local.get $pick_next)(i32.or
        ;; Check if the character is an uppercase letter.
        (i32.and(i32.ge_u(local.get $char)(i32.const 0x41))(i32.le_u(local.get $char)(i32.const 0x5A)))
        ;; Check if the character is a lowercase letter.
        (i32.and(i32.ge_u(local.get $char)(i32.const 0x61))(i32.le_u(local.get $char)(i32.const 0x7A)))))
        (then 
          ;; Convert lowercase to uppercase if necessary and store the character.
          (i32.store8(i32.add(local.get $offset)(local.get $acronym_length))(select(local.get $char)(i32.sub(local.get $char)(i32.const 0x20))(i32.le_u(local.get $char)(i32.const 0x5A))))
          ;; Increment the length of the acronym.
          (local.set $acronym_length (i32.add(local.get $acronym_length)(i32.const 1)))
          ;; Reset the flag as we've picked a character for the acronym.
          (local.set $pick_next (i32.const 0)))
      )

      ;; Check if the current character is a space or a hyphen, indicating a word boundary.
      (if (i32.or(i32.eq(local.get $char)(i32.const 0x20))(i32.eq(local.get $char)(i32.const 0x2D)))
          (then (local.set $pick_next (i32.const 1)))
        )

      ;; Move to the next character.
      (local.set $i (i32.add(local.get $i)(i32.const 1)))

      ;; Continue the loop if there are more characters to process.
      (br_if $l (i32.lt_u(local.get $i)(local.get $length)))
    )

    ;; Return the offset and length of the acronym.
    (return (local.get $offset) (local.get $acronym_length))
  )
)
