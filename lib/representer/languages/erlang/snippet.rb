# The website shows the first lines of each solution on its card. This file
# says what to leave out of an Erlang solution's snippet, so that the card
# shows the student's own code. REPRESENTER_DSL.md explains each declaration.
module Representer::Languages::Erlang
  class Snippet < Representer::Engine::Snippet
    tracks "erlang"

    # Remove every comment, wherever it is.
    remove :comments # X = 1, «% The answer»

    # Skip the module attributes at the top of the file, up to the first other statement.
    skip_at_top "-module",      # «-module(leap).»
                "-export",      # «-export([leap_year/1]).»
                "-export_type", # «-export_type([year/0]).»
                "-import",      # «-import(lists, [map/2]).»
                "-include",     # «-include("leap.hrl").»
                "-include_lib", # «-include_lib("eunit/include/eunit.hrl").»
                "-compile",     # «-compile(export_all).»
                "-behaviour",   # «-behaviour(gen_server).»
                "-behavior",    # «-behavior(gen_server).»
                "-author"       # «-author("Ada").»
  end
end
