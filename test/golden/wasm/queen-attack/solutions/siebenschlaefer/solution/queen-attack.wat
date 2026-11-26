(module
  (memory (export "mem") 1)
  (global $invalid_position i32 (i32.const -1))
  (global $cannot_attack i32 (i32.const 0))
  (global $can_attack i32 (i32.const 1))
  (global $board_offset i32 (i32.const 0))
  (global $board_length i32 (i32.const 128))
  (global $ascii_new_line i32 (i32.const 0x0A))
  (global $ascii_space i32 (i32.const 0x20))
  (global $ascii_underscore i32 (i32.const 0x5F))
  (global $ascii_uppercase_b i32 (i32.const 0x42))
  (global $ascii_uppercase_w i32 (i32.const 0x57))

  ;;
  ;; Checks a queen positioning for validity and the ability to attack
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {i32} -1 if invalid, 0 if cannot attack, 1 if it can attack
  ;;
  (func $can_attack (export "canAttack") (param $positions i32) (result i32)
    (local $white_file i32)
    (local $white_rank i32)
    (local $black_file i32)
    (local $black_rank i32)
    (local $dist_files i32)
    (local $dist_ranks i32)

    ;; extract the 8-bit files and ranks from the 32-bit parameter
    (call $unpack_positions (local.get $positions))
    (local.set $black_file (; pop from stack ;))
    (local.set $black_rank (; pop from stack ;))
    (local.set $white_file (; pop from stack ;))
    (local.set $white_rank (; pop from stack ;))

    ;; are both queens on the board?
    (if (i32.or
      (i32.eqz (call $valid_position (local.get $white_file) (local.get $white_rank)))
      (i32.eqz (call $valid_position (local.get $black_file) (local.get $black_rank))))
      (then (return (global.get $invalid_position))))

    ;; calculate the file- and rank-wise distance between the two queens
    (local.set $dist_files (call $abs
      (i32.sub (local.get $white_file) (local.get $black_file))))
    (local.set $dist_ranks (call $abs
      (i32.sub (local.get $white_rank) (local.get $black_rank))))

    ;; are the two queens on the same square?
    (if (i32.and
        (i32.eqz (local.get $dist_files))
        (i32.eqz (local.get $dist_ranks)))
      (then (return (global.get $invalid_position))))

    ;; are the two queens on the same rank or file or diagonal?
    (if (i32.or (i32.or
        (i32.eqz (local.get $dist_files))
        (i32.eqz (local.get $dist_ranks)))
        (i32.eq 
          (local.get $dist_files)
          (local.get $dist_ranks)))
      (then (return (global.get $can_attack))))

    (global.get $cannot_attack)
  )

  ;;
  ;; Prints the chess board to linear memory (or return empty string if invalid)
  ;;
  ;; @param {i32} $positions
  ;;   (4*8bit for white row, white column, black row, black column, each 0-7)
  ;;
  ;; @returns {(i32,i32)} offset and length of chess board string in memory
  ;;
  (func (export "printBoard") (param $positions i32) (result i32 i32)
    (local $offset i32)
    (local $rank i32)
    (local $file i32)
    (local $white_file i32)
    (local $white_rank i32)
    (local $black_file i32)
    (local $black_rank i32)

    ;; if the positions are invalid return an empty string
    (if (i32.eq (call $can_attack (local.get $positions)) (global.get $invalid_position))
      (then (return (i32.const 0) (i32.const 0))))

    ;; build the string representation of the empty board, char by char
    (local.set $offset (global.get $board_offset))
    (loop $loop_ranks
      (local.set $file (i32.const 0))
      (loop $loop_files
        (i32.store8 (local.get $offset) (global.get $ascii_underscore))
        (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
        (i32.store8 (local.get $offset) (global.get $ascii_space))
        (local.set $offset (i32.add (local.get $offset) (i32.const 1)))
  
        (local.set $file (i32.add (local.get $file) (i32.const 1)))
        (br_if $loop_files (i32.lt_s (local.get $file) (i32.const 8)))
      )
      (i32.store8 (i32.sub (local.get $offset) (i32.const 1)) (global.get $ascii_new_line))
      
      (local.set $rank (i32.add (local.get $rank) (i32.const 1)))
      (br_if $loop_ranks (i32.lt_s (local.get $rank) (i32.const 8)))
    )

    ;; place the symbols for the white and black queen
    (call $unpack_positions (local.get $positions))
    (local.set $black_file (; pop from stack ;))
    (local.set $black_rank (; pop from stack ;))
    (local.set $white_file (; pop from stack ;))
    (local.set $white_rank (; pop from stack ;))
    
    (local.set $offset (i32.add (global.get $board_offset) (i32.add
      (i32.mul (local.get $white_rank) (i32.const 16))
      (i32.mul (local.get $white_file) (i32.const 2)))))
    (i32.store8 (local.get $offset) (global.get $ascii_uppercase_w))
    (local.set $offset (i32.add (global.get $board_offset) (i32.add
      (i32.mul (local.get $black_rank) (i32.const 16))
      (i32.mul (local.get $black_file) (i32.const 2)))))
    (i32.store8 (local.get $offset) (global.get $ascii_uppercase_b))

    (return (global.get $board_offset) (global.get $board_length))
  )
  ;; Unpack the four bytes from the u32.
  (func $unpack_positions (param $positions i32) (result i32 i32 i32 i32)
    (i32.shr_u (local.get $positions) (i32.const 24))
    (i32.and (i32.shr_u (local.get $positions) (i32.const 16)) (i32.const 0xFF))
    (i32.and (i32.shr_u (local.get $positions) (i32.const 8)) (i32.const 0xFF))
    (i32.and (local.get $positions) (i32.const 0xFF))
  )
  ;; Test if the position ($file, $rank) is on the board.
  (func $valid_position (param $file i32) (param $rank i32) (result i32)
    (i32.and
      (i32.lt_u (local.get $file) (i32.const 8))
      (i32.lt_u (local.get $rank) (i32.const 8)))
  )
  ;; Calculate the absolute value.
  (func $abs (param $val i32) (result i32)
    (if (i32.ge_s (local.get $val) (i32.const 0))
      (then (return (local.get $val))))
    (i32.sub (i32.const 0) (local.get $val))
  )
)
