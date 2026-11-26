unit Acronym;

{$mode ObjFPC}{$H+}

interface

function abbreviate(const phrase: string): string;

implementation

uses SysUtils, StrUtils;

function abbreviate(const phrase: string): string;
var
  ww, w, s: string;
begin
  Result := '';
  for ww in SplitString(UpperCase(phrase), ' ') do
    for w in SplitString(ww, '-') do
      for s in w do
        if CharInSet(s[2], ['A'..'Z']) then
        begin
          Result += s;
          break;
        end;
end;

end.
