# docs/analysis.md defines the verbs in this file.
# The tests call TwoFer.two_fer with a name and without one.
module Inspector::Languages::Ruby::Analysis
  class TwoFer < Inspector::Engine::AnalysisRules
    missing(["class TwoFer; {{...}}; end", "module TwoFer; {{...}}; end"]) { essential "ruby.general.no_target_module" }

    within ["class TwoFer; {{...}}; end", "module TwoFer; {{...}}; end"] do
      missing(["def self.two_fer({{...}}); {{...}}; end", "def self.two_fer({{...}}) = {{_}}"]) do
        essential "ruby.general.no_target_method"
      end

      # Ask for one parameter with a default value.
      within ["def self.two_fer({{...}}); {{...}}; end", "def self.two_fer({{...}}) = {{_}}"] do
        first_of do
          uses(["def self.two_fer(*{{name}}); {{...}}; end", "def self.two_fer(*{{name}}) = {{_}}"]) do
            actionable "ruby.two-fer.splat_args", name_variable: "{{name}}"
          end
          missing(["def self.two_fer({{_}} = {{_}}); {{...}}; end", "def self.two_fer({{_}} = {{_}}) = {{_}}"]) do
            essential "ruby.two-fer.missing_default_param"
          end
        end
      end

      within ["def self.two_fer({{name}} = {{default}}); {{...}}; end",
              "def self.two_fer({{name}} = {{default}}) = {{_}}"] do
        first_of do
          # Ask for no `return`, because Ruby returns the method's last value.
          uses(['def self.two_fer({{name}} = "you"); return "One for #{{{name}}}, one for me."; end',
                'def self.two_fer({{name}} = "you"); return {{_}} + "{{_}}"; end',
                'def self.two_fer({{name}} = "you"); return format("{{_}}", {{name}}); end',
                'def self.two_fer({{name}} = "you"); return "{{_}}" % {{name}}; end']) do
            actionable "ruby.general.explicit_return"
          end

          # Suggest other ways to build the string, for a method that builds
          # it in one statement, with "you" as the default.
          uses('def self.two_fer({{name}} = "you"); "One for #{{{name}}}, one for me."; end') do
            next actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)

            informative "ruby.two-fer.string_interpolation", name_variable: "{{name}}"
          end

          uses('def self.two_fer({{name}} = "you"); {{_}} + "{{_}}"; end') do
            next actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)

            actionable "ruby.two-fer.string_concatenation", name_variable: "{{name}}"
          end

          uses('def self.two_fer({{name}} = "you"); format("{{_}}", {{name}}); end') do
            next actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)

            informative "ruby.two-fer.kernel_format", name_variable: "{{name}}"
          end

          uses('def self.two_fer({{name}} = "you"); "{{_}}" % {{name}}; end') do
            next actionable "ruby.general.incorrect_indentation" unless indented_in_steps_of?(2)

            informative "ruby.two-fer.string_format", name_variable: "{{name}}"
          end

          # Leave a method with several conditionals to a mentor. An
          # `elsif` belongs to the conditional around it.
          uses("if {{_}}; {{...}}; else; {{...}}; end", more_than: 1)

          # Suggest "you" as the default, in place of a conditional or `||=`
          # that puts it in.
          uses(["if {{name}}; {{...}}; else; {{...}}; end",
                "if !{{name}}; {{...}}; else; {{...}}; end",
                "if {{name}}.{{_}}({{...}}); {{...}}; else; {{...}}; end",
                "if {{name}} == {{_}}; {{...}}; else; {{...}}; end",
                "if {{name}} != {{_}}; {{...}}; else; {{...}}; end",
                "if {{default}} == {{name}}; {{...}}; else; {{...}}; end",
                "if {{default}} != {{name}}; {{...}}; else; {{...}}; end"]) do
            actionable "ruby.two-fer.incorrect_default_param"
          end

          # Leave a method with any other conditional, or several `||=`, to a mentor.
          uses("if {{_}}; {{...}}; else; {{...}}; end")
          uses("{{_}} ||= {{_}}", more_than: 1)

          uses('{{name}} ||= "you"') { actionable "ruby.two-fer.reassigning_param" }
        end
      end
    end
  end
end
