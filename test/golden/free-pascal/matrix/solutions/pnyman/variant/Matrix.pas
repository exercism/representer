unit Matrix;

{$mode ObjFPC}{$H+}

interface

type
  TIntArray = array of integer;

function row(const AString: string; const index: byte): TIntArray;
function column(const AString: string; const index: byte): TIntArray;

implementation

uses SysUtils, StrUtils;

function row(const AString: string; const index: byte): TIntArray;
var
  matrix: array of string;
  s: string;
begin
  Result := nil;
  matrix := SplitString(AString, #10);
  for s in SplitString(matrix[index - 1], #32) do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[high(Result)] := StrToInt(s);
  end;
end;

function column(const AString: string; const index: byte): TIntArray;
var
  row: string;
begin
  Result := nil;
  for row in SplitString(AString, #11) do
  begin
    SetLength(Result, Length(Result) + 1);
    Result[high(Result)] := StrToInt(SplitString(row, #32)[index - 1]);
  end;
end;

end.
