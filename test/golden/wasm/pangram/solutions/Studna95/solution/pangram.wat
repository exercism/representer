(module
  (memory (export "mem") 1)

  ;; return 1 if pangram, 0 otherwise
  (func (export "isPangram") (param $offset i32) (param $length i32) (result i32)
    ;; Algorithm:
    ;; Allocate a-z bytes in memory, set false for each byte
    ;; Iterate sentence, set memory byte to true for each car in the allocated memory
    ;; In the end, check if all bytes are true

    ;; Declare variables
    (local $array_start i32)
    (local $array_size i32)
    (local $i i32)
    (local $char_offset i32)
    (local $current_char_value i32)

    ;; Setup memory
    (local.set $array_start (i32.const 1024))
    (local.set $array_size (i32.const 26))


    ;; Iterate all chars in sentece
    (local.set $i (i32.const 0))
    (loop $loop
      ;; Get current char value
      local.get $offset
      local.get $i
      i32.add
      i32.load8_u
      local.tee $current_char_value
      ;; Check if is upppercase/lowercase and subtract correct ASCII offset value
      i32.const 96
      i32.gt_u
      ;; TODO: Figure out better way of this if statement.
      (if
        (then
          ;; Get char offset
          local.get $current_char_value
          i32.const 97
          i32.sub
          local.get $array_start
          i32.add
          local.set $char_offset
        )
        (else
          ;; Get char offset
          local.get $current_char_value
          i32.const 65
          i32.sub
          local.get $array_start
          i32.add
          local.set $char_offset
        )
      )    
      ;; Set byte to true for the current char
      local.get $char_offset
      i32.const 1
      i32.store8
      
      ;; Increase $i
      local.get $i
      i32.const 1
      i32.add
      (local.tee $i)
      
      ;; Loop if $i < $length
      local.get $length
      i32.lt_u
      br_if $loop
    )

    ;; Check all chars in memory are set to true
    (local.set $i (i32.const 0))
    (loop $check_loop
      ;; Check current char is true
      local.get $array_start
      local.get $i
      i32.add
      i32.load8_u
      i32.const 1
      i32.ne
      (if
        (then
          (return (i32.const 0)) 
        )  
      )      
    
      ;; Increase $i
      local.get $i
      i32.const 1
      i32.add
      (local.tee $i)

      ;; Loop if $i < $array_size
      local.get $array_size
      i32.lt_u
      br_if $check_loop
    )
    
    (return (i32.const 1))
  )
)
