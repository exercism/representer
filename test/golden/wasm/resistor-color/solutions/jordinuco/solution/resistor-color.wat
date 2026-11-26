(module
  (global $char_comma i32 (i32.const 44))
  (global $$char_end i32 (i32.const 0))
  (global $struct_size i32 (i32.const 2))
  (memory (export "mem") 1)
  (data (i32.const 190) "black,brown,red,orange,yellow,green,blue,violet,grey,white")

  (func $get_colors_size (result i32)
    (local $pointer i32)
    (local $initial_pointer i32)
    (local.set $pointer (i32.const 190))
    (local.set $initial_pointer (local.get $pointer))
    (block $out
      (loop $loop
        local.get $pointer
        (call $is_end (i32.load8_u))
        br_if $out
        (local.set $pointer (i32.add (local.get $pointer) (i32.const 1)))
        br $loop
      )
    )
    (i32.sub (local.get $pointer) (local.get $initial_pointer))
  )

  ;; Return buffer of comma separated colors
  ;; black,brown,red,orange,yellow,green,blue,violet,grey,white
  (func (export "colors") (result i32 i32)
    (return (i32.const 190) (call $get_colors_size))
  )

  (func $get_color_pointer (param $code i32) (result i32)
    global.get $struct_size
    local.get $code
    i32.mul
  )

  (func $is_comma (param $char i32) (result i32)
    global.get $char_comma
    local.get $char
    i32.eq
  )

  (func $is_end (param $char i32) (result i32)
    global.get $$char_end
    local.get $char
    i32.eq
  )

  (func $get_color_data (param $code i32) (result i32 i32) ;; size + pointer
    (local $pos i32)
    (local $pointer i32)
    (call $get_color_pointer (local.get $code))
    local.tee $pos
    i32.load8_u
    local.set $pointer
    local.get $pos
    (i32.add (i32.const 1))
    i32.load8_u
    local.get $pointer
  )

  (func $save_color_data 
    (param $code i32)  
    (param $pointer i32) 
    (param $size i32) 
    (result i32) ;;next code
    
    (local $pos i32)
    (call $get_color_pointer (local.get $code))
    local.tee $pos
    (i32.store8 (local.get $pointer))
    local.get $pos
    (i32.add (i32.const 1))
    (i32.store8 (local.get $size))
    (i32.add (local.get $code) (i32.const 1))
  )

  ;; Called each time a module is initialized
  ;; Can be used to populate globals similar to a constructor
  (func $initialize
    (local $pointer i32)
    (local $code i32)
    (local $aux_pointer i32)
    (local $aux i32)
    (local $end i32)
    (local.tee $pointer (i32.const 190))
    local.set $aux_pointer
    (local.set $code (i32.const 0))
    (block $out
      (loop $next
        (local.tee $aux (i32.load8_u (local.get $pointer)))
        call $is_end
        local.tee $end
        (call $is_comma (local.get $aux))
        (if (i32.or)
          (then 
            (call $save_color_data 
              (local.get $code) 
              (local.get $aux_pointer) 
              (i32.sub (local.get $pointer) (local.get $aux_pointer)))
            local.set $code
            (br_if $out (local.get $end))
            (local.set $aux_pointer (i32.add (local.get $pointer) (i32.const 1)))
          )
        )
        (local.set $pointer (i32.add (local.get $pointer) (i32.const 1)))
        br $next
      )
    )
  )
  (start $initialize)

  ;; Given a valid resistor color, returns the associated value 
  (func (export "colorCode") (param $offset i32) (param $len i32) (result i32)
    (local $aux_offset i32)
    (local $local_offset i32)
    (local $local_size i32)
    (local $i i32)
    (local $code i32)
    (local.set $code (i32.const -1))
    (loop $loop
      (i32.add (i32.const 1) (local.get $code))
      local.tee $code
      call $get_color_data
      local.set $local_offset
      local.tee $local_size
      local.get $len
      i32.ne
      br_if $loop

      (local.set $i (i32.const 0))
      (local.set $aux_offset (local.get $offset))
      (loop $inner
        (i32.load8_u (local.get $aux_offset))
        (i32.load8_u (local.get $local_offset))
        i32.ne
        br_if $loop
        (local.set $aux_offset (i32.add (i32.const 1) (local.get $aux_offset)))
        (local.set $local_offset (i32.add (i32.const 1) (local.get $local_offset)))
        (i32.add (i32.const 1) (local.get $i))
        local.tee $i
        local.get $len
        i32.lt_u
        br_if $inner
      )
    )
    local.get $code
  )
)
