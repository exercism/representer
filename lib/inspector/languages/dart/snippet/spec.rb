# The website shows the first lines of each solution on its card. This file
# says what to leave out of a Dart solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::Dart::Snippet
  class Spec < Inspector::Engine::Snippet
    # Remove every comment, wherever it is.
    remove :comments # var x = 1; «// The answer»

    # Skip the imports, exports and library declaration at the top of the file, up to the first other statement.
    skip_at_top :import,  # «import 'dart:math';»
                :export,  # «export 'src/leap.dart';»
                :library  # «library leap;»
  end
end
