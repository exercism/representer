CLASS zcl_elyses_enchantments DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_stack TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    "! Get card at position
    METHODS get_item
      IMPORTING stack         TYPE ty_stack
                position      TYPE i
      RETURNING VALUE(result) TYPE i.

    "! Replace card at position
    METHODS set_item
      IMPORTING stack         TYPE ty_stack
                position      TYPE i
                replacement   TYPE i
      RETURNING VALUE(result) TYPE ty_stack.

    "Add card to stack
    METHODS insert_item_at_top
      IMPORTING stack         TYPE ty_stack
                new_card      TYPE i
      RETURNING VALUE(result) TYPE ty_stack.

    "! Remove card at position
    METHODS remove_item
      IMPORTING stack         TYPE ty_stack
                position      TYPE i
      RETURNING VALUE(result) TYPE ty_stack.

    "! Remove top card (last row)
    METHODS remove_item_from_top
      IMPORTING stack         TYPE ty_stack
      RETURNING VALUE(result) TYPE ty_stack.

    "! Add card to bottom of stack (first row)
    METHODS insert_item_at_bottom
      IMPORTING stack         TYPE ty_stack
                new_card      TYPE i
      RETURNING VALUE(result) TYPE ty_stack.

    "! Remove bottom card (delete first row)
    METHODS remove_item_from_bottom
      IMPORTING stack         TYPE ty_stack
      RETURNING VALUE(result) TYPE ty_stack.

    "! Count cards
    METHODS get_size_of_stack
      IMPORTING stack         TYPE ty_stack
      RETURNING VALUE(result) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_elyses_enchantments IMPLEMENTATION.

  METHOD get_item.
    result = stack[ position ].
  ENDMETHOD.


  METHOD set_item.
    result = stack.
    result[ position ] = replacement.
  ENDMETHOD.


  METHOD insert_item_at_top.
    result = stack.
    APPEND new_card TO result.
  ENDMETHOD.


  METHOD get_size_of_stack.
    result = lines( stack ).
  ENDMETHOD.


  METHOD insert_item_at_bottom.
    APPEND new_card TO result.
    LOOP AT stack ASSIGNING FIELD-SYMBOL(<card>).
      APPEND <card> TO result.
    ENDLOOP.
  ENDMETHOD.


  METHOD remove_item.
    LOOP AT stack ASSIGNING FIELD-SYMBOL(<card>).
      IF sy-tabix = position.
        CONTINUE.
      ENDIF.
      APPEND <card> TO result.
    ENDLOOP.
  ENDMETHOD.


  METHOD remove_item_from_bottom.
    DO lines( stack ) - 1 TIMES.
      APPEND stack[ sy-index + 1 ] TO result.
    ENDDO.
  ENDMETHOD.


  METHOD remove_item_from_top.
    DO lines( stack ) - 1 TIMES.
      APPEND stack[ sy-index ] TO result.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
