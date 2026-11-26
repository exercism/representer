-module(nucleotide_count).

-export([count/2, nucleotide_counts/1]).

count(Strand, Nucleotide) ->
  Counts = count(Strand),
  maps:get(Nucleotide, Counts).

nucleotide_counts(Strand) ->
  Counts = count(Strand),
  maps:to_list(Counts).

count(Strand) ->
  Map = #{"A" => 0, "C" => 0, "G" => 0, "T" => 0},
  Fun = fun(X, Acc) -> maps:update_with([X], fun(V) -> V + 1 end, Acc) end,
  lists:foldl(Fun, Map, Strand).
