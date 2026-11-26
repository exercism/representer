(module
  (memory (export "mem") 1)
  
  ;;
  ;; Given a word, compute the Scrabble score for that word
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {i32} - the computed score
  ;;
  (func (export "score") (param $offset i32) (param $len i32) (result i32)
    (local $i i32)        ;; Loop counter
    (local $total i32)    ;; Running total score
    (local $char i32)     ;; Current character
    
    ;; Initialize total to 0
    (local.set $total (i32.const 0))
    
    ;; Process each character
    (local.set $i (i32.const 0))
    (block $done
      (loop $process_chars
        ;; Exit if we've processed all characters
        (br_if $done (i32.ge_u (local.get $i) (local.get $len)))
        
        ;; Get current character and convert to uppercase
        (local.set $char 
          (i32.load8_u (i32.add (local.get $offset) (local.get $i)))
        )
        
        ;; Convert lowercase to uppercase
        (if (i32.and
              (i32.ge_u (local.get $char) (i32.const 97))   ;; 'a'
              (i32.le_u (local.get $char) (i32.const 122))  ;; 'z'
            )
          (then
            (local.set $char (i32.sub (local.get $char) (i32.const 32)))
          )
        )
        
        ;; Add score based on character
        (block $add_score
          ;; 1 point: A, E, I, O, U, L, N, R, S, T
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 65))  ;; A
                (i32.or
                  (i32.eq (local.get $char) (i32.const 69))  ;; E
                  (i32.or
                    (i32.eq (local.get $char) (i32.const 73))  ;; I
                    (i32.or
                      (i32.eq (local.get $char) (i32.const 79))  ;; O
                      (i32.or
                        (i32.eq (local.get $char) (i32.const 85))  ;; U
                        (i32.or
                          (i32.eq (local.get $char) (i32.const 76))  ;; L
                          (i32.or
                            (i32.eq (local.get $char) (i32.const 78))  ;; N
                            (i32.or
                              (i32.eq (local.get $char) (i32.const 82))  ;; R
                              (i32.or
                                (i32.eq (local.get $char) (i32.const 83))  ;; S
                                (i32.eq (local.get $char) (i32.const 84))  ;; T
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 1)))
              (br $add_score)
            )
          )
          
          ;; 2 points: D, G
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 68))  ;; D
                (i32.eq (local.get $char) (i32.const 71))  ;; G
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 2)))
              (br $add_score)
            )
          )
          
          ;; 3 points: B, C, M, P
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 66))  ;; B
                (i32.or
                  (i32.eq (local.get $char) (i32.const 67))  ;; C
                  (i32.or
                    (i32.eq (local.get $char) (i32.const 77))  ;; M
                    (i32.eq (local.get $char) (i32.const 80))  ;; P
                  )
                )
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 3)))
              (br $add_score)
            )
          )
          
          ;; 4 points: F, H, V, W, Y
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 70))  ;; F
                (i32.or
                  (i32.eq (local.get $char) (i32.const 72))  ;; H
                  (i32.or
                    (i32.eq (local.get $char) (i32.const 86))  ;; V
                    (i32.or
                      (i32.eq (local.get $char) (i32.const 87))  ;; W
                      (i32.eq (local.get $char) (i32.const 89))  ;; Y
                    )
                  )
                )
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 4)))
              (br $add_score)
            )
          )
          
          ;; 5 points: K
          (if (i32.eq (local.get $char) (i32.const 75))  ;; K
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 5)))
              (br $add_score)
            )
          )
          
          ;; 8 points: J, X
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 74))  ;; J
                (i32.eq (local.get $char) (i32.const 88))  ;; X
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 8)))
              (br $add_score)
            )
          )
          
          ;; 10 points: Q, Z
          (if (i32.or
                (i32.eq (local.get $char) (i32.const 81))  ;; Q
                (i32.eq (local.get $char) (i32.const 90))  ;; Z
              )
            (then
              (local.set $total (i32.add (local.get $total) (i32.const 10)))
              (br $add_score)
            )
          )
        )
        
        ;; Move to next character
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $process_chars)
      )
    )
    
    ;; Return total score
    (local.get $total)
  )
)