(module
  ;; attempt #1
  (func (export "isLeap") (param $year i32) (result i32)
    (local $4 i32)
    (local $100 i32)
    (local $400 i32)
    
    ;; set 4
    local.get $year
    i32.const 4
    i32.rem_s ;; $year / 4
    i32.const 0
    (local.set $4 (i32.eq)) ;; 1 or 0
    
    ;; set 100
    local.get $year
    i32.const 100
    i32.rem_s ;; $year / 100
    i32.const 0
    (local.set $100 (i32.ne)) ;; 1 or 0
    
    ;; set 400
    local.get $year
    i32.const 400
    i32.rem_s ;; $year / 400
    i32.const 0
    (local.set $400 (i32.eq)) ;; 1 or 0
    
    (i32.or 
      (i32.ne (local.get $100) (local.get $4)) 
      (i32.and (local.get $100)(i32.and (local.get $4) (local.get $400)))
      )
  ))