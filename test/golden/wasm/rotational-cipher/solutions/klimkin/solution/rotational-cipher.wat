(module
  (memory (export "mem") 1)

  (func (export "rotate") (param $textOffset i32) (param $textLength i32) (param $shiftKey i32) (result i32 i32)
    (local $i i32)
    (local $offset i32)
    (local $char i32)
    (local $lastChar i32)

    (loop $each_char
      (if (i32.eq (local.get $i) (local.get $textLength))
        (then
          (return (local.get $textOffset) (local.get $textLength))
        )
      )

      ;; load next character
      (local.set $offset (i32.add (local.get $textOffset) (local.get $i))) ;; offset = textOffset + i
      (local.set $char (i32.load8_u (local.get $offset)))                  ;; char = *offset

      ;; categorize letter interval
      (if (i32.and
            (i32.ge_u (local.get $char) (i32.const 97))     ;; char >= 'a'
            (i32.le_u (local.get $char) (i32.const 122))    ;; char <= 'z'
          )
        (then (local.set $lastChar (i32.const 122)))        ;; lastChar = 'z'
        (else
          (if (i32.and
                (i32.ge_u (local.get $char) (i32.const 65)) ;; char >= 'A'
                (i32.le_u (local.get $char) (i32.const 90)) ;; char <= 'Z'
              )
            (then (local.set $lastChar (i32.const 90)))     ;; lastChar = 'Z'
            (else (local.set $lastChar (i32.const 0)))      ;; lastChar = '\0'
          )
        )
      )

      ;; only rotate characters in intervals [a..z] or [A..Z]
      (if (i32.ne (local.get $lastChar) (i32.const 0))
        (then
          (local.set $char (i32.add (local.get $char) (local.get $shiftKey))) ;; char += shiftKey
          (if (i32.gt_u (local.get $char) (local.get $lastChar))              ;; if (char > lastChar)
            (then
              (local.set $char (i32.sub (local.get $char) (i32.const 26)))    ;; char -= 26
            )
          )
          (i32.store8 (local.get $offset) (local.get $char))                  ;; *offset = char
        )
      )

      (local.set $i (i32.add (local.get $i) (i32.const 1))) ;; i++
      br $each_char
    )
    unreachable
  )
)
