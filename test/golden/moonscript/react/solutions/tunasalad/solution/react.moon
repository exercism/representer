local *

recalc_loop = (icell) ->
  pq = {}
  for r in *icell.referred
    pq[r.id] = r

  -- update the smallest unchecked compute cell until no more update
  while true
    low = ComputeCell.current_id -- all ids are less than this
    who = nil
    for id, ccell in pairs pq
      if low > id
        low = id
        who = ccell
    break if not who -- done

    -- now, low = lowest id, who = ComputeCell
    pq[low] = nil
    value = who\calc!
    if who.value != value
      who.value = value
      for r in *who.referred
        pq[r.id] = r
      for cb, _ in pairs who.callbacks
        cb value

class InputCell
  new: (x) =>
    @value = x
    @referred = {}
  get_value: => @value
  set_value: (x) =>
    if @value != x
      @value = x
      recalc_loop @

class ComputeCell
  current_id: 0

  new: (...) =>
    @args = {...}
    @referred = {}
    @callbacks = {}
    @id = @@current_id
    @@current_id += 1
    @fn = table.remove @args
    for x in *@args
      table.insert x.referred, @
    @value = @calc!

  get_value: => @value

  calc: =>
    f = @fn
    args = [ cell.value for cell in *@args ]
    f table.unpack args

  watch: (cb) =>
    @callbacks[cb] = true
  unwatch: (cb) =>
    @callbacks[cb] = nil

{ :InputCell, :ComputeCell }
