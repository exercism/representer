(module
  (memory (export "mem") 1)

  ;; Internal helper: Normalize hours and minutes into (0-23, 0-59)
  (func $normalize (param $h i32) (param $m i32) (result i32 i32)
    (local $total i32)
    ;; Calculate total minutes (could be negative)
    (local.set $total (i32.add (i32.mul (local.get $h) (i32.const 60)) (local.get $m)))
    
    ;; Handle negative modulo for a 24-hour day (1440 minutes)
    (local.set $total (i32.rem_s (local.get $total) (i32.const 1440)))
    (if (i32.lt_s (local.get $total) (i32.const 0))
      (then (local.set $total (i32.add (local.get $total) (i32.const 1440))))
    )
    
    (i32.div_s (local.get $total) (i32.const 60)) ;; Final Hour
    (i32.rem_s (local.get $total) (i32.const 60)) ;; Final Minute
  )

  (func (export "plus") (param $hour i32) (param $minute i32) (param $increase i32) (result i32 i32)
    (call $normalize (local.get $hour) (i32.add (local.get $minute) (local.get $increase)))
  )

  (func (export "minus") (param $hour i32) (param $minute i32) (param $decrease i32) (result i32 i32)
    (call $normalize (local.get $hour) (i32.sub (local.get $minute) (local.get $decrease)))
  )

  (func (export "equals") (param $hA i32) (param $mA i32) (param $hB i32) (param $mB i32) (result i32)
    (local $normHA i32) (local $normMA i32)
    (local $normHB i32) (local $normMB i32)
    
    ;; Normalize both times before comparing
    (call $normalize (local.get $hA) (local.get $mA))
    (local.set $normMA) (local.set $normHA)
    (call $normalize (local.get $hB) (local.get $mB))
    (local.set $normMB) (local.set $normHB)

    (i32.and 
      (i32.eq (local.get $normHA) (local.get $normHB))
      (i32.eq (local.get $normMA) (local.get $normMB))
    )
  )

  (func (export "toString") (param $hour i32) (param $minute i32) (result i32 i32)
    (local $h i32) (local $m i32)
    
    ;; Ensure we format the normalized time
    (call $normalize (local.get $hour) (local.get $minute))
    (local.set $m) (local.set $h)

    ;; Hour Tens and Units
    (i32.store8 (i32.const 0) (i32.add (i32.div_u (local.get $h) (i32.const 10)) (i32.const 48)))
    (i32.store8 (i32.const 1) (i32.add (i32.rem_u (local.get $h) (i32.const 10)) (i32.const 48)))
    
    ;; Separator ":"
    (i32.store8 (i32.const 2) (i32.const 58))
    
    ;; Minute Tens and Units
    (i32.store8 (i32.const 3) (i32.add (i32.rem_u (local.get $m) (i32.const 10)) (i32.const 48)))
    (i32.store8 (i32.const 4) (i32.add (i32.rem_u (local.get $m) (i32.const 10)) (i32.const 48)))

    (i32.const 0) (i32.const 5)
  )
)
