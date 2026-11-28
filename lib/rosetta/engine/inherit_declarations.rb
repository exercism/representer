module Rosetta::Engine
  # A stage or an output keeps its declarations in instance variables of its
  # class, and names them with `declarations_in`. A subclass then starts with
  # a copy of its parent's declarations, and adds its own to them. So when
  # TypeScript's GenerateAST subclasses JavaScript's, it strips every token
  # that JavaScript's strips, as well as the ones it declares itself.
  module InheritDeclarations
    def declarations_in(*variables) = @declaration_variables = declaration_variables + variables

    def declaration_variables = @declaration_variables || []

    # Ruby calls this when a class subclasses this one, before the
    # subclass's own declarations run.
    def inherited(subclass)
      super
      subclass.instance_variable_set(:@declaration_variables, declaration_variables)
      declaration_variables.each do |variable|
        next unless instance_variable_defined?(variable)

        subclass.instance_variable_set(variable, InheritDeclarations.copy(instance_variable_get(variable)))
      end
    end

    # Copies the arrays and hashes inside a declaration, so a subclass that
    # adds to its copy leaves its parent's alone.
    def self.copy(value)
      case value
      when Array then value.map { |item| copy(item) }
      when Hash then value.to_h { |key, item| [key, copy(item)] }
      when Set then value.dup
      else value
      end
    end
  end
end
