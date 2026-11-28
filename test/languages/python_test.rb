require "test_helper"

class PythonTest < RosettaTest
  extend UpstreamTests

  track "python"

  DOUBLE = "The fixture's mapping holds a placeholder as if it were a name from the solution. Rosetta has no such " \
           "entry.".freeze

  ALIAS = "The engine drops every import, so the name given with `as` is never defined and keeps its name. " \
          "The fixture keeps imports and renames the alias.".freeze

  ORDER = "Rosetta renames a name the solution defines wherever it appears, including after a dot. " \
          "The fixture renames a name after a dot only once the name has been defined, earlier in the file.".freeze

  ROUNDING = "Rosetta keeps every digit of a decimal. Python rounds a float to 17 significant figures, so the " \
             "fixture merges decimals that differ only after them.".freeze

  DEVIATIONS = {
    "concept-chaitanas-colossal-coaster" => { replace: { ".index(" => ".placeholder_10(" }, why: ORDER },
    "practice-meetup" => { replace: { ".day " => ".placeholder_10 " }, why: ORDER },
    "practice-run-length-encoding" => { replace: { ".group(" => ".placeholder_6(" }, why: ORDER },
    "practice-scale-generator" => { replace: { ".index(" => ".placeholder_16(" }, why: ORDER },
    "example-number-normalization" => { replace: { "77555998125.44579" => "77555998125.445779" }, why: ROUNDING },
    "practice-wordy" => { restore: { "placeholder_0" => "div" }, remove: ["div"], why: ALIAS },
    "example-parencontext-normalization" => { restore: { "placeholder_0" => "pd" }, remove: ["pd"], why: ALIAS },
    "example-expression-normalization" => { remove: ["placeholder_3"], why: DOUBLE },
    "example-walrus-normalization" => { remove: ["placeholder_17"], why: DOUBLE },
    "practice-alphametics" => { remove: ["placeholder_37"], why: DOUBLE },
    "practice-knapsack" => { remove: ["placeholder_4"], why: DOUBLE },
    "practice-matrix" => { remove: ["placeholder_4"], why: DOUBLE },
    "practice-ocr-numbers" => { remove: ["placeholder_4"], why: DOUBLE },
    "practice-transpose" => { remove: ["placeholder_4"], why: DOUBLE },
    "practice-zebra-puzzle" => { remove: ["placeholder_11"], why: DOUBLE }
  }.freeze

  RENAMED = {
    ["self"] => %w[concept-ellens-alien-game example-class-normalization example-dataclass-normalization
                   example-docstring-removal example-expression-normalization example-walrus-normalization
                   practice-allergies practice-bank-account practice-binary-search-tree practice-bowling
                   practice-circular-buffer practice-clock practice-complex-numbers practice-connect
                   practice-custom-set practice-dnd-character practice-dot-dsl practice-forth
                   practice-go-counting practice-grade-school practice-hangman practice-high-scores
                   practice-kindergarten-garden practice-ledger practice-linked-list practice-luhn
                   practice-matrix practice-meetup practice-paasio practice-parallel-letter-frequency
                   practice-phone-number practice-pov practice-queen-attack practice-rational-numbers
                   practice-react practice-rectangles practice-rest-api practice-robot-name
                   practice-robot-simulator practice-scale-generator practice-simple-cipher
                   practice-simple-linked-list practice-space-age practice-tree-building practice-word-search
                   practice-zipper],
    ["open"] => ["practice-bank-account"],
    %w[filter list map] => ["practice-list-ops"],
    %w[input repr] => ["example-dataclass-normalization"],
    %w[next reversed] => ["practice-simple-linked-list"],
    ["slice"] => ["practice-largest-series-product"]
  }.freeze

  upstream_tests ".py",
    deviations: DEVIATIONS,
    renamed: RENAMED,
    renamed_why: "The fixture's mappings leave out `self` and Python's built-in names, even where the solution defined them."

  def test_imports_are_dropped
    assert_same_representation "import math, re\nx = 1", "import re\nimport math\nx = 1"
    assert_same_representation "import numpy as np\nfrom math import sqrt as root, pi\nx = 1", "x = 1"
    assert_same_representation "from math import *\nfrom math import (floor,\n    ceil)\nx = 1", "x = 1"
    refute_same_representation "from __future__ import annotations\nx = 1", "x = 1"
    assert_same_representation "def f():\n    import math\n    return math.pi", "def f():\n    return math.pi"
    assert_same_representation "__all__ = ['f']\ndef f(): pass", "def f(): pass"
    refute_same_representation "import math\nx = math.pi", "import cmath\nx = cmath.pi"
  end

  def test_syntax_errors_get_a_basic_representation_with_the_python_version
    assert_basic_representation "def (:"
  end
end
