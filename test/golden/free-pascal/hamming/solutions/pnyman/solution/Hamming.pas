unit Hamming;

{$mode ObjFPC}{$H+}

interface

function distance(const strand1: string; const strand2: string): integer;

implementation

uses SysUtils;

function distance(const strand1: string; const strand2: string): integer;
var
  i: integer;
begin
  if length(strand1) <> length(strand2) then
    raise Exception.Create('strands must be of equal length');
  i := 0;
  Result := 0;
  for i := 1 to high(strand1) do
    if strand1[i] <> strand2[i] then
      Inc(Result);
end;

end.
