module Rosetta::Languages::Sqlite::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names. GenerateAST writes each one in lower case.
    names_are :identifier # «total»

    # Rename the tables, views, triggers and indexes that the solution
    # creates, and the columns of its tables. GenerateAST puts the name of
    # each table, view and trigger in the field `name`.
    names_are_defined_by create_table: :name,     # CREATE TABLE «results» (total INT)
                         create_view: :name,      # CREATE VIEW «totals» AS SELECT 1
                         create_trigger: :name,   # CREATE TRIGGER «check_total» AFTER INSERT ON t BEGIN ... END
                         create_index: :column,   # CREATE INDEX «by_total» ON t (total)
                         column_definition: :name # CREATE TABLE results («total» INT)

    # Rename the common table expressions and their columns.
    names_are_defined_by :cte # WITH «words»(«word», «rest») AS (...)

    # Rename the aliases of columns and tables.
    names_are_defined_by term: :alias,              # SELECT count(*) AS «total»
                         relation: :alias,          # FROM words AS «w»
                         cross_join: :alias,        # CROSS JOIN words AS «w»
                         lateral_join: :alias,      # JOIN LATERAL f() AS «w» ON true
                         lateral_cross_join: :alias # CROSS JOIN LATERAL f() AS «w»
  end
end
