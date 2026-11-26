unit Sieve;

{$mode ObjFPC}{$H+}

interface

type
  TIntArray = array of integer;

function primes(const limit: integer): TIntArray;

implementation

uses SysUtils;

function primes(const limit: integer): TIntArray;
var
  sieve: array of boolean;
  i, k: integer;
begin
  sieve := nil;
  SetLength(sieve, limit + 1);
  for i := 2 to limit do
    sieve[i] := True;

  for i := 2 to limit do
    if sieve[i] = True then
    begin
      k := i * i;
      while k <= limit do
      begin
        sieve[k] := False;
        k += i;
      end;
    end;

  Result := nil;
  for i := 2 to limit do
    if sieve[i] = True then
    begin
      SetLength(Result, length(Result) + 1);
      Result[high(Result)] := i;
    end;
end;

end.
