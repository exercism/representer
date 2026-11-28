module Inspector::Languages::Bash::Common
  class Spec < Inspector::Engine::Language
    tracks "bash"
    grammar "bash"
    extensions ".sh"

    # Treat these as comments.
    comments_are :comment # x=1 «# The answer»

    # Keep the text between the children of these nodes, which the grammar
    # leaves out of its tree.
    text_between_children :number,           # $((«10#»$digits))
                          :binary_expression # [[ $x =~ «-» ]]
  end
end
