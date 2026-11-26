(module
  (memory (export "mem") 1)

  (func $is_upper
    (param $c i32)
    (result i32)
    (i32.and
      (i32.ge_u
        (local.get $c)
        (i32.const 0x41))
      (i32.le_u
        (local.get $c)
        (i32.const 0x5a))))

  (func $is_lower
    (param $c i32)
    (result i32)
    (i32.and
      (i32.ge_u
        (local.get $c)
        (i32.const 0x61))
      (i32.le_u
        (local.get $c)
        (i32.const 0x7a))))

  (func $to_lower
    (param $c i32)
    (result i32)
    (if
      (call $is_upper
        (local.get $c))
      (then
        (local.set $c
          (i32.add
            (local.get $c)
            (i32.const 0x20)))))
    (local.get $c))

  (func $is_num
    (param $c i32)
    (result i32)
    (i32.and
      (i32.ge_u
        (local.get $c)
        (i32.const 0x30))
      (i32.le_u
        (local.get $c)
        (i32.const 0x39))))

  (func $is_alphanum
    (param $c i32)
    (result i32)
    (i32.or
      (i32.or
        (call $is_upper
          (local.get $c))
        (call $is_lower
          (local.get $c)))
      (call $is_num
        (local.get $c))))

  (func $transpose
    (param $c i32)
    (result i32)
    (if
      (i32.eqz
        (call $is_num
          (local.get $c)))
      (then
        (local.set $c
          (i32.sub
            (i32.const 219)
            (call $to_lower
              (local.get $c))))))
    (local.get $c))

  ;;
  ;; Encode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32)
    (local $c i32)
    (local $dest i32)
    (local $outlen i32)
    (local.set $dest
      (i32.add
        (local.get $offset)
        (local.get $length)))
    (loop $loop
      (local.set $c
        (i32.load8_u
          (i32.add
            (local.get $offset)
            (local.get $i))))
      (if
        (call $is_alphanum
          (local.get $c))
        (then
          (if
            (i32.eqz
              (i32.rem_u
                (i32.add
                  (local.get $outlen)
                  (i32.const 1))
                (i32.const 6)))
            (then
              (i32.store8
                (i32.add
                  (local.get $dest)
                  (local.get $outlen))
                (i32.const 32))
              (local.set $outlen
                (i32.add
                  (local.get $outlen)
                  (i32.const 1)))))
          (i32.store8
            (i32.add
              (local.get $dest)
              (local.get $outlen))
            (call $transpose
              (local.get $c)))
          (local.set $outlen
            (i32.add
              (local.get $outlen)
              (i32.const 1)))))
      (br_if $loop
        (i32.lt_u
          (local.tee $i
            (i32.add
              (local.get $i)
              (i32.const 1)))
          (local.get $length))))
    (local.get $dest)
    (local.get $outlen))

  ;;
  ;; Decode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $i i32)
    (local $c i32)
    (local $dest i32)
    (local $outlen i32)
    (local.set $dest
      (i32.add
        (local.get $offset)
        (local.get $length)))
    (loop $loop
      (local.set $c
        (i32.load8_u
          (i32.add
            (local.get $offset)
            (local.get $i))))
      (if
        (call $is_alphanum
          (local.get $c))
        (then
          (i32.store8
            (i32.add
              (local.get $dest)
              (local.get $outlen))
            (call $transpose
              (local.get $c)))
          (local.set $outlen
            (i32.add
              (local.get $outlen)
              (i32.const 1)))))
      (br_if $loop
        (i32.lt_u
          (local.tee $i
            (i32.add
              (local.get $i)
              (i32.const 1)))
          (local.get $length))))
    (local.get $dest)
    (local.get $outlen))
)
