unit PascalsTriangle;

{$mode ObjFPC}{$H+}

interface

type
  TIntArray2D = array of array of integer;

function factorial(const n: integer): uint64;
function NChooseK(const n, k: integer): uint64;
function rows(const Count: integer): TIntArray2D;

implementation

uses SysUtils;

function factorial(const n: integer): uint64;
var
  i: integer;
begin
  Result := 1;
  for i := 2 to n do
    Result *= i;
end;

function NChooseK(const n, k: integer): uint64;
begin
  Result := factorial(n) div (factorial(k) * factorial(n - k));
end;

function rows(const Count: integer): TIntArray2D;
var
  row: array of integer;
  n, k: integer;
begin
  Result := nil;
  for n := 0 to Count - 1 do
  begin
    row := nil;
    for k := 0 to n do
    begin
      SetLength(row, length(row) + 1);
      row[high(row)] := NChooseK(n, k);
    end;
    SetLength(Result, length(Result) + 1);
    Result[high(Result)] := row;
  end;
end;

end.
