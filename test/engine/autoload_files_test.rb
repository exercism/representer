require "test_helper"
require "tmpdir"

class AutoloadFilesTest < Minitest::Test
  module Owner; end

  def test_autoloads_each_class_that_has_a_file
    Dir.mktmpdir do |folder|
      File.write(File.join(folder, "found.rb"), "module AutoloadFilesTest::Owner; class Found; end; end")
      Inspector::Engine::AutoloadFiles.(Owner, folder, { Found: "found", Missing: "missing" })
      assert Owner.const_defined?(:Found, false)
      refute Owner.const_defined?(:Missing, false)
      assert_kind_of Class, Owner::Found
    end
  end
end
