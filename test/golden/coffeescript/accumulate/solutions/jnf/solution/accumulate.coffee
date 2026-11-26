Array.prototype.accumulate = (proc) ->
  proc(member) for member in this