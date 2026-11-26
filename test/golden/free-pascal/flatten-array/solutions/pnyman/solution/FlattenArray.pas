unit FlattenArray;
{$mode ObjFPC}{$H+}

interface

type
  IElement   = interface;
  TIElements = array of IElement;
  TIntArray  = array of integer;

  IElement = interface
    function isArray: boolean;
    function asInt: integer;
    function asArr: TIElements;
  end;

function flatten(const arr: TIElements): TIntArray;
procedure _flatten(const elements: TIElements; var acc: TIntArray);

implementation

uses SysUtils;

procedure _flatten(const elements: TIElements; var acc: TIntArray);
var
  elt: IElement;
begin
  for elt in elements do
  begin
    if elt = nil then
      continue;
    if elt.isArray then
      _flatten(elt.asArr, acc)
    else
      insert(elt.asInt, acc, length(acc));
  end;
end;

function flatten(const arr: TIElements): TIntArray;
begin
  result := nil;
  _flatten(arr, result);
end;

end.
