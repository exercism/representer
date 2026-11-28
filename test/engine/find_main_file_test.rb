require "test_helper"

class FindMainFileTest < Minitest::Test
  def find(solution_files, exercise_files = {}) = Rosetta::Engine::FindMainFile.(solution_files, exercise_files)
  def config(*solution) = { ".meta/config.json" => { files: { solution: } }.to_json }

  def test_finds_the_first_solution_file_in_the_config_that_the_student_submitted
    assert_equal "c.rb", find({ "a.rb" => "", "b.rb" => "", "c.rb" => "" }, config("missing.rb", "c.rb", "b.rb"))
  end

  def test_falls_back_to_the_first_file_by_name
    files = { "b.rb" => "", "a.rb" => "" }
    assert_equal "a.rb", find(files)
    assert_equal "a.rb", find(files, config("missing.rb"))
    assert_equal "a.rb", find(files, { ".meta/config.json" => "not json" })
    assert_equal "a.rb", find(files, { ".meta/config.json" => '{"files": ["b.rb"]}' })
  end
end
