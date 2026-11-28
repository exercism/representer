module Rosetta::Languages::R::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the variables and fields that are assigned to, including the
    # functions assigned to a name.
    names_are_defined_by assignment: :lhs,        # «total» <- 0
                         extract_operator: :name  # robot$«direction» <- "north"

    # Rename parameters and the variables of loops.
    names_are_defined_by parameter: :name,        # function(«width», «height») width * height
                         for_statement: :variable # for («i» in 1:10) total <- total + i

    # Drop these imports, because a solution that passes its tests has
    # already loaded every package it needs. Drop the `if` that installs a
    # missing package before `require`, so that the whole `if` goes.
    imports "if (!require({{...}})) install.packages({{...}})", # «if (!require(dplyr)) install.packages("dplyr")»
            "library({{...}})",                                 # «library(stringr)»
            "require({{...}})"                                  # «require(stringr)»
  end
end
