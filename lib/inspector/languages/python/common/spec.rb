module Inspector::Languages::Python::Common
  class Spec < Inspector::Engine::Language
    tracks "python"
    grammar "python"
    extensions ".py"

    # Treat these as comments.
    comments_are :comment # x = 1 «# The answer»

    # Keep the text between the escapes of a string and inside a format
    # specifier, which the grammar leaves out of its tree.
    text_between_children :string_content,   # "«a»\n«b»"
                          :format_specifier  # f"{x:«>10»}"
  end
end
