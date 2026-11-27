module Representer::Languages::Perl5
  class Spec < Representer::Engine::Language
    tracks "perl5"
    grammar "perl"
    extensions ".pm", ".pl"

    # Treat these as comments. Perl's parser skips POD, so it is
    # documentation.
    comments_are :comment, # my $x = 1; «# The answer»
                 :pod      # «=pod ... =cut»

    # Keep the text of strings, regular expressions and heredocs, which the
    # grammar leaves out of its tree between escapes and interpolated code.
    text_between_children :string_content,          # "«Hello, »$name«!»"
                          :regexp_content,          # /«^»$prefix«\d+»/
                          :replacement,             # s/a/«b»/
                          :transliteration_content, # tr/«a-z»/A-Z/
                          :heredoc_content          # <<END\n«Hi »$name\nEND
  end
end
