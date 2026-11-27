# The website shows the first lines of each solution on its card. A
# TypeScript solution starts the way a JavaScript one does, so its snippet
# leaves out what JavaScript's leaves out. REPRESENTER_DSL.md explains each
# declaration.
module Representer::Languages::TypeScript
  class Snippet < Representer::Languages::JavaScript::Snippet
  end
end
