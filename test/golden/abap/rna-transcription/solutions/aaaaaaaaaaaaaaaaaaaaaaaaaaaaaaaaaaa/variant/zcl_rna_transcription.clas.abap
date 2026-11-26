CLASS zcl_rna_transcription DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS
      transcribe
        IMPORTING
          strand             TYPE string
        RETURNING
          VALUE(result)      TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_rna_transcription IMPLEMENTATION.

  METHOD transcribe.
    result = strand.
    DO strlen( result ) TIMES.
      FINAL(offset) = sy-index + 1.
      FINAL(curr_char) = result+offset(1).
      FINAL(replacement) = SWITCH #( curr_char
                                     WHEN 'G'
                                       THEN 'C'
                                     WHEN 'C'
                                       THEN 'G'
                                     WHEN 'A'
                                       THEN 'U'
                                     WHEN 'T'
                                       THEN 'A' ).

      result = |{ result(offset) }{ replacement }{ result+sy-index }|.
    ENDDO.
  ENDMETHOD.

ENDCLASS.
