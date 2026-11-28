module Inspector::Languages::PharoSmalltalk::Common
  class Spec < Inspector::Engine::Language
    tracks "pharo-smalltalk"
    grammar "pharo_smalltalk"
    extensions ".st"

    # Treat these as comments.
    comments_are :comment # x := 1 «"The answer"»
  end
end
