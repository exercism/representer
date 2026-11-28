module Representer::Languages::GDScript::Common
  class Spec < Representer::Engine::Language
    tracks "gdscript"
    grammar "gdscript"
    extensions ".gd"

    # Treat these as comments.
    comments_are :comment,       # var x = 1 «# The answer»
                 :region_start,  # «#region Helpers»
                 :region_end     # «#endregion»

    # Keep the whole text of strings and node paths, because the grammar
    # leaves it out of its tree.
    text_nodes :string,       # «"Hello"»
               :string_name,  # «&"jump"»
               :node_path,    # «^"Player/Sprite"»
               :get_node      # «$Player/Sprite»
  end
end
