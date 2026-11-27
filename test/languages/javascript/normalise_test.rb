require_relative "stage_helper"

# Tests JavaScript's representation Normalise stage, and the engine's
# dropping of the imports declared in representation.rb.
class JavaScriptNormaliseTest < Minitest::Test
  include JavaScriptStages

  def test_drops_empty_statements
    assert_same "let x = 1;;", "let x = 1;"
    refute_same "for (;; i++) {}", "for (i++;;) {}"
  end

  def test_drops_imports_and_export_lists
    assert_same "import { a, b as c } from './b'\nimport d, { e } from 'e'\nimport * as f from 'f'\nconst x = 1", "const x = 1"
    assert_same "function f() {}\nexport { f }", "function f() {}"
    assert_same "function f() {}\nexport { f } from './f'", "function f() {}"
    refute_same "import './setup'\nconst x = 1", "const x = 1"
    refute_same "export * from './f'\nconst x = 1", "const x = 1"
  end

  def test_drops_declarations_that_only_require
    assert_same "const fs = require('fs')\nconst x = 1", "const x = 1"
    assert_same "var { a } = require('a'), b = require('b')\nconst x = 1", "const x = 1"
    refute_same "const a = 1, b = require('b')", "const c = 2"
    refute_same "const a = require('a').b", ""
  end

  def test_drops_module_exports_that_only_lists_names
    assert_same "function f() {}\nmodule.exports = { f }", "function f() {}"
    refute_same "module.exports = { f: () => 1 }", ""
    refute_same "module.exports = { f, g: () => 1 }", ""
  end

  private
  def tree(source) = write(prepare(source))
  def assert_same(first, second) = assert_equal(tree(first), tree(second))
  def refute_same(first, second) = refute_equal(tree(first), tree(second))
end
