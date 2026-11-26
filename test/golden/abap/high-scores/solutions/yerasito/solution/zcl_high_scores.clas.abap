CLASS zcl_high_scores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES integertab TYPE STANDARD TABLE OF i WITH EMPTY KEY.
    METHODS constructor
      IMPORTING
        scores TYPE integertab.

    METHODS list_scores
      RETURNING
        VALUE(result) TYPE integertab.

    METHODS latest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personalbest
      RETURNING
        VALUE(result) TYPE i.

    METHODS personaltopthree
      RETURNING
        VALUE(result) TYPE integertab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA scores_list TYPE integertab.

ENDCLASS.


CLASS zcl_high_scores IMPLEMENTATION.

  METHOD constructor.
    me->scores_list = scores.
  ENDMETHOD.

  METHOD list_scores.
    result = scores_list.
  ENDMETHOD.

  METHOD latest.
    IF lines( scores_list ) > 0.
      result = scores_list[ lines( scores_list ) ].
    ENDIF.
  ENDMETHOD.

  METHOD personalbest.
    LOOP AT scores_list INTO DATA(ls_i).
      IF ls_i > result.      
        result = ls_i.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD personaltopthree.
    SORT scores_list BY table_line DESCENDING.
    LOOP AT scores_list INTO DATA(ls_score).
      IF sy-tabix > 3.
        EXIT.
      ENDIF.
      APPEND ls_score TO result.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
