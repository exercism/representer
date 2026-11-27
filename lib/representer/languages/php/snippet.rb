# The website shows the first lines of each solution on its card. This file
# says what to leave out of a PHP solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer
  module Languages
    class PHP
      class Snippet < Representer::Engine::Snippet
        # Remove every comment, wherever it is.
        remove :comments # $x = 1; «// The answer»

        # Skip the opening tag, declarations and imports at the top of the file, up to the first other statement.
        skip_at_top "<?php",    # «<?php»
                    :declare,   # «declare(strict_types=1);»
                    :namespace, # «namespace App;»
                    :use        # «use App\Helpers;»

        # Skip only the header line of a namespace, and show the code inside it.
        containers :namespace_definition # «namespace App {» ... «}»
      end
    end
  end
end
