(module
  ;;
  ;; Score a yacht game of ones
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "ones")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 1))
  )

  ;;
  ;; Score a yacht game of twos
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "twos")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 2))
  )

  ;;
  ;; Score a yacht game of threes
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "threes")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 3))
  )

  ;;
  ;; Score a yacht game of fours
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "fours")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 4))
  )

  ;;
  ;; Score a yacht game of fives
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "fives")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 5))
  )

  ;;
  ;; Score a yacht game of sixes
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "sixes") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (call $scoreFace
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE) (i32.const 6))
  )

  ;;
  ;; Score a yacht game of full house
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "full house")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (local $max_count_1 i32) (local $max_face_1 i32)
    (local $max_count_2 i32) (local $max_face_2 i32)
    (call $countFaces
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE))
    (local.set $max_count_2 (; from stack ;))
    (local.set $max_face_2 (; from stack ;))
    (local.set $max_count_1 (; from stack ;))
    (local.set $max_face_1 (; from stack ;))

    (if (i32.and
      (i32.eq (local.get $max_count_1) (i32.const 3))
      (i32.eq (local.get $max_count_2) (i32.const 2)))
      (then (return (i32.add
        (i32.mul (local.get $max_face_1) (local.get $max_count_1))
        (i32.mul (local.get $max_face_2) (local.get $max_count_2))))
    ))
    (i32.const 0)
  )

  ;;
  ;; Score a yacht game of four of a kind
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "four of a kind")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (local $max_count i32) (local $max_face i32)
    (call $countFaces
      (local.get $diceA) (local.get $diceB) (local.get $diceC)
      (local.get $diceD) (local.get $diceE))
    (drop) (drop)
    (local.set $max_count (; from stack ;))
    (local.set $max_face (; from stack ;))
    (if (i32.ge_s (local.get $max_count) (i32.const 4))
      (then (return (i32.mul (local.get $max_face) (i32.const 4)))))
    (i32.const 0)
  )

  ;;
  ;; Score a yacht game of little straight
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "little straight")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 30) (i32.const 0) (i32.eq
      (i32.or (i32.or (i32.or (i32.or
        (i32.shl (i32.const 1) (local.get $diceA))
        (i32.shl (i32.const 1) (local.get $diceB)))
        (i32.shl (i32.const 1) (local.get $diceC)))
        (i32.shl (i32.const 1) (local.get $diceD)))
        (i32.shl (i32.const 1) (local.get $diceE)))
      (i32.const 0x3e)))
  )

  ;;
  ;; Score a yacht game of big straight
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "big straight") (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 30) (i32.const 0) (i32.eq
      (i32.or (i32.or (i32.or (i32.or
        (i32.shl (i32.const 1) (local.get $diceA))
        (i32.shl (i32.const 1) (local.get $diceB)))
        (i32.shl (i32.const 1) (local.get $diceC)))
        (i32.shl (i32.const 1) (local.get $diceD)))
        (i32.shl (i32.const 1) (local.get $diceE)))
      (i32.const 0x7c)))
  )

  ;;
  ;; Score a yacht game of choice
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "choice")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (i32.add (i32.add (i32.add (i32.add
      (local.get $diceA)
      (local.get $diceB))
      (local.get $diceC))
      (local.get $diceD))
      (local.get $diceE))
  )

  ;;
  ;; Score a yacht game of yacht
  ;;
  ;; @param {i32} $diceA - face of first dice
  ;; @param {i32} $diceB - face of second dice
  ;; @param {i32} $diceC - face of third dice
  ;; @param {i32} $diceD - face of fourth dice
  ;; @param {i32} $diceE - face of fifth dice
  ;;
  ;; @returns {i32} - score
  ;;
  (func (export "yacht")
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32)
    (select (i32.const 50) (i32.const 0) (i32.and (i32.and (i32.and
      (i32.eq (local.get $diceA) (local.get $diceB))
      (i32.eq (local.get $diceB) (local.get $diceC)))
      (i32.eq (local.get $diceC) (local.get $diceD)))
      (i32.eq (local.get $diceD) (local.get $diceE))))
  )

  ;; multiply the number of dice showing the `face` with that `face`
  (func $scoreFace
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (param $face i32)
    (result i32)
    (i32.mul (local.get $face) (i32.add (i32.add (i32.mul (i32.add
      (i32.eq (local.get $diceA) (local.get $face))
      (i32.eq (local.get $diceB) (local.get $face)))
      (i32.eq (local.get $diceC) (local.get $face)))
      (i32.eq (local.get $diceD) (local.get $face)))
      (i32.eq (local.get $diceE) (local.get $face))))
  )

  ;; Determine the two faces (and their counts) that occur most often.
  ;; Order by count and face value.
  ;;
  ;; @returns {(i32, i32, i32, i32)} -
  ;;     face that appears most often and its count,
  ;;     face that appears second most often and its count
  ;;
  ;;
  (func $countFaces
    (param $diceA i32) (param $diceB i32) (param $diceC i32)
    (param $diceD i32) (param $diceE i32) (result i32 i32 i32 i32)
    (local $bits64 i64)
    (local $face i32)
    (local $count i32)
    (local $max_count_1 i32)
    (local $max_face_1 i32)
    (local $max_count_2 i32)
    (local $max_face_2 i32)

    ;; count faces by treating `bits64` as separate nibbles
    (local.set $bits64 (call $inc_nibble
      (local.get $bits64) (i32.sub (local.get $diceA) (i32.const 1))))
    (local.set $bits64 (call $inc_nibble
      (local.get $bits64) (i32.sub (local.get $diceB) (i32.const 1))))
    (local.set $bits64 (call $inc_nibble
      (local.get $bits64) (i32.sub (local.get $diceC) (i32.const 1))))
    (local.set $bits64 (call $inc_nibble
      (local.get $bits64) (i32.sub (local.get $diceD) (i32.const 1))))
    (local.set $bits64 (call $inc_nibble
      (local.get $bits64) (i32.sub (local.get $diceE) (i32.const 1))))

    ;; find the two maximal counts (there can be at most 2 counts >= 2)
    (local.set $face (i32.const 6))
    (block $loop_end (loop $loop
      (local.set $count (call $get_nibble
        (local.get $bits64) (i32.sub (local.get $face) (i32.const 1))))
      (if (i32.gt_s (local.get $count) (local.get $max_count_1))
        (then
          (local.set $max_count_2 (local.get $max_count_1))
          (local.set $max_face_2 (local.get $max_face_1))
          (local.set $max_count_1 (local.get $count))
          (local.set $max_face_1 (local.get $face))
        )
        (else (if (i32.gt_s (local.get $count) (local.get $max_count_2))
          (then
            (local.set $max_count_2 (local.get $count))
            (local.set $max_face_2 (local.get $face))
        ))
      ))
      (local.set $face (i32.sub (local.get $face) (i32.const 1)))
      (br_if $loop (local.get $face))
    ))

    (return
      (local.get $max_face_1) (local.get $max_count_1)
      (local.get $max_face_2) (local.get $max_count_2))
  )

  ;; Get the idx-th nibble.
  (func $get_nibble
    (param $bits64 i64) (param $idx i32) (result i32)
    (local $shift i64)
    (local.set $shift (i64.extend_i32_u (i32.mul (local.get $idx) (i32.const 4))))
    (i32.and (i32.const 0xF) (i32.wrap_i64
      (i64.shr_u (local.get $bits64) (local.get $shift))))
  )

  ;; Increment the idx-th nibble.
  ;; Beware: overflows affect the other nibbles
  (func $inc_nibble
    (param $bits64 i64) (param $idx i32) (result i64)
    (local $shift i64)
    (local.set $shift (i64.extend_i32_u (i32.mul (local.get $idx) (i32.const 4))))
    (local.set $bits64 (i64.rotr (local.get $bits64) (local.get $shift)))
    (local.set $bits64 (i64.add (local.get $bits64) (i64.const 1)))
    (local.set $bits64 (i64.rotl (local.get $bits64) (local.get $shift)))
    (return (local.get $bits64))
  )
)
