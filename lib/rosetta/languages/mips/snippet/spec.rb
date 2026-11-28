# The website shows the first lines of each solution on its card. This file
# says what to leave out of a MIPS solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Rosetta::Languages::Mips::Snippet
  class Spec < Rosetta::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 1

    # Work on lines, so that the directives below can be removed by the
    # words that start them.
    lines_only

    # Remove every comment, wherever it is.
    remove :comments # li $t0, 1 «# The answer»

    # Find the comments in a file that doesn't parse, by the way they start, because Rouge has no MIPS lexer.
    comment_lines "#" # «# A comment»

    # Remove the assembler directives wherever they are, because they only say where code and data go.
    remove_lines ".data",  # «.data»
                 ".text",  # «.text»
                 ".globl"  # «.globl main»
  end
end
