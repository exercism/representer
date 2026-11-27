# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Perl solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Perl5
  class Snippet < Representer::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # my $x = 1; «# The answer»

    # Skip the package declaration and pragmas at the top of the file, up to the first other statement.
    skip_at_top :package,           # «package Leap;»
                "use strict",       # «use strict;»
                "use warnings",     # «use warnings;»
                "use v5",           # «use v5.36;»
                "use 5",            # «use 5.036;»
                "use feature",      # «use feature 'say';»
                "use experimental", # «use experimental 'signatures';»
                "use builtin",      # «use builtin 'true';»
                "no warnings",      # «no warnings 'once';»
                "use Exporter",     # «use Exporter 'import';»
                "our @EXPORT",      # «our @EXPORT = qw(is_leap);»
                "our @EXPORT_OK"    # «our @EXPORT_OK = qw(is_leap);»
  end
end
