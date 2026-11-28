module Inspector::Languages::Powershell::Common
  class Spec < Inspector::Engine::Language
    tracks "powershell"
    grammar "powershell"
    extensions ".ps1", ".psm1"

    # Treat these as comments.
    comments_are :comment # $x = 1 «# The answer»
  end
end
