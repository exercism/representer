CLASS zcl_itab_combination DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF alphatab_type,
             cola TYPE string,
             colb TYPE string,
             colc TYPE string,
           END OF alphatab_type.
    TYPES alphas TYPE STANDARD TABLE OF alphatab_type.

    TYPES: BEGIN OF numtab_type,
             col1 TYPE string,
             col2 TYPE string,
             col3 TYPE string,
           END OF numtab_type.
    TYPES nums TYPE STANDARD TABLE OF numtab_type.

    TYPES: BEGIN OF combined_data_type,
             colx TYPE string,
             coly TYPE string,
             colz TYPE string,
           END OF combined_data_type.
    TYPES combined_data TYPE STANDARD TABLE OF combined_data_type WITH EMPTY KEY.

    METHODS perform_combination
      IMPORTING
        alphas             TYPE alphas
        nums               TYPE nums
      RETURNING
        VALUE(combined_data) TYPE combined_data.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.

CLASS zcl_itab_combination IMPLEMENTATION.

  METHOD perform_combination.
    DATA(length_alpha) = lines( alphas ).
    DATA(length_nums)  = lines( nums ).

    DATA(loop_len) = COND #( WHEN length_alpha > length_nums THEN length_nums ELSE length_alpha ).

    DO loop_len TIMES.
      DATA(alp) = alphas[ sy-index ].
      DATA(num) = nums[ sy-index ].
      APPEND VALUE combined_data_type( colx = |{ alp-cola }{ num-col1 }|
                                       coly = |{ alp-colb }{ num-col2 }|
                                       colz = |{ alp-colc }{ num-col3 }| ) TO combined_data.
    ENDDO.

    " Look for extra lines in either table
    IF length_alpha <> length_nums.
      DATA(diff) = ABS( length_alpha - length_nums ).
      DO diff TIMES.
        IF ( length_alpha > length_nums ).
          alp = alphas[ loop_len + sy-index ].
          APPEND VALUE combined_data_type( colx = alp-cola 
                                           coly = alp-colb 
                                           colz = alp-colc ) TO combined_data.
        ELSE.
          num = nums[ loop_len - sy-index ].
          APPEND VALUE combined_data_type( colx = num-col1 
                                           coly = num-col2 
                                           colz = num-col3 ) TO combined_data.
        ENDIF.
      ENDDO.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
