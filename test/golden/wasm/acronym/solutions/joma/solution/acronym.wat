(module
    (import "console" "log_mem_as_utf8" (func $log_mem_as_utf8 (param $byteOffset i32) (param $length i32)))
    (import "console" "log_i32_u" (func $log_i32_u (param i32)))
  (memory (export "mem") 1)

    (global $abbr i32 (i32.const 0x100))
  (func $toupper (param $c i32) (result i32)
    (if (i32.and (i32.ge_s (local.get $c) (i32.const 97)) (i32.le_s (local.get $c) (i32.const 122)))
        (then (return (i32.sub (local.get $c) (i32.const 32)))))
    (local.get $c)
  )

  (func $isalpha (param $c i32) (result i32)
    (if (i32.or 
            (i32.and (i32.ge_s (local.get $c) (i32.const 97)) (i32.le_s (local.get $c) (i32.const 122)))
            (i32.and (i32.ge_s (local.get $c) (i32.const 65)) (i32.le_s (local.get $c) (i32.const 90))))
        (then (return (i32.const 1))))
    (i32.const 0)
  )

  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    (local $s i32) ;; char *s = offset;
    (local $c i32) ;; char c;
    (local $a i32) ;; char *a = abbr;
    (local $w i32) ;; bool w = true; // inside whitespace

    (local.set $s (local.get $offset))
    (local.set $a (global.get $abbr))
    (local.set $w (i32.const 1))
    
;;    (call $log_mem_as_utf8 (local.get $offset) (local.get $length))

    block
        loop
            ;; if (s>=&offset[length]) break;
            (br_if 1 (i32.ge_u (local.get $s) (i32.add (local.get $offset) (local.get $length))))
            ;; c = *s;
            (local.set $c (i32.load8_u (local.get $s)))

;;         (call $log_i32_u (local.get $c))
;;         (call $log_mem_as_utf8 (local.get $s) (i32.const 1))

            (if (i32.eqz (local.get $w))
                (then
                    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 45)))
                        (then 
                            ;; w = true;
                            (local.set $w (i32.const 1)))))
            
                (else
                    (if (call $isalpha (local.get $c))
                        (then 
                            ;; *a++ = toupper(c);
                            (i32.store8 (local.get $a) (call $toupper (local.get $c)))
                            (local.set $a (i32.add (local.get $a) (i32.const 1)))
                            ;; w = false;
                            (local.set $w (i32.const 0))))))

            ;; s++
            (local.set $s (i32.add (local.get $s) (i32.const 1)))

            (br 0)
        end
    end

    (return (global.get $abbr) (i32.sub (local.get $a) (global.get $abbr)))

  )
)
