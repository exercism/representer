(module
  (memory (export "mem") 1)

  ;;
  ;; add minutes to a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $increase - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func $plus (export "plus") (param $hour i32) (param $minute i32) (param $increase i32) (result i32 i32)
    (local $t i32)
    (call $unify (local.get $hour) (local.get $minute) (local.get $increase))
    (i32.div_u (local.tee $t) (i32.const 60))
    (i32.rem_u (local.get $t) (i32.const 60)))

  ;;
  ;; remove minutes from a clock's time
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;; @param {i32} $decrease - the minutes to add
  ;;
  ;; @returns {(i32,i32)} - the hours and minutes shown on the clock
  ;;
  (func (export "minus") (param $hour i32) (param $minute i32) (param $decrease i32) (result i32 i32)
    (call $plus
      (local.get $hour)
      (local.get $minute)
      (i32.sub
        (i32.const 0)
        (call $modd (local.get $decrease)))))

  ;;
  ;; formats the clock as "HH:MM" string
  ;;
  ;; @param {i32} $hour - the hours on the clock
  ;; @param {i32} $minute - the minutes on the clock
  ;;
  ;; @returns {(i32,i32)} - the offset and length of the output string in linear memory
  ;;
  (func (export "toString") (param $hour i32) (param $minute i32) (result i32 i32)
    (local $h i32)
    (local $m i32)

    (call $plus (local.get $hour) (local.get $minute) (i32.const 0))
    local.set $m
    local.set $h

    i32.const 0 ;; mem[0]
    local.get $h
      (i32.div_u (i32.const 10))
      (i32.add (i32.const 48)) ;; -> digit char
    i32.store8

    i32.const 1 ;; mem[1]
    local.get $h
      (i32.rem_u (i32.const 10))
      (i32.add (i32.const 48)) ;; -> digit char
    i32.store8

    (i32.store8 (i32.const 2) (i32.const 58)) ;; mem[2] = ':'

    i32.const 3 ;; mem[3]
    local.get $m
      (i32.div_u (i32.const 10))
      (i32.add (i32.const 48)) ;; -> digit char
    i32.store8

    i32.const 4 ;; mem[4]
    local.get $m
      (i32.rem_u (i32.const 10))
      (i32.add (i32.const 48)) ;; -> digit char
    i32.store8

    (i32.const 0) (i32.const 5))

  ;;
  ;; checks if two clocks show the same time
  ;;
  ;; @param {i32} $hourA - the hours on the first clock
  ;; @param {i32} $minuteA - the minutes on the first clock
  ;; @param {i32} $hourB - the hours on the second clock
  ;; @param {i32} $minuteB - the minutes on the second clock
  ;;
  ;; @returns {i32} - 1 if they are equal, 0 if not
  ;;
  (func (export "equals") (param $hourA i32) (param $minuteA i32)
    (param $hourB i32) (param $minuteB i32) (result i32)
    (call $unify (local.get $hourA) (local.get $minuteA) (i32.const 0))
    (call $unify (local.get $hourB) (local.get $minuteB) (i32.const 0))
    i32.eq)

  (func $unify (param $h i32) (param $m1 i32) (param $m2 i32) (result i32)
    (call $modd (local.get $h))
    (i32.mul (i32.const 60))
    (i32.add (call $modd (local.get $m1)))
    (i32.add (call $modd (local.get $m2)))
    call $modd)

  (func $modd (param $x i32) (result i32)
    (local $t i32)
    (local.tee $t (i32.rem_s (local.get $x) (i32.const 1440))) ;; 1440m = 60m * 24
    (i32.add (i32.const 1440)) ;; <- selected if $t < 0
    local.get $t ;; <- else
    (select (i32.lt_s (local.get $t) (i32.const 0)))))
