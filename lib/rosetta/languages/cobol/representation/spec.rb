module Rosetta::Languages::Cobol::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename words, and the names of programs and data items.
    names_are :WORD,         # MOVE 1 TO «WS-RESULT»
              :entry_name,   # 01 «WS-RESULT» PIC 9.
              :program_name  # PROGRAM-ID. «LEAP».

    # Rename the program, its data items and condition names, its
    # constants, its index names, files, paragraphs and sections, and the
    # parameters of the PROCEDURE DIVISION.
    names_are_defined_by :identification_division, # PROGRAM-ID. «LEAP».
                         :data_description,        # 01 «WS-RESULT» PIC 9.
                         :occurs_indexed,          # OCCURS 5 TIMES INDEXED BY «IDX»
                         :file_description_entry,  # FD «IN-FILE».
                         :paragraph_header,        # «MAIN-PARA».
                         :section_header,          # «MAIN» SECTION.
                         :procedure_param,         # PROCEDURE DIVISION USING «WS-X».
                         constant_entry: :name     # 01 «MAX-SIZE» CONSTANT 10.

    # Drop the REPOSITORY paragraph, because a solution that passes its
    # tests has already made every function it uses available.
    imports "REPOSITORY. FUNCTION ALL INTRINSIC." # «REPOSITORY. FUNCTION ALL INTRINSIC.»

    # Put a pattern that can only stand in the CONFIGURATION SECTION there,
    # such as the REPOSITORY paragraph. COBOL reads the first seven columns
    # of each line as the sequence area and the indicator, so the code
    # starts in the eighth.
    pattern_contexts "       PROGRAM-ID. P.\n       ENVIRONMENT DIVISION.\n       CONFIGURATION SECTION.\n       {{pattern}}"
  end
end
