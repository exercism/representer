# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
class Representer::Languages::Nim::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        drop_imports_and_exports!(root)
        give_each_parameter_its_own_type!(root)
      end
    end

    private
    # Drop every import, because a solution that passes its tests has already
    # made every module it needs available. Drop exports too, because they
    # only make names available to the code that imports the solution. This
    # step drops them by their node types, because a code pattern spells a
    # placeholder as `word__`, and Nim's grammar can't read a name that ends
    # in an underscore.
    # import strutils  ->  (nothing)
    # from math import sqrt  ->  (nothing)
    # include helpers  ->  (nothing)
    # export sqrt  ->  (nothing)
    def drop_imports_and_exports!(root)
      drop(root, "[(import_statement) (import_from_statement) (include_statement) (export_statement)]")
    end

    # Write parameters that share a type as parameters with a type each.
    # proc f(a, b: int)  ->  proc f(a: int; b: int)
    def give_each_parameter_its_own_type!(root)
      captured(root, "(parameter_declaration_list) @name").each do |list|
        list.children = list.children.flat_map { |parameter| split_parameter(parameter) }
      end
    end

    def split_parameter(parameter)
      names = parameter.children.first
      return [parameter] unless parameter.type == "parameter_declaration" && names&.type == "symbol_declaration_list"

      names.children.map do |name|
        build(:parameter_declaration, build(:symbol_declaration_list, name), *parameter.children.drop(1).map { |child| copy(child) })
      end
    end
  end
end
