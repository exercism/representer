CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
    DATA: ls_post TYPE aggregated_data_type.
    SORT initial_numbers BY group ASCENDING.
    READ TABLE initial_numbers INDEX 1 INTO DATA(ls_group).
    ls_post-group = ls_group-group.
    LOOP AT initial_numbers ASSIGNING FIELD-SYMBOL(<internal>).
      IF ls_post-group NE <internal>-group.
        APPEND ls_post TO aggregated_data.
        CLEAR ls_post.
      ENDIF.
      ls_post-group = <internal>-group.
      ls_post-count += 1.
      ls_post-sum += <internal>-number.
      IF ls_post-count = 1.
        ls_post-min = <internal>-number.
        ls_post-max = <internal>-number.
      ELSE.
        ls_post-min = COND i( WHEN <internal>-number < ls_post-min THEN <internal>-number
                            ELSE ls_post-min ).
        ls_post-max = COND i( WHEN <internal>-number > ls_post-max THEN <internal>-number
                            ELSE ls_post-max ).
      ENDIF.
      ls_post-average = COND f( WHEN ls_post-sum NE 0 THEN ls_post-sum / ls_post-count ELSE 0 ).      
    ENDLOOP.
    IF ls_post-count > 0.
        APPEND ls_post TO aggregated_data.
    ENDIF.    
  ENDMETHOD.

ENDCLASS.
