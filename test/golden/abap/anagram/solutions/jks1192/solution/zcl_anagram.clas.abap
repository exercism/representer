CLASS zcl_anagram DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS anagram
      IMPORTING
        input         TYPE string
        candidates    TYPE string_table
      RETURNING
        VALUE(result) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_anagram IMPLEMENTATION.
  METHOD anagram.
* add solution here
data: t1 type table of c.
data: t2 type table of c.
data(n1) = strlen( input ).
input = to_lower( input ).
do n1 times.
  data(off) = sy-index - 1.
  data(c) = input+off(1).
  append c to t1.
enddo.
sort t1.

loop at candidates into data(s).
data(n2) = strlen( s ).
data(st) = s.
s = to_lower( s ).
  if s eq input.
    continue.
  endif.
  do n2 times.
    data(off2) = sy-index - 1.
    data(c2) = s+off2(1).
    append c2 to t2.
  enddo.

  sort t2.
  if t1 eq t2.
      append st to result.
  endif.
  clear: n2, t2, st.
endloop.

  ENDMETHOD.
ENDCLASS.
