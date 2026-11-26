CLASS zcl_beer_song DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS recite
      IMPORTING
        !initial_bottles_count TYPE i
        !take_down_count       TYPE i
      RETURNING
        VALUE(result)          TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_beer_song IMPLEMENTATION.

  METHOD recite.
    DATA(bottles_count) = initial_bottles_count.
    DO take_down_count TIMES.
      IF lines( result ) GT 1.
        APPEND || TO result.
      ENDIF.
      APPEND SWITCH #( bottles_count
        WHEN 0 THEN |No more bottles of beer on the wall, no more bottles of beer.|
               ELSE |{ bottles_count } bottle{ COND #( WHEN bottles_count GT 1 THEN 's' ) } of beer on the wall, { bottles_count } bottle{ COND #( WHEN bottles_count GT 1 THEN 's' ) } of beer.|
                                           ) TO result.
      SUBTRACT 1 FROM bottles_count.
      IF bottles_count LT 0.
        bottles_count = 99.
        APPEND |Go to the store and buy some more, 99 bottles of beer on the wall.| TO result.
      ELSE.
        APPEND |Take { COND #( WHEN bottles_count EQ 0 THEN |it| ELSE |one| ) } down and pass it around, { SWITCH #( bottles_count WHEN 0 THEN |no more bottles| WHEN 1 THEN |1 bottle| ELSE |{ bottles_count } bottles| ) } of beer on the wall.| TO result.
      ENDIF.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
