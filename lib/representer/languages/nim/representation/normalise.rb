# docs/dsl.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on.
module Representer::Languages::Nim::Representation
  class Normalise < Representer::Engine::Normalise
    def call
      super.tap do |root|
        give_each_parameter_its_own_type!(root)
      end
    end

    private
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
