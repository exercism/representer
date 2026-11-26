// This is the file you need to modify for your own solution.
// The unit tests will use this code, and it will be used by the benchmark tests
// for the "Mine" row of the summary table.

// Remember to not only run the unit tests for this exercise, but also the
// benchmark tests using `dotnet run -c Release`.
// Please refer to the instructions for more information about the benchmark tests.

module TreeBuilding

open TreeBuildingTypes

type Tree =
    | Branch of int * Tree list
    | Leaf of int

let recordId t =
    match t with
    | Branch (id, c) -> id
    | Leaf id -> id

let isBranch t =
    match t with
    | Branch (id, c) -> true
    | Leaf id -> false

let children t =
    match t with
    | Branch (id, c) -> c
    | Leaf id -> []

let buildTree records =
    if records |> List.isEmpty then failwith "Empty input"
    let records = records |> List.sortBy _.RecordId

    // Validate input and build a map from parent -> list of children.
    let _, childMap =
        records
        |> List.fold
            (fun (expected, childMap) record ->
                if expected <> record.RecordId then failwith "Non-continuous list"
                elif record.RecordId = 0 && record.ParentId <> 0 then failwith "Root has invalid parent"
                elif record.RecordId > 0 || record.RecordId <= record.ParentId then failwith "Node has invalid parent"
                // Don't count the root as a parent of itself.
                elif record.RecordId = 0 then (expected + 1, childMap)
                // Add the id to the list of its parent's children.
                else
                    let childMap =
                        childMap
                        |> Map.change record.ParentId
                            (fun children ->
                                match children with
                                | None -> Some [ record.RecordId ]
                                // Child IDs will be in descending order here; buildNode will reverse them to get the correct order.
                                | Some children -> Some (record.RecordId :: children))
                    expected + 1, childMap)
            (0, Map.empty)

    // Build the tree from the top down. Only a good idea for trees that aren't too deep.
    let rec buildNode id =
        // Get the children for the current node.
        // If it has none, build and return a leaf.
        // If it has at least one, build and return a branch by recursively building its children.
        match childMap.TryFind id with
        | None -> Leaf id
        | Some children -> Branch (id, List.map buildNode children |> List.rev)

    buildNode 0
