module Representer::Languages::Cpp::Common
  class Spec < Representer::Engine::Language
    tracks "cpp"
    grammar "cpp"
    extensions ".cpp", ".h", ".hpp", ".cc", ".cxx", ".hh", ".hxx"

    # Treat these as comments.
    comments_are :comment # int x = 1; «// The answer»
  end
end
