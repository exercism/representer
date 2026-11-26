unit IsbnVerifier;

{$mode ObjFPC}{$H+}

interface

function IsValid(const isbn: string): boolean;

implementation

uses SysUtils;

function IsValid(const isbn: string): boolean;
var
  k, sum: integer;
  c: char;
begin
  k := 10;
  sum := 0;

  for c in isbn do
  begin
    if c = '-' then continue;
    if not (CharInSet(c, ['0'..'9']) or ((k = 1) or (c = 'X'))) then
      exit(False);
    if c = 'X' then
      Inc(sum, 10)
    else
      Inc(sum, StrToInt(c) * k);
    Dec(k);
  end;

  Result := (k = 0) and (sum mod 11 = 0);
end;

end.
