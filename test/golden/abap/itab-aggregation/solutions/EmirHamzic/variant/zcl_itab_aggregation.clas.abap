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
     data: lt_aggregated_data type aggregated_data,
          ls_aggregated_data type aggregated_data_type,
          lt_initial_data type initial_numbers,
          ls_initial_data type initial_numbers_type.

    lt_initial_data = initial_numbers.

    LOOP AT lt_initial_data into ls_initial_data.
        READ TABLE lt_aggregated_data with key group = ls_initial_data-group into ls_aggregated_data.
        if sy-subrc = 0.
            ls_aggregated_data-count = ls_aggregated_data-count + 1.
            ls_aggregated_data-sum = ls_aggregated_data-sum + ls_initial_data-number.
            if ls_initial_data-number < ls_aggregated_data-min.
                ls_aggregated_data-min = ls_initial_data-number.
            endif.
            if ls_initial_data-number >= ls_aggregated_data-max.
                ls_aggregated_data-max = ls_initial_data-number.
            endif.

            ls_aggregated_data-average = ls_aggregated_data-sum / ls_aggregated_data-count.

            modify lt_aggregated_data from ls_aggregated_data INDEX sy-tabix.

        else.
            ls_aggregated_data-group = ls_initial_data-group.
            ls_aggregated_data-count = 1.
            ls_aggregated_data-sum = ls_initial_data-number.
            ls_aggregated_data-min = ls_initial_data-number.
            ls_aggregated_data-max = ls_initial_data-number.
            ls_aggregated_data-average = ls_initial_data-number.
            append ls_aggregated_data to lt_aggregated_data.
        endif.
    ENDLOOP.


    aggregated_data = lt_aggregated_data.
  ENDMETHOD.

ENDCLASS.
