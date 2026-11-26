(module
  (memory (export "mem") 1)
 
  ;; status codes
  (global $ok i32 (i32.const 0))
  (global $negativeRoll i32 (i32.const -1))
  (global $exceedingPinCount i32 (i32.const -2))
  (global $rollAfterEnd i32 (i32.const -3))
  (global $prematureScoring i32 (i32.const -4))

  (global $curturn (mut i32) (i32.const 0))
  (global $flag1 (mut i32) (i32.const 0))
  (global $flag2 (mut i32) (i32.const 0))
  (global $scores (mut i32) (i32.const 0))
  (global $lastroll (mut i32) (i32.const -1))
  ;;
  ;; Collect a roll
  ;;
  ;; @param {i32} points - the points scored by a single roll
  ;;
  ;; @result {i32} - status code (see globals)
  ;;
  (func (export "roll") (param $points i32) (result i32)
    (local $flagset i32)
    (if (i32.lt_s (local.get $points) (i32.const 0))
    (then
      (return (global.get $negativeRoll))
    ))
    (if (i32.gt_s (local.get $points) (i32.const 10))
    (then
      (return (global.get $exceedingPinCount))
    ))
    (if (i32.lt_s (global.get $curturn) (i32.const 10))
    (then
      (if (i32.gt_s (global.get $flag1) (i32.const 0))
      (then
        (global.set $scores (i32.add(global.get $scores) (i32.mul (local.get $points) (global.get $flag1))))
        (global.set $flag1 (i32.const 0))
      ))
      (if (i32.gt_s (global.get $flag2) (i32.const 0))
      (then
        (global.set $flag1 (global.get $flag2))
        (global.set $flag2 (i32.const 0))
      ))
      (if (i32.eq(local.get $points) (i32.const 10))
      (then
        (global.set $scores (i32.mul(global.get $scores) (i32.const 10)))
        (global.set $lastroll (i32.const -1))
        (global.set $flag1 (i32.add (global.get $flag1) (i32.const 1)))
        (global.set $flag2 (i32.add (global.get $flag2) (i32.const 1)))
        (global.set $curturn (i32.add (global.get $curturn) (i32.const 1)))
      ) 
      (else
        (if (i32.eq (global.get $lastroll) (i32.const -1))
        (then
          (global.set $scores (i32.add(global.get $scores) (local.get $points)))
          (global.set $lastroll (local.get $points))
        ) 
        (else
          (if (i32.eq (i32.add(global.get $lastroll) (local.get $points)) (i32.const 10))
          (then
            (global.set $flag1 (i32.add (global.get $flag1) (i32.const 1)))
          ))
          (if (i32.gt_s (i32.add(global.get $lastroll) (local.get $points)) (i32.const 10))
          (then
            (return (global.get $exceedingPinCount))
          ))
          (global.set $scores (i32.add(global.get $scores) (local.get $points)))
          (global.set $lastroll (i32.const -1))
          (global.set $curturn (i32.add (global.get $curturn) (i32.const 1)))
        ))
      ))
    )
    (else
      (if (i32.gt_s (global.get $flag1) (i32.const 0))
      (then
        (if (i32.and (i32.ne (global.get $lastroll) (i32.const -1)) (i32.gt_s (i32.add (global.get $lastroll) (local.get $points)) (i32.const 10)))
        (then
          (return (global.get $exceedingPinCount))
        ))
        (global.set $scores (i32.add(global.get $scores) (i32.mul (local.get $points) (global.get $flag1))))
        (global.set $flag1 (i32.const 0))
        (local.set $flagset (i32.const 1))
        (if (i32.ne (local.get $points) (i32.const 10))
        (then
          (global.set $lastroll (local.get $points))
        )
        (else
          (global.set $lastroll (i32.const -1))
        ))
      ))
      (if (i32.gt_s (global.get $flag2) (i32.const 0))
      (then
        (global.set $flag1 (global.get $flag2))
        (global.set $flag2 (i32.const 0))
        (local.set $flagset (i32.const 1))
      ))
      (if (i32.eq (local.get $flagset) (i32.const 0))
      (then
        (return (global.get $rollAfterEnd))
      ))
    ))
    (return (global.get $ok))
  )

  ;;
  ;; Score the game
  ;;
  ;; @result {i32} - points or status code (see globals)
  ;;
  (func (export "score") (result i32)
    (if (i32.and (i32.and (i32.eq (global.get $curturn) (i32.const 10)) (i32.eq (global.get $flag1) (i32.const 0))) (i32.eq (global.get $flag2) (i32.const 0)))
    (then
      (return (global.get $scores))
    ))
    (return (global.get $prematureScoring))
  )
)