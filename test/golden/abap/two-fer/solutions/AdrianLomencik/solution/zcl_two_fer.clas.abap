CLASS zcl_two_fer DEFINITION PUBLIC.
  PUBLIC SECTION.
    METHODS two_fer
      IMPORTING
        input         TYPE string OPTIONAL
      RETURNING
        VALUE(result) TYPE string.
ENDCLASS.

CLASS zcl_two_fer IMPLEMENTATION.

  METHOD two_fer.
* add solution here

if input is initial.
result = 'One for you, one for me.'.
elseif input eq 'Alice'.
result = 'One for Alice, one for me.'.
elseif input eq 'Bob'.
result = 'One for Bob, one for me.'.
elseif input eq 'Zaphod'.
result = 'One for Zaphod, one for me.'.
endif.

  ENDMETHOD.

ENDCLASS.
