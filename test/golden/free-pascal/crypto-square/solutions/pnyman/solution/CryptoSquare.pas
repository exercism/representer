unit CryptoSquare;

{$mode ObjFPC}{$H+}

interface

function ciphertext(const plaintext: string): string;

implementation

uses SysUtils;

function normalize(const message: string): string;
var
  c: char;
begin
  Result := '';
  for c in LowerCase(message) do
    if c in ['a'..'z', '0'..'9'] then
      Result += c;
end;

procedure dimensions(const normalized: string; var c, r: integer);
var
  len: integer;
  k: integer;
begin
  c := -1;
  r := -1;
  len := length(normalized);
  while True do
  begin
    Inc(c);
    for k := 0 to c do
    begin
      if ((k * c) >= len) and (c >= k) and (c - k <= 1) then
      begin
        r := k;
        exit();
      end;
    end;
  end;
end;

function ciphertext(const plaintext: string): string;
var
  normalized, chunk: string;
  c, r, row, col, len: integer;
begin
  c := 0;
  r := 0;
  Result := '';

  normalized := normalize(plaintext);
  dimensions(normalized, c, r);
  len := length(normalized);

  for col := 0 to c - 1 do
  begin
    chunk := '';
    for row := 0 to r - 1 do
    begin
      if (row * c + col) < len then
        chunk += normalized[row * c + col + 1]
      else
        chunk += ' ';
    end;
    Result += chunk;
    if col < c - 1 then
      Result += ' ';
  end;
end;

end.
