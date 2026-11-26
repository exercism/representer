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
    " add solution here
    "initial_numbers = VALUE #( ( group = 'A' number = '10' )
    ""                            ( group = 'B' number = '5' )
     ""                           ( group = 'A' number = '6' )
    ""                            ( group = 'C' number = '22' )
    ""                            ( group = 'A' number = '13' )
     ""                           ( group = 'C' number = '500' )
   "" ).
    
    SORT initial_numbers BY group number.
    DATA(clone) = initial_numbers.
    DELETE ADJACENT DUPLICATES FROM clone COMPARING group.

    DATA: ls_agg LIKE LINE OF aggregated_data.
    LOOP AT clone INTO DATA(ls_clone).
      ls_agg-group = ls_clone-group.
      ls_agg-count = REDUCE i( init x = 0 FOR wa IN initial_numbers WHERE ( group = ls_clone-group ) NEXT x = x + 1 ).
      ls_agg-sum = REDUCE i( init x = 0 FOR wa IN initial_numbers WHERE ( group = ls_clone-group ) NEXT x = x + wa-number ).
      ls_agg-min = REDUCE #( INIT x = initial_numbers[ group = ls_clone-group ]-number
                FOR wa IN initial_numbers WHERE ( group = ls_clone-group )
                NEXT x = COND #( WHEN wa-number < x THEN wa-number ELSE x ) ).
      ls_agg-max = REDUCE #( INIT x = initial_numbers[ group = ls_clone-group ]-number
                FOR wa IN initial_numbers WHERE ( group = ls_clone-group )
                NEXT x = COND #( WHEN wa-number > x THEN wa-number ELSE x ) ).
      ls_agg-average = ls_agg-sum / ls_agg-count.
      APPEND ls_agg TO aggregated_data.
    ENDLOOP.
    
  ENDMETHOD.

ENDCLASS.
