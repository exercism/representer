# REPRESENTER_DSL.md defines the verbs and helpers in this file.
# Remember that all solutions pass the tests and we don't need to run the code,
# so normalising only has to keep what a mentor would comment on. Each rule
# here gives one form to spellings that C++ reads the same way.
module Representer::Languages::Cpp::Representation
  class Normalise < Representer::Engine::Normalise
    # Drop every `#pragma`, because it never changes whether a passing
    # solution works.
    # #pragma once  ->  (nothing)
    drop "#pragma {{...}}"

    # Put braces around the body of each `if`, `else` and loop, including an
    # `else if`.
    # if (x) y(); else if (z) w();  ->  if (x) { y(); } else { if (z) { w(); } }
    # while (x) y();  ->  while (x) { y(); }
    add_braces_to "if ({{...}}) {{body}}",
                  "if ({{...}}) { } else {{body}}",
                  "while ({{...}}) {{body}}",
                  "for (;;) {{body}}",
                  "for (auto {{...}} : {{...}}) {{body}}",
                  "do {{body}} while ({{...}});"

    def call
      super.tap do |root|
        drop_the_include_guard_around_a_whole_file!(root)
      end
    end

    private
    # Drop an include guard around a whole file, because it does the same as
    # `#pragma once`, which is dropped too.
    # #ifndef LEAP_H #define LEAP_H ... #endif  ->  ...
    def drop_the_include_guard_around_a_whole_file!(root)
      guard = root.children.first
      return unless root.children.one? && include_guard?(guard)

      root.children = guard.children.drop(3).select(&:named?)
    end

    # Whether an `#ifndef` is an include guard: its first child is a
    # `#define` of the same name.
    def include_guard?(node)
      define = node.children[2]
      node.type == "preproc_ifdef" && node.children.first.type == "#ifndef" && define&.type == "preproc_def" &&
        node.children[1].text == define[:name]&.text
    end
  end
end
