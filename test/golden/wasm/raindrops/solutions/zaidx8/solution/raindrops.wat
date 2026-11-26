(module
  (memory (export "mem") 1)

  ;; Pre-load strings into memory at fixed offsets
  (data (i32.const 100) "Pling") ;; length 5
  (data (i32.const 105) "Plang") ;; length 5
  (data (i32.const 110) "Plong") ;; length 5

  (func (export "convert") (param $input i32) (result i32 i32)
    (local $offset i32) (local $len i32)
    (local $temp i32) (local $ptr i32)

    (local.set $ptr (i32.const 200)) ;; Write results starting here

    ;; 1. Check for 3 (Pling)
    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 3)))
      (then
        (memory.copy (local.get $ptr) (i32.const 100) (i32.const 5))
        (local.set $ptr (i32.add (local.get $ptr) (i32.const 5)))
        (local.set $len (i32.add (local.get $len) (i32.const 5)))
      )
    )

    ;; 2. Check for 5 (Plang)
    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 5)))
      (then
        (memory.copy (local.get $ptr) (i32.const 105) (i32.const 5))
        (local.set $ptr (i32.add (local.get $ptr) (i32.const 5)))
        (local.set $len (i32.add (local.get $len) (i32.const 5)))
      )
    )

    ;; 3. Check for 7 (Plong)
    (if (i32.eqz (i32.rem_u (local.get $input) (i32.const 7)))
      (then
        (memory.copy (local.get $ptr) (i32.const 110) (i32.const 5))
        (local.set $ptr (i32.add (local.get $ptr) (i32.const 5)))
        (local.set $len (i32.add (local.get $len) (i32.const 5)))
      )
    )

    ;; 4. If no factors, convert number to string
    (if (i32.eqz (local.get $len))
      (then
        (local.set $temp (local.get $input))
        ;; Handle 0 case
        (if (i32.eqz (local.get $temp))
          (then 
            (i32.store8 (i32.const 200) (i32.const 48))
            (return (i32.const 200) (i32.const 1))
          )
        )
        ;; Simple Int-to-ASCII (Reverse parsing)
        (local.set $ptr (i32.const 250)) ;; Workspace for digits
        (loop $itoa
          (if (i32.gt_u (local.get $temp) (i32.const 0))
            (then
              (local.set $ptr (i32.sub (local.get $ptr) (i32.const 1)))
              (i32.store8 (local.get $ptr) (i32.add (i32.rem_u (local.get $temp) (i32.const 10)) (i32.const 48)))
              (local.set $temp (i32.div_u (local.get $temp) (i32.const 10)))
              (local.set $len (i32.add (local.get $len) (i32.const 1)))
              (br $itoa)
            )
          )
        )
        (return (local.get $ptr) (local.get $len))
      )
    )

    (i32.const 200) (local.get $len)
  )
)
