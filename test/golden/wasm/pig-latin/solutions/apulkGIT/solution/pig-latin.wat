(module
  (memory (export "mem") 1)
  
  (data (i32.const 0) "a\00\00e\00\00i\00\00o\00\00u\00\00xr\00yt\00")

  (data (i32.const 30) "bcdfghjklmnpqrstvwxz")
  (data (i32.const 55) "ay")

  (func $getlen (param $inputoffset i32) (param $inputlength i32) (result i32) 
    (local $char i32)
    (local $i i32)
    (loop $lenloop
      (local.set $char (i32.load8_u (i32.add (local.get $inputoffset) (local.get $i))))
      (if (i32.and (i32.and (i32.ne (local.get $char) (i32.const 10)) (i32.ne (local.get $char) (i32.const 0)))
                   (i32.ne (local.get $char) (i32.const 32)))
      (then
        (local.set $i (i32.add (local.get $i) (i32.const 1)))  
        (br_if $lenloop (i32.ne (local.get $inputlength) (local.get $i)))
      ))
    )
    (return (local.get $i))
  )

  (func $comparestrings (param $soffset1 i32) (param $slen1 i32) (param $soffset2 i32) (param $slen2 i32) (result i32)
    (local $i i32)
    (local $char1 i32)
    (local $char2 i32)
    ;;(if (i32.ne (local.get $slen1) (local.get $slen2))
    ;;(then
    ;;  (return (i32.const 0))
    ;;))
    (loop $equalloop
      (local.set $char1 (i32.load8_u(i32.add (local.get $soffset1) (local.get $i))))
      (local.set $char2 (i32.load8_u(i32.add (local.get $soffset2) (local.get $i))))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $equalloop (i32.and (i32.eq (local.get $char1) (local.get $char2)) (i32.and (i32.lt_s(local.get $i) (local.get $slen1)) (i32.lt_s(local.get $i) (local.get $slen2)))))
    )
    (if (i32.lt_u (local.get $char1) (local.get $char2))
    (then
      (return (i32.const -1))
    )
    (else
      (if (i32.gt_u (local.get $char1) (local.get $char2))
      (then
        (return (i32.const 1))
      )
      (else
        (return (i32.const 0))
      ))
    ))
    unreachable
  )

  ;;
  ;; translates text into pig latin
  ;;
  ;; @param {i32} $inputOffset - offset of the input in linear memory
  ;; @param {i32} $inputLength - length of the input in linear memory
  ;;
  ;; @returns {(i32,i32)} - offset and length of the output in linear memory
  ;;
  (func (export "translate") (param $inputOffset i32) (param $inputLength i32) (result i32 i32)
    (local $i i32)
    (local $slen i32)
    (local $j i32)
    (local $res i32)
    (local $dest i32)
    (local $flag i32)
    (local $char i32)
    (local $k i32)
    (local $char2 i32)

    (local.set $dest (i32.const 512))
    (loop $translateloop
      (if (i32.eq (local.get $flag) (i32.const 1))
      (then 
        (i32.store8 (local.get $dest) (i32.const 32))
        (local.set $dest (i32.add (local.get $dest) (i32.const 1)))
      ))
      (local.set $flag (i32.const 0))
      ;; rule 1
      (local.set $j (i32.const 0))
      (loop $vowelloop
        (local.set $slen (call $getlen (i32.mul (local.get $j) (i32.const 3)) (i32.const 3)))
        (local.set $res (call $comparestrings (i32.add (local.get $inputOffset) (local.get $i)) (local.get $slen) (i32.mul (local.get $j) (i32.const 3)) (local.get $slen)))
        (if (i32.ne (local.get $res) (i32.const 0))
        (then
          (local.set $j (i32.add (local.get $j) (i32.const 1)))
          (br_if $vowelloop (i32.ne (local.get $j) (i32.const 7)))
        ))
      )
      (if (i32.eq (local.get $res) (i32.const 0))
      (then
        (local.set $slen (call $getlen (i32.add (local.get $inputOffset) (local.get $i)) (local.get $inputLength)))
        (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $i)) (local.get $slen))
        (local.set $dest (i32.add (local.get $dest) (local.get $slen)))
        (local.set $i (i32.add (local.get $i) (local.get $slen)))
        (local.set $flag (i32.const 1))
      ))
      ;; rule 3
      (local.set $j (local.get $i))
      (loop $consloop 
        (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $j))))
        (local.set $k (i32.const 0))
        (loop $consinnerloop
          (local.set $char2 (i32.load8_u (i32.add (i32.const 30) (local.get $k))))
          (if (i32.and (i32.ne (local.get $k) (i32.const 20)) (i32.ne (local.get $char) (local.get $char2)))
          (then
            (local.set $k (i32.add (local.get $k) (i32.const 1)))
            (br $consinnerloop)
          ))
        )
        (local.set $j (i32.add (local.get $j) (i32.const 1)))
        (br_if $consloop (i32.eq (local.get $char) (local.get $char2)))
      )
      (local.set $j (i32.sub (local.get $j) (i32.const 1)))
      (if (i32.and (i32.eq (local.get $flag) (i32.const 0)) (i32.ne (local.get $i) (local.get $j)))
      (then
        (local.set $char (i32.load8_u (i32.sub(i32.add (local.get $inputOffset) (local.get $j)) (i32.const 1))))
        (local.set $char2 (i32.load8_u (i32.add (local.get $inputOffset) (local.get $j))))
        (if (i32.and (i32.eq (local.get $char) (i32.const 113)) (i32.eq (local.get $char2) (i32.const 117)))
        (then
          (local.set $slen (call $getlen (i32.add (local.get $inputOffset) (local.get $i)) (local.get $inputLength)))
          (local.set $j (i32.add (local.get $j) (i32.const 1)))
          (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $j)) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i))))
          (local.set $dest (i32.add (local.get $dest) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i)))))
          (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $i)) (i32.sub (local.get $j) (local.get $i)))
          (local.set $dest (i32.add (local.get $dest) (i32.sub (local.get $j) (local.get $i))))
          (local.set $i (i32.add (local.get $i) (local.get $slen)))
          (local.set $flag (i32.const 1))
        ))
      ))
      ;; rule 4
      (if (i32.and (i32.eq (local.get $flag) (i32.const 0)) (i32.ne (local.get $i) (local.get $j)))
      (then
        (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $j))))
        (if (i32.eq (local.get $char) (i32.const 121))
        (then
          (local.set $slen (call $getlen (i32.add (local.get $inputOffset) (local.get $i)) (local.get $inputLength)))
          (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $j)) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i))))
          (local.set $dest (i32.add (local.get $dest) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i)))))
          (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $i)) (i32.sub (local.get $j) (local.get $i)))
          (local.set $dest (i32.add (local.get $dest) (i32.sub (local.get $j) (local.get $i))))
          (local.set $i (i32.add (local.get $i) (local.get $slen)))
          (local.set $flag (i32.const 1))
        ))
      ))
      ;; rule 2
      (local.set $char (i32.load8_u (i32.add (local.get $inputOffset) (local.get $i))))
      (if (i32.eq (local.get $char) (i32.const 121))
      (then
        (local.set $j (i32.const 1))
      ))
      (if (i32.and (i32.eq (local.get $flag) (i32.const 0)) (i32.ne (local.get $i) (local.get $j)))
      (then
        (local.set $slen (call $getlen (i32.add (local.get $inputOffset) (local.get $i)) (local.get $inputLength)))
        (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $j)) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i))))
        (local.set $dest (i32.add (local.get $dest) (i32.sub(local.get $slen) (i32.sub (local.get $j) (local.get $i)))))
        (memory.copy (local.get $dest) (i32.add (local.get $inputOffset) (local.get $i)) (i32.sub (local.get $j) (local.get $i)))
        (local.set $dest (i32.add (local.get $dest) (i32.sub (local.get $j) (local.get $i))))
        (local.set $i (i32.add (local.get $i) (local.get $slen)))
        (local.set $flag (i32.const 1))
      ))
      (if (i32.eq (local.get $flag) (i32.const 1))
      (then
        (memory.copy (local.get $dest) (i32.const 55) (i32.const 2))
        (local.set $dest (i32.add (local.get $dest) (i32.const 2)))
      ))
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br_if $translateloop (i32.lt_s (local.get $i) (local.get $inputLength)))
    )
    (return (i32.const 512) (i32.sub (local.get $dest) (i32.const 512)))
  )
)