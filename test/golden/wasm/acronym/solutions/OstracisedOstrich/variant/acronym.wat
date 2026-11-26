(module
  (memory (export "mem") 1) ;; Bytes 64 - 196 -> 128 reserved for input

  (func $is_separator (param $ch i32) (result i32)
    (i32.eq (local.get $ch) (i32.const 0x20)) ;; ' '
    (i32.eq (local.get $ch) (i32.const 0x2d)) ;; '-'
    i32.or
    (i32.eq (local.get $ch) (i32.const 0x5f)) ;; '_'
    i32.and
  )

  (func $cap (param $ch i32) (result i32)
    (i32.and (local.get $ch) (i32.const 0xdf)) ;; 0b11011111
  )

  (func (export "parse") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32)
    (local $w i32)
    (local $c i32)
    (local $f i32)
    (local $in_separator i32)

    (local.set $f (i32.const 1))

    (block $loop_break
      (loop $loop
        (br_if $loop_break (i32.eq (local.get $i) (local.get $length)))
        (local.set $c (i32.load8_u (i32.add (local.get $offset) (local.get $i))))
        (local.set $i (i32.add (local.get $i) (i32.const 1)))

        (if (call $is_separator (local.get $c))
          (then
            (if (i32.eqz (local.get $in_separator)) (then
              (local.set $w (i32.add (local.get $w) (i32.const 1)))
              (local.set $f (i32.const 1))))
            (local.set $in_separator (i32.const 1))
            (br $loop))
          (else
            (local.set $in_separator (i32.const 0))))

        (if (local.get $f)
          (then
            (local.set $f (i32.const 0))
            (i32.store8 (i32.add (i32.const 196) (local.get $w)) (call $cap (local.get $c)))))
        (br $loop)))
    (return (i32.const 196) (i32.add (local.get $w) (i32.const 1)))
  )
)
