unit RelativeDistance;

{$mode ObjFPC}{$H+}

{$WARN 4046 OFF}
{$WARN 5024 OFF}
{$WARN 5062 OFF}
{$WARN 5071 OFF}
{$WARN 6058 OFF}

interface

uses SysUtils, Generics.Collections;

type
  TStrArray   = array of string;
  TFamilyTree = specialize TDictionary<string, TStrArray>;
  TSeen       = specialize TDictionary<string, boolean>;

  TSeparation = record
    person: string;
    degree: integer;
  end;
  TQueue = array of TSeparation;

function degreeOfSeparation(const familyTree: TFamilyTree;
  const personA, personB: string): integer;

implementation

function bfs(graph: TFamilyTree; root, target: string): integer;
var
  seen:       TSeen;
  queue:      TQueue;
  separation: TSeparation;
  person, p:  string;
  degree:     integer;
begin
  seen := TSeen.Create;
  seen.Add(root, True);
  queue := nil;
  separation.person := root;
  separation.degree := 0;
  insert(separation, queue, length(queue));

  while length(queue) > 0 do
  begin
    person := queue[0].person;
    degree := queue[0].degree;
    Delete(queue, 0, 1);

    if person = target then exit(degree);

    for p in graph[person] do
      if not seen.ContainsKey(p) then
      begin
        seen.Add(p, True);
        separation.person := p;
        separation.degree := degree + 2;
        insert(separation, queue, length(queue));
      end;
  end;

  Result := -1;
end;

function degreeOfSeparation(const familyTree: TFamilyTree;
  const personA, personB: string): integer;
var
  graph: TFamilyTree;
  kv:    TFamilyTree.TDictionaryPair;
  parent, child1, child2: string;
  arr:   TStrArray;
begin
  graph := TFamilyTree.Create;
  for kv in familyTree do
  begin
    parent := kv.key;
    for child1 in kv.Value do
    begin
      if not graph.ContainsKey(parent) then graph.Add(parent, nil);
      arr := graph[parent];
      insert(child1, arr, length(arr));
      graph[parent] := arr;

      if not graph.ContainsKey(child1) then graph.Add(child1, nil);
      arr := graph[child1];
      insert(parent, arr, length(arr));
      graph[child1] := arr;

      for child2 in kv.Value do
      begin
        if child1 <> child2 then
        begin
          if not graph.ContainsKey(child2) then graph.Add(child2, nil);
          arr := graph[child1];
          insert(child2, arr, length(arr));
          graph[child1] := arr;
        end;
      end;
    end;
  end;

  Result := bfs(graph, personA, personB);
end;

end.
