(module
  (memory (export "mem") 1)

  ;;
  ;; Encode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the encoded string in linear memory
  ;;
  (func (export "encode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $ipos i32) (local $opos i32) (local $char i32)
    (loop $chars
      (local.set $char (i32.and (i32.load8_u (i32.add (local.get $offset) (local.get $ipos))) (i32.const 32)))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 48)) (i32.le_u (local.get $char) (i32.const 57))) (then (i32.store8 (i32.add (i32.const 200) (local.get $opos)) (local.get $char)) (local.set $opos (i32.add (local.get $opos) (i32.const 1)))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 97)) (i32.le_u (local.get $char) (i32.const 122))) (then (i32.store8 (i32.add (i32.const 200) (local.get $opos)) (i32.sub (i32.const 219) (local.get $char))) (local.set $opos (i32.add (local.get $opos) (i32.const 1)))))
      (if (i32.eqz (i32.rem_s (i32.add (local.get $opos) (i32.const 1)) (i32.const 6))) (then (i32.store8 (i32.add (i32.const 200) (local.get $opos)) (i32.const 32)) (local.set $opos (i32.add (local.get $opos) (i32.const 1)))))
      (local.set $ipos (i32.add (local.get $ipos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $ipos) (local.get $length))))
    (loop $trim (if (i32.eq (i32.load8_u (i32.add (i32.const 199) (local.get $opos))) (i32.const 32)) (then (local.set $opos (i32.sub (local.get $opos) (i32.const 1))) (br $trim))))
    (return (i32.const 200) (local.get $opos))
  )

  ;;
  ;; Decode a string
  ;;
  ;; @param {i32} offset - The offset of the input string in linear memory
  ;; @param {i32} length - The length of the input string in linear memory
  ;;
  ;; @returns {(i32,i32)} - The offset and length of the decoded string in linear memory
  ;;
  (func (export "decode") (param $offset i32) (param $length i32) (result i32 i32)
    (local $ipos i32) (local $opos i32) (local $char i32)
    (loop $chars
      (local.set $char (i32.load8_u (i32.add (local.get $offset) (local.get $ipos))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 48)) (i32.le_u (local.get $char) (i32.const 57))) (then (i32.store8 (i32.add (i32.const 200) (local.get $opos)) (local.get $char)) (local.set $opos (i32.add (local.get $opos) (i32.const 1)))))
      (if (i32.and (i32.ge_u (local.get $char) (i32.const 97)) (i32.le_u (local.get $char) (i32.const 122))) (then (i32.store8 (i32.add (i32.const 200) (local.get $opos)) (i32.sub (i32.const 219) (local.get $char))) (local.set $opos (i32.add (local.get $opos) (i32.const 1)))))
      (local.set $ipos (i32.add (local.get $ipos) (i32.const 1)))
    (br_if $chars (i32.lt_u (local.get $ipos) (local.get $length))))
    (return (i32.const 200) (local.get $opos))
  )
)
