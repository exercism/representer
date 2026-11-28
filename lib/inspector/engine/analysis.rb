module Inspector::Engine
  # A language's analysis output is a module called Analysis, beside the
  # language's Common module, in the language's `analysis/` folder. Its
  # settings are a class called Spec that subclasses this one, such as
  # Ruby::Analysis::Spec, and declare the analysis's version. Its stages
  # and rules are classes beside the Spec: a Normalise stage that only the
  # analysis runs, and one class of rules for each exercise, such as
  # Ruby::Analysis::TwoFer in `analysis/two_fer.rb` for two-fer (see
  # AnalysisRules).
  class Analysis
    STAGE_FILES = { Normalise: "normalise" }.freeze

    class << self
      # Ruby calls this when a language defines its Analysis::Spec. The
      # engine then finds the analysis's stage and each exercise's rules in
      # its folder (see AutoloadFiles).
      def inherited(spec)
        super
        folder = File.join(Inspector::Engine.folder_of(Inspector::Engine.language_module(spec)), "analysis")
        files = Dir[File.join(folder, "*.rb")].map { |path| File.basename(path, ".rb") } - STAGE_FILES.values - ["spec"]
        files.each { |file| spec.exercises[file.tr("_", "-")] = class_name(file) }
        AutoloadFiles.(Inspector::Engine.output_module(spec), folder,
          STAGE_FILES.merge(files.to_h { |file| [class_name(file), file] }))
      end

      # The Spec of the language, such as Ruby::Common::Spec.
      def language = Inspector::Engine.language_module(self)::Common::Spec

      # The analysis's version. Bump it whenever the comments on any
      # solution could change, so the website knows to analyse the track's
      # solutions again.
      def version(number = nil)
        return @version unless number
        raise ArgumentError, "A version must be from 1 to 32767" unless (1..32_767).cover?(number)

        @version = number
      end

      # The class name of each exercise's rules, by the exercise's slug.
      def exercises = @exercises ||= {}

      # The rules for the exercise, such as Ruby::Analysis::TwoFer for
      # two-fer, or nil if the exercise has none.
      def rules_for(exercise_slug)
        name = exercises[exercise_slug]
        name && Inspector::Engine.output_module(self).const_get(name, false)
      end

      # Runs the analysis's stage with this name on the tree, and returns
      # the new tree (see Engine.run_stage).
      def run_stage(name, tree) = Inspector::Engine.run_stage(Inspector::Engine.output_module(self), name, tree)

      private
      # two_fer  ->  TwoFer
      def class_name(file) = file.split("_").map(&:capitalize).join.to_sym
    end
  end
end
