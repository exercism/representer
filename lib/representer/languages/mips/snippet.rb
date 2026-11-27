# The website shows the first lines of each solution on its card. This file
# says what to leave out of a MIPS solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Mips
  class Snippet < Representer::Engine::Snippet
    tracks "mips"

    # Remove every comment, wherever it is.
    remove :comments # li $t0, 1 «# The answer»

    # Find the comments by the way they start, because Rouge has no MIPS lexer.
    comment_lines "#" # «# A comment»

    # Remove the assembler directives wherever they are, because they only say where code and data go.
    remove_lines ".data",  # «.data»
                 ".text",  # «.text»
                 ".globl"  # «.globl main»
  end
end
