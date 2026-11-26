CLASS zcl_clock DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !hours   TYPE i
        !minutes TYPE i DEFAULT 0.
    METHODS get
      RETURNING
        VALUE(result) TYPE string.
    METHODS add
      IMPORTING
        !minutes TYPE i.
    METHODS sub
      IMPORTING
        !minutes TYPE i.

  PRIVATE SECTION.

* add solution here
  DATA:
        hours   TYPE I,
        minutes TYPE I.
ENDCLASS.



CLASS zcl_clock IMPLEMENTATION.

  METHOD add.
    DATA: 
          new_minutes     TYPE I,
          additional_hour TYPE I VALUE 0.
    new_minutes = me->minutes.
    new_minutes = new_minutes + minutes.
    additional_hour = floor( new_minutes / 60).
    new_minutes = new_minutes MOD 60.
    me->hours = me->hours + additional_hour.
    me->hours = me->hours MOD 24.
    me->minutes = new_minutes.
  ENDMETHOD.


  METHOD constructor.
    DATA: 
          additional_hour TYPE I VALUE 0,
          new_minutes     TYPE I VALUE 0.
    additional_hour = floor( minutes / 60 ).
    new_minutes = minutes MOD 60.
    me->hours = ( hours + additional_hour ) MOD 24.
    me->minutes = new_minutes.
  ENDMETHOD.


  METHOD get.
    DATA:
          str_hours       TYPE string,
          str_minutes     TYPE string.
    str_hours = hours.
    str_minutes = minutes.
    CONDENSE str_hours.
    CONDENSE str_minutes.
    IF strlen( str_hours ) < 2.
      str_hours = '0' && str_hours.
    ENDIF.
    IF strlen( str_minutes ) < 2.
      str_minutes = '0' && str_minutes.
    ENDIF.
    CONCATENATE str_hours str_minutes INTO result SEPARATED BY ':'.
  ENDMETHOD.


  METHOD sub.
    DATA:
          new_minutes     TYPE I,
          additional_hour TYPE I VALUE 0,
          hours_to_sub    TYPE I VALUE 0,
          days_to_sub     TYPE I VALUE 0.
    me->minutes = me->minutes - minutes.
    IF me->minutes < 0.
      hours_to_sub = ceil( me->minutes / -60 ).
    ENDIF.
    me->minutes = ( me->minutes + 60 * hours_to_sub ) MOD 60.
    me->hours = me->hours - hours_to_sub.
    IF me->hours < 0.
      days_to_sub = ceil( me->hours / -24 ).
    ENDIF.
    me->hours = ( me->hours + 24 * days_to_sub ) MOD 24.
  ENDMETHOD.
ENDCLASS.
