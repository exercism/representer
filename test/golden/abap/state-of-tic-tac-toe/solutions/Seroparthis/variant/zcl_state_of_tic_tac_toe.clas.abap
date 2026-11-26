CLASS zcl_state_of_tic_tac_toe DEFINITION.

  PUBLIC SECTION.

    TYPES player_type TYPE c LENGTH 1.
    "! E.g., ( ( `XOO` ) ( ` X ` ) ( `  X` ) )
    TYPES board_type TYPE TABLE OF string INITIAL SIZE 3.

    CONSTANTS: BEGIN OF player_enum,
                 one TYPE player_type VALUE 'X',
                 two TYPE player_type VALUE 'O',
               END OF player_enum.

    CONSTANTS: BEGIN OF state_enum,
                 ongoing_game TYPE string VALUE `Ongoing game`,
                 draw         TYPE string VALUE `Draw`,
                 win          TYPE string VALUE `Win`,
               END OF state_enum.

    "! @parameter state | Possible values are enumerated in state_enum
    "! @raising cx_parameter_invalid | Board is invalid
    METHODS get_state
      IMPORTING board        TYPE board_type
      RETURNING VALUE(state) TYPE string
      RAISING   cx_parameter_invalid.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_state_of_tic_tac_toe IMPLEMENTATION.

  METHOD get_state.
    DATA(string1) = board[ 1 ].
    DATA(string2) = board[ 2 ].
    DATA(string3) = board[ 3 ].
    DATA: counter_X TYPE i VALUE 0,
          counter_O TYPE i VALUE 0,
          counter TYPE i VALUE 0.

    "Check first string for 'X' and 'O' and count how many of them are set yet."
    DO 3 TIMES.
        IF string1+counter(1) = 'X'.
            counter_X = counter_X + 1.
        ELSEIF string1+counter(1) = 'O'.
            counter_O = counter_O + 1.
        ENDIF.
        counter = counter + 1.
    ENDDO.

    "Repeat for second string"
    counter = 0.
    DO 3 TIMES.
        IF string2+counter(1) = 'X'.
            counter_X = counter_X + 1.
        ELSEIF string2+counter(1) = 'O'.
            counter_O = counter_O + 1.
        ENDIF.
        counter = counter + 1.
    ENDDO.

    "And third string"
    counter = 0.
    DO 3 TIMES.
        IF string3+counter(1) = 'X'.
            counter_X = counter_X + 1.
        ELSEIF string3+counter(1) = 'O'.
            counter_O = counter_O + 1.
        ENDIF.
        counter = counter + 1.
    ENDDO.

    "If the count of 'O' is higher then the input is invalid, as 'X' starts the game. When 'X' counter is at least twice higher than 'O' counter, then it's invalid aswell, as 'X' has been set twice in one round. Therefore raise exception."
    IF counter_O > counter_X OR counter_X - 1 > counter_O.
        RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.

    "If statement for checking if there are two winners, meaning that the game continued, after one of the players already won. Raise exception if true."
    IF (    ( string1+0(1) = 'X' AND string1+1(1) = 'X' AND string1+2(1) = 'X' )
      OR    ( string2+0(1) = 'X' AND string2+1(1) = 'X' AND string2+2(1) = 'X' )
      OR    ( string3+0(1) = 'X' AND string3+1(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string1+0(1) = 'X' AND string2+0(1) = 'X' AND string3+0(1) = 'X' )
      OR    ( string1+1(1) = 'X' AND string2+1(1) = 'X' AND string3+1(1) = 'X' )
      OR    ( string1+2(1) = 'X' AND string2+2(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string1+0(1) = 'X' AND string2+1(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string3+0(1) = 'X' AND string2+1(1) = 'X' AND string1+2(1) = 'X' ) ) AND
          ( ( string1+0(1) = 'O' AND string1+1(1) = 'O' AND string1+2(1) = 'O' )
      OR    ( string2+0(1) = 'O' AND string2+1(1) = 'O' AND string2+2(1) = 'O' )
      OR    ( string3+0(1) = 'O' AND string3+1(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string1+0(1) = 'O' AND string2+0(1) = 'O' AND string3+0(1) = 'O' )
      OR    ( string1+1(1) = 'O' AND string2+1(1) = 'O' AND string3+1(1) = 'O' )
      OR    ( string1+2(1) = 'O' AND string2+2(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string1+0(1) = 'O' AND string2+1(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string3+0(1) = 'O' AND string2+1(1) = 'O' AND string1+2(1) = 'O' ) ).
        RAISE EXCEPTION TYPE cx_parameter_invalid.
    ENDIF.
    
    "After checking for invalid input, check for winner."
    IF    ( ( string1+0(1) = 'X' AND string1+1(1) = 'X' AND string1-2(1) = 'X' )
      OR    ( string2+0(1) = 'X' AND string2+1(1) = 'X' AND string2+2(1) = 'X' )
      OR    ( string3+0(1) = 'X' AND string3+1(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string1+0(1) = 'X' AND string2+0(1) = 'X' AND string3+0(1) = 'X' )
      OR    ( string1+1(1) = 'X' AND string2+1(1) = 'X' AND string3+1(1) = 'X' )
      OR    ( string1+2(1) = 'X' AND string2+2(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string1+0(1) = 'X' AND string2+1(1) = 'X' AND string3+2(1) = 'X' )
      OR    ( string3+0(1) = 'X' AND string2+1(1) = 'X' AND string1+2(1) = 'X' ) ) OR
          ( ( string1+0(1) = 'O' AND string1+1(1) = 'O' AND string1+2(1) = 'O' )
      OR    ( string2+0(1) = 'O' AND string2+1(1) = 'O' AND string2+2(1) = 'O' )
      OR    ( string3+0(1) = 'O' AND string3+1(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string1+0(1) = 'O' AND string2+0(1) = 'O' AND string3+0(1) = 'O' )
      OR    ( string1+1(1) = 'O' AND string2+1(1) = 'O' AND string3+1(1) = 'O' )
      OR    ( string1+2(1) = 'O' AND string2+2(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string1+0(1) = 'O' AND string2+1(1) = 'O' AND string3+2(1) = 'O' )
      OR    ( string3+0(1) = 'O' AND string2+1(1) = 'O' AND string1+2(1) = 'O' ) ).
      state = 'Win'.
    "If there is no winner, check if all fields are occupied. If true, it's a draw."
    ELSEIF   string1+0(1) <> | |  AND  string1+1(1) <> | |  AND  string1+2(1) <> | |  AND
             string2+0(1) <> | |  AND  string2+1(1) <> | |  AND  string2+2(1) <> | |  AND
             string3+0(1) <> | |  AND  string3+1(1) <> | |  AND  string3+2(1) <> | | .
      state = 'Draw'.
    "If none of the scenarios above have been triggered it has to be an ongoing game."
    ELSE.
      state = 'Ongoing game'.
    ENDIF.

  ENDMETHOD.

ENDCLASS.