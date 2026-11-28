module Representer::Languages::Perl5::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename the names of variables, functions, methods, packages and labels.
    # A sigil stays outside the name, so `$count`, `@count` and `$count[0]`
    # share the name `count`.
    names_are :varname,    # $«count»
              :function,   # «area»(2, 3)
              :bareword,   # sub «area» { ... }
              :method,     # $shape->«area»
              :package,    # package «Shape»;
              :identifier, # «OUTER»: for ...
              :label       # next «OUTER»

    # Rename the variables that `my`, `our`, `state`, `field`, a `for` loop
    # or a signature declares. GenerateAST marks each of them.
    names_are_defined_by scalar: :declared, # my $«count» = 0;
                         array: :declared,  # my @«items»;
                         hash: :declared    # my %«seen»;

    # Rename the names of subs, methods, packages, classes, constants and
    # labels.
    names_are_defined_by subroutine_declaration_statement: :name, # sub «area» { ... }
                         method_declaration_statement: :name,     # method «area» { ... }
                         package_statement: :name,                # package «Shape»;
                         class_statement: :name,                  # class «Shape»;
                         list_expression: :constant,              # use constant «PI» => 3.14;
                         statement_label: :label                  # «OUTER»: for ...

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module it needs. Drop `strict` and `warnings` too,
    # because they only add checks, which a passing solution meets, and the
    # export lists, because they only make names available. Keep the other
    # pragmas, such as `use v5.38`, `use feature` and `use integer`, because
    # they change how Perl reads the code. GenerateAST gives a pragma a type
    # of its own, and a module's name starts with a capital, so
    # `use {{Module}} {{...}}` matches only modules.
    imports "use {{Module}} {{...}}",    # «use List::Util qw(sum);»
            "require {{Module}}",        # «require POSIX;»
            "use strict {{...}}",        # «use strict;»
            "no strict {{...}}",         # «no strict 'refs';»
            "use warnings {{...}}",      # «use warnings;»
            "no warnings {{...}}",       # «no warnings 'recursion';»
            "use lib {{...}}",           # «use lib '.';»
            "our @EXPORT = {{...}}",     # «our @EXPORT = qw(is_leap);»
            "our @EXPORT_OK = {{...}}",  # «our @EXPORT_OK = qw(is_leap);»
            "our %EXPORT_TAGS = {{...}}" # «our %EXPORT_TAGS = (all => [qw(is_leap)]);»
  end
end
