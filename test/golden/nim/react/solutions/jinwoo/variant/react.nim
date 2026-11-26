import std/sequtils

type
  ComputeFunc = proc(vals: seq[int]): int {.noSideEffect.}

  Callback = proc(val: int)

  Cell = ref object
    val: int
    compute: ComputeFunc
    deps: seq[Cell]
    consumers: seq[Cell]
    callbacks: seq[Callback]

proc newInputCell*(val: int): Cell = Cell(val: val)

proc value*(cell: Cell): int =
  if not cell.compute.isNil:
    cell.val = cell.compute(cell.deps.map(value))
  cell.val

proc update(cell: Cell) =
  for con in cell.consumers:
    let old = con.val
    if con.value != old:
      for cb in con.callbacks:
        cb(con.val)
    con.update

proc `value=`*(cell: Cell, val: int) =
  cell.val = val
  cell.update

proc newComputeCell*(dependencies: seq[Cell], compute: ComputeFunc): Cell =
  result = Cell(compute: compute, deps: dependencies)
  discard result.value
  for dep in dependencies:
    dep.consumers.add(result)

proc addCallback*(cell: Cell, callback: Callback) =
  cell.callbacks.add(callback)

proc removeCallback*(cell: Cell, callback: Callback) =
  cell.callbacks.keepItIf(it == callback)
