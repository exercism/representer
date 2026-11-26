(module
  (import "console" "log_mem_as_utf8" (func $log_utf8 (param $byteOffset i32) (param $length i32)))
  (import "console" "log_i32_s" (func $log_i32_s (param i32)))
  (import "console" "log_f32" (func $log_f32 (param f32)))
  (memory (export "mem") 1)
  (func $flog (param $v f32) (result f32)
    local.get $v
    local.get $v
    call $log_f32
  )
  (func $ilog (param $v i32) (result i32)
    local.get $v
    local.get $v
    call $log_i32_s
  )
  (func (export "score") (param $x f32) (param $y f32) (param $dist f32) (result i32)
    (f32.mul (local.get $x) (local.get $x))
    (f32.mul (local.get $y) (local.get $y))
    f32.add
    local.set $dist
    (block $f (result i32)
      ;; if $dist <= 1 return 10
      i32.const 10
      ;; push ($dist <= 1)
      (f32.le (local.get $dist) (f32.const 1))
      br_if $f
      drop ;; drop 10
      ;; if $dist <= 25 return 5
      i32.const 5
      (f32.le (local.get $dist) (f32.const 25))
      br_if $f
      drop ;; drop 5
      ;; return $dist <= 100
      (f32.le (local.get $dist) (f32.const 100))
    )
  )
)
