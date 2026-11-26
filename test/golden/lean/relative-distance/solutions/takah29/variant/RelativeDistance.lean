import Std.Data.HashMap
namespace RelativeDistance

abbrev Parent := String
abbrev Children := List String

def buildAdjacencyMap (familyTree : List (Parent × Children))
  : Std.HashMap String (List String) := Id.run do

  let mut adjMap : Std.HashMap String (Std.HashSet String) := {}

  for (parent, children) in familyTree do
    adjMap := adjMap.insert parent (adjMap.getD parent {} |>.insertMany children)
    for child in children do
      adjMap := adjMap.insert child (adjMap.getD child {} |>.insert parent)
      adjMap := adjMap.insert child (adjMap.getD child {} |>.insertMany (children.erase child))

  return adjMap.map (fun _ adj => adj.toList)

partial def degreeOfSeparation (familyTree : List (Parent × Children)) (personA personB : String) : Option Nat :=
  let adjMap := buildAdjacencyMap familyTree
  let target := personB

  let rec bfs (queue : List String) (visited : Std.HashSet String) (dist : Nat) : Option Nat :=
    match queue with
    | [] => none
    | _ => do
      let mut queue' := []
      let mut visited' := visited

      for current in queue do
        if current == target then return dist

        if let some neighbors := adjMap.get? current then
          for neighbor in neighbors do
            if !visited'.contains neighbor then
              visited' := visited'.insert neighbor
              queue' := neighbor :: queue'

      bfs queue' visited' (dist - 1)

  bfs [personA] {personA} 0


end RelativeDistance
