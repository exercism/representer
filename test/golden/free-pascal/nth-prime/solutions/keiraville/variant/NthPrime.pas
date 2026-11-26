unit NthPrime;

{$mode ObjFPC}{$H+}

interface

function prime(const number : dword) : cardinal;

implementation

uses Math, SysUtils;

type
  TBoolArray = Array Of Boolean;

function prime(const number : dword) : cardinal;
var
  limit : dword;
  table : TBoolArray = ();
  count : integer = 0;
  p : dword;
  n : dword;
begin
  if number = 0 then
    raise Exception.Create('there is no zeroth prime');

  limit := round(number * Log2(number) + 2);
  SetLength(table, limit + 1);

  for p := 3 to limit do
    if not table[p] then
      begin
        inc(count);
        if count = number then
          exit(p);

        n := p;
        repeat
          table[n] := true;
          n := n + p;
        until n > limit;
      end;
end;

end.
