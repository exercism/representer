import Std

open Std (HashMap)

namespace TwoBucket

inductive BucketId where
  | one | two
  deriving BEq, Repr

abbrev Capacity := Nat
abbrev Volume := Nat
abbrev Moves := Nat

structure Result where
  moves  : Nat
  goal   : BucketId
  other  : Volume
  deriving BEq, Repr

private structure Deque (α : Type) where
  front: List α
  back: List α

private def Deque.nil {α} : Deque α := { front := [], back := [] }

private def Deque.push_back {α} (elem : α) (deque : Deque α) : Deque α :=

  ⟨ deque.front, elem :: deque.back⟩ 
private def Deque.pop_front {α} (deque : Deque α) : Option (α × Deque α) := Id.run do
  if let (elem :: front) := deque.front then
    return .some (elem, { front := front, back := deque.back : Deque α })
  -- otherwise: front is empty, pump all from `back`
  return match deque.back.reverse with
  | [] => .none
  | (elem :: front) => .some (elem, ⟨ front, [] ⟩)

#guard (Deque.nil : Deque Nat).pop_front.isNone
#guard (Deque.nil.push_back 2 : Deque Nat).pop_front.map (·.fst) == .some 2

private structure State where
  first : Volume
  second : Volume
  steps : Nat
  deriving BEq, Repr

private def State.nil : State :=
  { first := 0, second := 0, steps := 0 } 

private
def State.fill {first second : Capacity} (st : State) (which : BucketId) : State :=
  let st := { st with steps := st.steps + 1 }
  match which with
  | .one => { st with first := first }
  | .two => { st with second := second }

#guard State.fill (first := 3) (second := 5) ⟨ 3, 0, 0 ⟩ .two == ⟨ 3, 5, 1 ⟩ 

private
def State.empty (st : State) (which : BucketId) : State :=
  let st := { st with steps := st.steps + 1 }
  match which with
  | .one => { st with first := 0 }
  | .two => { st with second := 0 }

#guard State.empty ⟨ 3, 0, 0 ⟩ .one == ⟨ 0, 0, 1 ⟩ 

private
def State.exchange {first second : Capacity} (st : State) (dest : BucketId) : State :=
  let st := { st with steps := st.steps + 1 }
  match dest with
  | .one => 
      let unused := Nat.min (first + st.first) st.second
      { st with first := st.first + unused, second := st.second - unused }
  | .two =>
      let unused := Nat.min (second - st.second) st.first
      { st with first := st.first - unused, second := st.second + unused }

#guard State.exchange (first := 3) (second := 5) ⟨ 2, 2, 0 ⟩ .one == ⟨ 3, 1, 1 ⟩ 
#guard State.exchange (first := 3) (second := 5) ⟨ 2, 0, 0 ⟩ .one == ⟨ 2, 0, 1 ⟩ 
#guard State.exchange (first := 3) (second := 5) ⟨ 2, 0, 0 ⟩ .two == ⟨ 0, 2, 1 ⟩ 

private
def State.reached (st : State) (goal : Volume) : Option Result :=
  if st.first == goal then
    .some { moves := st.steps, goal := .one, other := st.second }
  else if st.second == goal then
    .some { moves := st.steps, goal := .two, other := st.first }
  else
    .none

#guard State.reached ⟨ 2, 6, 10 ⟩ 2 == .some { moves := 10, goal := .one, other := 6 }
#guard State.reached ⟨ 3, 6, 10 ⟩ 2 == .none
#guard State.reached ⟨ 3, 6, 10 ⟩ 6 == .some { moves := 10, goal := .two, other := 3 }

def measure
    (first second : Capacity)
    (goal : Volume)
    (start : BucketId)
: Option Result := Id.run do
  let fill := fun st which => State.fill (first := first) (second := second) st which
  let exchange := fun st which => State.exchange (first := first) (second := second) st which

  -- memoization:
  let mut visited : HashMap (Volume × Volume) Moves := {}
  -- dbg_trace s!"capacity: first={first}, second={second}"

  let st0 := fill State.nil start
  -- dbg_trace repr st0
  visited := visited.insert (first, 0) st0.steps
  visited := visited.insert (0, second) st0.steps
  let mut q : Deque State := Deque.nil.push_back st0
  while True do
    let .some (st, q0) := q.pop_front
      | return .none
    if let .some result := st.reached goal then
      return .some result
    visited := visited.insert (st.first, st.second) st.steps
    q := q0
    for action in [State.empty, exchange, fill] do
      for target in [.one, .two] do
        let st1 := action st target
        if !visited.contains (st1.first, st1.second) then
          -- dbg_trace s!"action=?, target={repr target} : {repr st1}"
          q := q.push_back st1
  return .none

#eval TwoBucket.measure 3 5 1 .two

end TwoBucket
