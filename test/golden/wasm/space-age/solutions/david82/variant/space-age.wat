(module
  (global (export "mercury") i32 (i32.const 0))
  (global (export "venus") i32 (i32.const 1))
  (global (export "earth") i32 (i32.const 2))
  (global (export "mars") i32 (i32.const 3))
  (global (export "jupiter") i32 (i32.const 4))
  (global (export "saturn") i32 (i32.const 5))
  (global (export "uranus") i32 (i32.const 6))
  (global (export "neptune") i32 (i32.const 7))

  ;; Constants for orbital periods in Earth years
  (global $mercury_period f64 (f64.const 0.2408467))
  (global $venus_period f64 (f64.const 0.61519726))
  (global $earth_period f64 (f64.const 1.0))
  (global $mars_period f64 (f64.const 1.8808158))
  (global $jupiter_period f64 (f64.const 11.862615))
  (global $saturn_period f64 (f64.const 29.447498))
  (global $uranus_period f64 (f64.const 84.016846))
  (global $neptune_period f64 (f64.const 164.79132))

  ;; Earth year in seconds
  (global $earth_year_seconds f64 (f64.const 31557600.0))

  ;; Helper function to round to 2 decimal places
  (func $round_to_2_decimals (param $value f64) (result f64)
    (local $multiplier f64)
    (local $rounded f64)
    
    ;; Multiply by 100 to shift decimal point right by 2 places
    (local.set $multiplier (f64.const 100.0))
    (local.set $rounded 
      (f64.mul 
        (local.get $value)
        (local.get $multiplier)
      )
    )
    
    ;; Round to nearest integer
    (local.set $rounded (f64.nearest (local.get $rounded)))
    
    ;; Divide by 100 to shift decimal point back
    (f64.div 
      (local.get $rounded)
      (local.get $multiplier)
    )
  )

  ;;
  ;; calculates the age in planetary years based on planet and number of seconds
  ;;
  ;; @param {i32} $planet - 0-7, see exported planets
  ;; @param {i32} $seconds - number of seconds
  ;;
  ;; @result {f64} age in years on the planet
  ;;
  (func (export "age") (param $planet i32) (param $seconds i32) (result f64)
    (local $earth_years f64)
    (local $orbital_period f64)
    (local $result f64)
    
    ;; Convert seconds to Earth years
    (local.set $earth_years 
      (f64.div 
        (f64.convert_i32_s (local.get $seconds))
        (global.get $earth_year_seconds)
      )
    )
    
    ;; Get orbital period based on planet
    (local.set $orbital_period
      (block $get_period (result f64)
        (block $mercury
          (br_if $mercury (i32.ne (local.get $planet) (i32.const 0)))
          (br $get_period (global.get $mercury_period))
        )
        (block $venus
          (br_if $venus (i32.eq (local.get $planet) (i32.const 1)))
          (br $get_period (global.get $venus_period))
        )
        (block $earth
          (br_if $earth (i32.ne (local.get $planet) (i32.const 2)))
          (br $get_period (global.get $earth_period))
        )
        (block $mars
          (br_if $mars (i32.ne (local.get $planet) (i32.const 3)))
          (br $get_period (global.get $mars_period))
        )
        (block $jupiter
          (br_if $jupiter (i32.ne (local.get $planet) (i32.const 4)))
          (br $get_period (global.get $jupiter_period))
        )
        (block $saturn
          (br_if $saturn (i32.ne (local.get $planet) (i32.const 5)))
          (br $get_period (global.get $saturn_period))
        )
        (block $uranus
          (br_if $uranus (i32.ne (local.get $planet) (i32.const 6)))
          (br $get_period (global.get $uranus_period))
        )
        (block $neptune
          (br_if $neptune (i32.ne (local.get $planet) (i32.const 7)))
          (br $get_period (global.get $neptune_period))
        )
        (f64.const 1.0) ;; Default to Earth period if invalid planet
      )
    )
    
    ;; Calculate age on the planet
    (local.set $result 
      (f64.div (local.get $earth_years) (local.get $orbital_period))
    )
    
    ;; Round to 2 decimal places
    (call $round_to_2_decimals (local.get $result))
  )
)
