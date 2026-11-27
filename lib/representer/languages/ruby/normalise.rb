# Ruby's Normalise stage makes no changes of its own. The old representer
# only dropped `require` and `require_relative`, and the engine drops those
# as imports (see `imports` in ruby.rb).
#
# Update this comment whenever the class changes.
module Representer
  module Languages
    module Ruby
      class Normalise
        extend Engine::NormaliseStage
      end
    end
  end
end
