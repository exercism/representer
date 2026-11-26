unit VariableLengthQuantity;

{$mode ObjFPC}{$H+}

interface

type
  TBytes     = array of byte;
  TLongWords = array of longword;

function encode(const integers: TLongWords): TBytes;
function decode(const bytes: TBytes): TLongWords;

implementation

uses SysUtils;

function BitPosition(n: QWord): integer;
begin
  Result := 0;
  if n <> 0 then
    Result := BsrDWord(n) + 1;
end;

function encode(const integers: TLongWords): TBytes;
var
  n, i: longword;
  b:    byte;
begin
  Result := nil;
  for n in integers do
    for i := (BitPosition(n shr 1) div 7) downto 0 do
    begin
      b := ((n shr (7 * i)) and %1111111) or (Ord(i <> 0) shl 7);
      insert(b, Result, length(Result));
    end;
end;

function decode(const bytes: TBytes): TLongWords;
var
  b: byte;
  c: longword = 0;
begin
  if (bytes[high(bytes)] and (1 shl 7)) <> 0 then
    raise Exception.Create('incomplete sequence');
  Result := nil;
  for b in bytes do
  begin
    c := (c shl 7) or (b and %1111111);
    if (b and (1 shl 7)) = 0 then
    begin
      insert(c, Result, length(Result));
      c := 0;
    end;
  end;
end;

end.
