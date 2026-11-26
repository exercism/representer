(module
  (memory (export "mem") 1)

(func $writeRun (param $c i32) (param $count i32) (param $offset i32)
  (result i32)
  (local $numOffset i32)
  (local.set $numOffset (i32.const 800))
  (if (i32.ne (local.get $count) (i32.const 0))
    (then
      (if (i32.gt_s (local.get $count) (i32.const 1))
        (then 
          (loop $buildCountLoop
            (i32.store (local.get $numOffset) 
              (i32.add (i32.const 48) (i32.rem_s (local.get $count) (i32.const 10))))
            (local.set $numOffset (i32.add (i32.const 1) (local.get $numOffset)))
            (local.set $count (i32.div_s (local.get $count) (i32.const 10)))
            (br_if $buildCountLoop (i32.ge_s (local.get $count) (i32.const 0))))))
      (loop $writeCountLoop 
        (block $breakWriteCountLoop
          (br_if $breakWriteCountLoop (i32.eq (local.get $numOffset) (i32.const 800)))
          (local.set $numOffset (i32.sub (local.get $numOffset) (i32.const 1)))
          (i32.store (local.get $offset) (i32.load (local.get $numOffset)))
          (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
          (br $writeCountLoop)))
      (i32.store (local.get $offset) (local.get $c))
      (local.set $offset (i32.add (i32.const 1) (local.get $offset)))))
  (return (local.get $offset)))

  ;;
  ;; Encode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the input string in linear memory
  ;; @param {i32} inputLength - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)
    (local $inputEnd i32)
    (local $prev i32)
    (local $count i32)
    (local $offset i32)
    (local $length i32)
    (local $c i32)
    (local.set $inputEnd (i32.add (local.get $inputOffset) (local.get $inputLength)))
    (local.set $prev (i32.const -1))
    (local.set $count (i32.const 0))
    (local.set $offset (i32.const 320))
    (loop $encodeLoop
      (local.set $c (i32.load8_u (local.get $inputOffset)))
      (local.set $inputOffset (i32.add (i32.const 1) (local.get $inputOffset)))
      (if (i32.ne (local.get $prev) (local.get $c))
        (then 
          (local.set $offset (call $writeRun (local.get $prev) (local.get $count) (local.get $offset)))
          (local.set $prev (local.get $c))
          (local.set $count (i32.const 1)))
        (else
          (local.set $count (i32.add (i32.const 1) (local.get $count)))))
      (br_if $encodeLoop (i32.le_s (local.get $inputOffset) (local.get $inputEnd))))
    (local.set $offset (call $writeRun (local.get $c) (local.get $count) (local.get $offset)))
    (return (i32.const 320) (i32.sub (local.get $offset) (i32.const 321))))


  ;;
  ;; Decode a string using run-length encoding
  ;;
  ;; @param {i32} inputOffset - The offset of the string in linear memory
  ;; @param {i32} inputLength - The length of the string in linear memory
  ;;
  ;; returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $inputOffset i32) (param $inputLength i32)
    (result i32 i32)
    (local $inputEnd i32)
    (local $numOffset i32)
    (local $numStart i32)
    (local $numVal i32)
    (local $offset i32)
    (local $length i32)
    (local $c i32)
    (local.set $numOffset (i32.const 800))
    (local.set $numStart (i32.const 800))
    (local.set $numVal (i32.const 0))
    (local.set $offset (i32.const 320))
    (local.set $length (i32.const 0))
    (local.set $inputEnd (i32.add (local.get $inputOffset) (local.get $inputLength)))
    (loop $decodeLoop
      (block $breakDecodeLoop
        (br_if $breakDecodeLoop (i32.eq (local.get $inputOffset) (local.get $inputEnd)))
        (local.set $c (i32.load8_u (local.get $inputOffset)))
        (local.set $inputOffset (i32.add (i32.const 1) (local.get $inputOffset)))
        (if (i32.and (i32.ge_s (local.get $c) (i32.const 48)) (i32.le_s (local.get $c) (i32.const 57)))
          (then
            (i32.store (local.get $numOffset) (i32.sub (local.get $c) (i32.const 48)))
            (local.set $numOffset (i32.add (i32.const 1) (local.get $numOffset))))
          (else
            (loop $decodeNumLoop
              (block $breakDecodeNumLoop
                (br_if $breakDecodeNumLoop (i32.eq (local.get $numStart) (local.get $numOffset)))
                (local.set $numVal (i32.add (i32.load8_u (local.get $numStart)) (i32.mul (local.get $numVal) (i32.const 10))))
                (local.set $numStart (i32.add (i32.const 1) (local.get $numStart)))
                (br $decodeNumLoop)))
            (if (i32.eqz (local.get $numVal))
              (then (local.set $numVal (i32.const 1))))
            (memory.fill (i32.add (local.get $offset) (local.get $length)) (local.get $c) (local.get $numVal))
            (local.set $length (i32.add (local.get $length) (local.get $numVal)))
            (local.set $numOffset (i32.const 800))
            (local.set $numStart (i32.const 800))
            (local.set $numVal (i32.const 0))))
        (br $decodeLoop)))
    (return (local.get $offset) (local.get $length))))
