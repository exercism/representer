(module
  (global $accountState (mut i32) (i32.const 0)) ;; close:0, open:1
  (global $balance (mut i32) (i32.const 0))
  
  ;; returns 0 on success, -1 on failure
  (func (export "open") (result i32)
    (if ;; account closed
      (call $isClosed)
      (then
        (i32.const 1)
        (global.set $accountState)
        (return (i32.const 0))))

    (return (i32.const -1))
  )

  ;; returns 0 on success, -1 on failure
  (func (export "close") (result i32)
    (if ;; account already closed
      (call $isClosed)
      (then
        (return (i32.const -1))))

    (global.set $balance (i32.const 0)) ;; reset balance
    (global.set $accountState (i32.const 0)) ;; close account
    (i32.const 0)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount negative
  (func (export "deposit") (param $amount i32) (result i32)
    (if ;; account closed
      (call $isClosed)
      (then
        (return (i32.const -1))))

    (call $isNegative (local.get $amount))
    (if ;; amount negative
      (then
        (return (i32.const -2))))

    (i32.add ;; add amount to balance
      (local.get $amount)
      (global.get $balance))
    (global.set $balance)
    
    (i32.const 0)
  )

  ;; returns 0 on success, -1 if account closed, -2 if amount invalid
  (func (export "withdraw") (param $amount i32) (result i32)
    (if ;; account closed
      (call $isClosed)
      (then
        (return (i32.const -1))))

    (i32.or
      (call $isNegative (local.get $amount))
      (i32.lt_s
        (global.get $balance)
        (local.get $amount)))
    (if ;; invalid amount
      (then
        (return (i32.const -2))))

    (i32.sub ;; substract amount to balance
      (global.get $balance)
      (local.get $amount))
    (global.set $balance)
    
    (i32.const 0)
  )

  ;; returns balance on success, -1 if account closed
  (func (export "balance") (result i32)
    (if
      (call $isClosed)
      (then
        (return (i32.const -1))))

    (return (global.get $balance))
  )

  ;; is account closed
  (func $isClosed (result i32)
    global.get $accountState
    i32.const 0
    i32.eq
  )

  ;; is amount negative
  (func $isNegative (param i32) (result i32)
    (i32.lt_s
      (local.get 0)
      (i32.const 0))
  )
)