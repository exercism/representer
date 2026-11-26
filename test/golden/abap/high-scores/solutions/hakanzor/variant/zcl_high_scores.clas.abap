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
    DATA tmp type i.

ENDCLASS.


CLASS zcl_high_scores IMPLEMENTATION.

  METHOD constructor.
    me->scores_list = scores.
  ENDMETHOD.

  METHOD list_scores.
    result = me->scores_list.
  ENDMETHOD.

  METHOD latest.
    data: lv_count type i.
    describe table me->scores_list lines lv_count.
    read table me->scores_list index lv_count into result.
  ENDMETHOD.

  METHOD personalbest.
    sort me->scores_list descending.
    read table me->scores_list index 1 into result.
     
  ENDMETHOD.

  METHOD personaltopthree.
    sort  me->scores_list descending.
    do 3 times.
      read table me->scores_list index sy-index into tmp.
      if sy-subrc = 1.
          append me->tmp to result.
      endif.
    enddo.
  ENDMETHOD.


ENDCLASS.
