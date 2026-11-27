require "rake/testtask"

Rake::TestTask.new do |task|
  task.libs << "test"

  # The golden data holds students' Ruby test files, which aren't ours to run.
  task.test_files = FileList["test/**/*_test.rb"].exclude("test/golden/**/*")
  task.warning = false
end

task default: :test
