require_relative "stage_helper"

# Tests TypeScript's Normalise stage and the engine's dropping of the
# imports declared in representation.rb.
class TypeScriptNormaliseTest < Minitest::Test
  include TypeScriptStages

  def test_drops_empty_statements
    assert_same "f();;\nif (x) { g();; }", "f();\nif (x) { g(); }"
  end

  def test_keeps_the_empty_parts_of_a_for_loop
    refute_same "for (;; i++) {}", "for (i++;;) {}"
    refute_same "for (; i++;) {}", "for (i++;;) {}"
  end

  def test_drops_imports_and_export_lists
    assert_same "import { a } from './b'\nimport type { T } from './t'\nconst x = a", "const x = a"
    assert_same "import * as b from './b'\nimport c from './c'\nconst x = 1", "const x = 1"
    assert_same "function f() {}\nexport { f }", "function f() {}"
  end

  def test_drops_declarations_that_only_require_and_module_exports_that_only_lists_names
    assert_same "const fs = require('fs')\nconst x = 1", "const x = 1"
    assert_same "function f() {}\nmodule.exports = { f }", "function f() {}"
    refute_same "module.exports = { f: () => 1 }", ""
  end

  def test_keeps_an_import_with_no_names
    refute_same "import './setup'\nconst x = 1", "const x = 1"
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
