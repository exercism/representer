module Rosetta::Languages::Cobol::Common
  class Spec < Rosetta::Engine::Language
    tracks "cobol"
    grammar "cobol"
    extensions ".cob"

    # Treat these as comments. COBOL reads the paragraphs after PROGRAM-ID,
    # such as AUTHOR, as comment entries that the program never uses.
    comments_are :comment,               # MOVE 1 TO X «*> The answer»
                 :author_section,        # «AUTHOR. Ada.»
                 :installation_section,  # «INSTALLATION. Home.»
                 :date_written_section,  # «DATE-WRITTEN. 2024-01-01.»
                 :date_compiled_section, # «DATE-COMPILED. 2024-01-01.»
                 :security_section       # «SECURITY. None.»

    # Keep the words that the grammar leaves out of its tree, because they
    # change what the code does, such as `LENGTH OF` or `TO TRUE`.
    text_between_children :paragraph_header,          # «MAIN».
                          :section_header,            # «MAIN SECTION».
                          :procedure_param,           # PROCEDURE DIVISION USING «WS-X».
                          :display_statement,         # DISPLAY X «UPON» SYSOUT
                          :stop_statement,            # «STOP RUN RETURNING» 1
                          :accept_statement,          # ACCEPT X «FROM» DATE
                          :add_statement,             # ADD A «TO» B «GIVING» C
                          :subtract_statement,        # SUBTRACT A «FROM» B «GIVING» C
                          :multiply_statement,        # MULTIPLY A «BY» B «GIVING» C
                          :divide_statement,          # DIVIDE A «INTO» B
                          :call_statement,            # CALL "f" «USING» X
                          :call_param_arg,            # CALL "f" USING «LENGTH OF» X
                          :expr,                      # IF «LENGTH OF» X > 1
                          :partial_expr,              # WHEN «LENGTH OF» X
                          :arithmetic_x,              # ADD 1 TO «LENGTH OF» X
                          :is_class,                  # IF «LENGTH OF» X IS NUMERIC
                          :is_not_class,              # IF «LENGTH OF» X IS NOT NUMERIC
                          :initialize_statement,      # INITIALIZE X «REPLACING» ALPHANUMERIC BY SPACE
                          :initialize_replacing_item, # INITIALIZE X REPLACING ALPHANUMERIC «DATA» BY SPACE
                          :inspect_tallying,          # INSPECT X TALLYING N FOR «CHARACTERS»
                          :replacing_item,            # INSPECT X REPLACING «CHARACTERS BY» "A"
                          :inspect_region,            # INSPECT X TALLYING N FOR ALL "A" BEFORE «INITIAL» "B"
                          :move_statement,            # MOVE «LENGTH OF» X TO Y
                          :perform_option,            # PERFORM X «TIMES»
                          :perform_varying,           # PERFORM VARYING I «FROM» 1 «BY» 1 «UNTIL» I > 3
                          :goto_statement,            # GO TO A B «DEPENDING ON» X
                          :set_to,                    # SET «ADDRESS OF» X TO Y
                          :set_up_down,               # SET I UP BY «LENGTH OF» X
                          :set_to_true_false,         # SET X TO «TRUE»
                          :string_item,               # STRING «LENGTH OF» X DELIMITED BY SIZE
                          :unstring_into_item,        # UNSTRING X DELIMITED BY "," INTO A «COUNT IN» N
                          :function_,                 # FUNCTION TRIM(X «LEADING»)
                          :value_clause,              # 88 X VALUE "Y" «WHEN SET TO FALSE» "N"
                          :read_statement,            # READ F «INTO» X
                          :return_statement,          # RETURN F «INTO» X
                          :write_statement,           # WRITE R «FROM» X
                          :rewrite_statement,         # REWRITE R «FROM» X
                          :release_statement,         # RELEASE R «FROM» X
                          :delete_statement,          # DELETE F «RECORD»
                          :write_option               # WRITE R AFTER ADVANCING 2 «LINES»
  end
end
