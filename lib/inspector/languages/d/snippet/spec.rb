# The website shows the first lines of each solution on its card. This file
# says what to leave out of a D solution's snippet, so that the card
# shows the student's own code. docs/snippets.md explains each declaration.
module Inspector::Languages::D::Snippet
  class Spec < Inspector::Engine::Snippet
    # Bump the version whenever the snippet of any solution could change.
    version 2

    # Remove every comment, wherever it is.
    remove :comments # int x = 1; «// The answer»

    # Skip the module declaration and the imports at the top of the file, up
    # to the first other statement.
    skip_at_top :module, # «module leap;»
                :import  # «import std.format : format;»

    # A D file with a module declaration holds all its other statements inside
    # one module_def node. Skip only the declaration and show the code after it.
    containers :module_def
  end
end
