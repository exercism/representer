
unit LinkedList;

{$mode ObjFPC}{$H+}

interface

type
  TNode = class
  private
    data:     integer;
    previous: TNode;
    next:     TNode;
  public
    constructor Create(const aData: integer);
    destructor Destroy; override;
  end;

  TLinkedList = class
  private
    root: TNode;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Push(const aValue: integer);
    function Pop: integer;
    procedure Unshift(const aValue: integer);
    function Shift: integer;
    procedure Delete(const aValue: integer);
    function Count: integer;
  end;

implementation

uses SysUtils;

constructor TNode.Create(const aData: integer);
begin
  data := aData;
end;

destructor TNode.Destroy;
begin
  if (previous <> nil) and (next <> nil) then
  begin
    previous.next := next;
    next.previous := previous;
  end
  else if previous <> nil then
    previous.next := nil
  else if next <> nil then
    next.previous := nil;
  inherited;
end;

constructor TLinkedList.Create;
begin
  inherited;
  root := nil;
end;

destructor TLinkedList.Destroy;
begin
  FreeAndNil(root);
  inherited;
end;

procedure TLinkedList.Push(const aValue: integer);

  procedure PushNode(var node: TNode);
  var
    new: TNode;
  begin
    if node = nil then
      node := TNode.Create(aValue)
    else if node.next = nil then
    begin
      new := TNode.Create(aValue);
      new.previous := node;
      node.next := new;
    end
    else
      PushNode(node.next);
  end;

begin
  PushNode(root);
end;

function TLinkedList.Pop: integer;

  function PopNode(var node: TNode): integer;
  begin
    if node.next = nil then
    begin
      Result := node.data;
      node   := nil;
    end
    else
      Result := PopNode(node.next);
  end;

begin
  if root = nil then
    raise Exception.Create('empty list');
  Result := PopNode(root);
end;

procedure TLinkedList.Unshift(const aValue: integer);
var
  NewRoot, OldRoot: TNode;
begin
  NewRoot := TNode.Create(aValue);
  if root = nil then
  begin
    root := NewRoot;
  end
  else
  begin
    OldRoot := root;
    NewRoot.next := OldRoot;
    OldRoot.previous := NewRoot;
    root    := NewRoot;
  end;
end;

function TLinkedList.Shift: integer;
begin
  if root = nil then
    raise Exception.Create('empty list');
  Result := root.data;
  if root.next = nil then
    root := nil
  else
    root := root.next;
end;

procedure TLinkedList.Delete(const aValue: integer);
var
  this: TNode;
begin
  this := root;
  while (this <> nil) and (this.data <> aValue) do
    this := this.next;
  if this = nil then exit;
  if this = root then root := this.next;
  this.Free;
end;

function TLinkedList.Count: integer;
var
  this: TNode;
begin
  if root = nil then
    exit(0);
  Result := 1;
  this   := root;
  while this.next <> nil do
  begin
    this := this.next;
    Inc(Result);
  end;
end;

end.
