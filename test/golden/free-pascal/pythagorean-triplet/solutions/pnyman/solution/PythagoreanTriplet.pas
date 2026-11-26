unit PythagoreanTriplet;

{$mode ObjFPC}{$H+}

interface

type
  TIntArray   = array of integer;
  TIntArray2D = array of array of integer;

function tripletsWithSum(const n: integer): TIntArray2D;

implementation

uses SysUtils;

function tripletsWithSum(const n: integer): TIntArray2D;
var
  a, b, c: integer;
begin
  Result := nil;
  for a := 1 to n div 3 do
    for b := a to (n - a) div 2 do
    begin
      c := n - a - b;
      if a * a + b * b = c * c then
        insert(TIntArray([a, b, c]), Result, length(Result) + 1);
    end;
end;

end.
