unit AtbashCipher;

{$mode ObjFPC}{$H+}

interface

function encode(const phrase: string): string;
function decode(const phrase: string): string;
function transform(c: char): char;

implementation

uses SysUtils, StrUtils;

function transform(c: char): char;
begin
  if ('a' <= c) and (c <= 'z') then
    Result := char(219 - Ord(c))
  else if (c = ',') or (c = '.') then
    Result := #0
  else
    Result := c;
end;

function encode(const phrase: string): string;
const
  NoChar = #0;
var
  word: string;
  c, ctrans: char;
  i: integer;
begin
  Result := '';
  i := 0;
  for word in SplitString(LowerCase(phrase), ' ') do
    for c in word do
    begin
      ctrans := transform(c);
      if ctrans <> NoChar then
      begin
        Result := Result + ctrans;
        Inc(i);
        if (i mod 5 = 0) then
          Result := Result + ' ';
      end;
    end;
  Result := Trim(Result);
end;

function decode(const phrase: string): string;
begin
  Result := StringReplace(encode(phrase), ' ', '', [rfReplaceAll]);
end;

end.
