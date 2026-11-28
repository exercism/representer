module Rosetta::Languages::YAMLScript::Common
  class Spec < Rosetta::Engine::Language
    tracks "yamlscript"
    grammar "yamlscript"
    extensions ".ys"

    # Treat these as comments.
    comments_are :comment # x =: 1 «# The answer»
  end
end
