unit Etl;

{$mode ObjFPC}{$H+}

{$WARN 4046 OFF}
{$WARN 5024 OFF}
{$WARN 5062 OFF}
{$WARN 5071 OFF}
{$WARN 6058 OFF}

interface

uses Generics.Collections;

type
  TCharArray = array of char;
  TIntCharArrayDict = specialize TDictionary<integer, TCharArray>;
  TCharIntDict = specialize TDictionary<char, integer>;

function transform(const legacy: TIntCharArrayDict): TCharIntDict;

implementation

uses SysUtils;

function transform(const legacy: TIntCharArrayDict): TCharIntDict;
var
  kv: TIntCharArrayDict.TDictionaryPair;
  c: char;
begin
  Result := TCharIntDict.Create;
  for kv in legacy do
    for c in kv.Value do
      Result.AddOrSetValue(LowerCase(c), kv.key);
end;

end.
