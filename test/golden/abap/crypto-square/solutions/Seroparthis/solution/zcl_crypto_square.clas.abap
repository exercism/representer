CLASS zcl_crypto_square DEFINITION.

  PUBLIC SECTION.
    METHODS encode IMPORTING plain_text         TYPE string
                   RETURNING VALUE(crypto_text) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_crypto_square IMPLEMENTATION.
  METHOD encode.
    DATA: string TYPE string,
          columns TYPE i VALUE 1,
          rows TYPE i VALUE 1,
          x TYPE i,
          y TYPE i VALUE 0,
          itab TYPE TABLE OF string,
          wa TYPE string,
          result TYPE string,
          table_entry TYPE string,
          letter TYPE string,
          counter1 TYPE i VALUE 1,
          counter2 TYPE i VALUE 0.
    string = plain_text.
    "Replace all special characters with space."
    REPLACE ALL OCCURRENCES OF REGEX '[^\w]+' IN string WITH | |.
    "Remove all blanks"
    CONDENSE string NO-GAPS.
    "Lowercase the input string"
    TRANSLATE string TO LOWER CASE.
    "Lenght of adjusted input"
    DATA(len) = STRLEN( string ).
    "Case differentiation for len = 0 and len <> 0. See ending of method."
    IF len <> 0.
    "While the arithmetic product of the number and rows is lower that the length of the adjusted input, do either raise columns or rows by one so that they are always either equal or rows = columns + 1 (Confer requirements.)"
    WHILE rows * columns < len.
      IF columns = rows.
        columns = columns + 1.
      ELSE.
        rows = rows + 1.
      ENDIF.
    ENDWHILE.
    "After number of rows and columns is set, add spaces until the number of characters in the adjusted input fits the arithmetic product of rows * columns, so that the rectangular shape is created."
    WHILE len <> rows * columns.
      string = string && |  |.
      len = len + 1.
    ENDWHILE.

    "Create the rectangular shape with itab, by seperating the string after column characters row times and add the substrings to the itab."
    DO rows TIMES.
      APPEND string+y(columns) TO itab.
      y = y + columns.
    ENDDO.
    "Take the entry from itab and then concatentate the letter from that entry to the output string. Start in the first row with the first letter and after getting all first letter from all rows continue to the next column and get ever second letter. Continue with the pattern until all letters are allocated correctly."  
    DO columns TIMES.
      DO rows TIMES.
        table_entry = itab[ counter1 ].
        letter = table_entry+counter2(1).
        result = result && letter.
        counter1 = counter1 + 1.
      ENDDO.
      counter1 = 1.
      counter2 = counter2 + 1. 
        "Whenever all rows where treated, add a space."
        result = result && | |.
    ENDDO.

    "If there is only 1 row, that means that there must be a string of input size 1 or 0. In that case make sure to delete the blank that has been added in the course of the previous loop. If there are more than one row make sure to delete the last blank that has been added during the loop."
    IF rows = 1.
      CONDENSE result NO-GAPS.
    ELSE.
      len = STRLEN( result ).
      len = len - 1.
      result = result+0(len).
    ENDIF.
    
    crypto_text = result .
    WRITE:/ crypto_text.

    "Sequel of case differention. When len = 0 then output is empty string."
    ELSE.
      crypto_text = ''.
    ENDIF.

  ENDMETHOD.
ENDCLASS.