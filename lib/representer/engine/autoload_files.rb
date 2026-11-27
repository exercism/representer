module Representer::Engine
  # Tells Ruby where to find the classes of a language. For each
  # class name in files, if the folder has a file of that name, Ruby will
  # load the file the first time the engine asks the owner for the class.
  # So `AutoloadFiles.(Ruby, folder, { Snippet: "snippet" })` loads
  # `snippet.rb` when the engine first asks for Ruby::Snippet.
  class AutoloadFiles
    include Mandate

    initialize_with :owner, :folder, :files

    def call
      files.each do |name, file|
        path = File.join(folder, "#{file}.rb")
        owner.autoload(name, path) if File.exist?(path)
      end
    end
  end
end
