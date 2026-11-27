module Representer::Languages::CFML
  class Spec < Representer::Engine::Language
    tracks "cfml"
    grammar "cfscript"
    extensions ".cfc"

    # Treat these as comments.
    comments_are :comment,    # x = 1; «// The answer»
                 :cf_comment  # x = 1; «<!--- The answer --->»

    # Keep the whole text of these names. The grammar gives a name that is
    # also a keyword, such as `query` or `default`, as a node that holds the
    # keyword's token.
    text_nodes :identifier,                            # «query» = 1
               :property_identifier,                   # x.«default»
               :shorthand_property_identifier_pattern, # {«static» = 1}
               :parameter_type                         # function f(«string» name)
  end
end
