unit Yacht;

{$mode ObjFPC}{$H+}

interface

uses Generics.Collections;

type
  TDie      = 1..6;
  TDieArray = array of TDie;
  TDieSet   = set of TDie;
  TCategory = (kYacht, kOnes, kTwos, kThrees, kFours, kFives, kSixes,
    kFullHouse, kFourOfAKind, kLittleStraight, kBigStraight, kChoice);
  TDieArrayHelper = specialize TArrayHelper<TDieArray>;

function score(const category: TCategory; const dice: array of TDie): integer;

implementation

uses SysUtils;

function sort(const arr: TDieArray): TDieArray;
begin
  Result := arr;
  TDieArrayHelper.Sort(Result);
end;

function RemoveDuplicates(const arr: array of TDie): TDieArray;
var
  die: TDieSet;
  d:   TDie;
begin
  die    := [];
  Result := nil;
  for d in arr do include(die, d);
  for d in die do
    insert(d, Result, length(Result) + 1);
end;

function Count(const dice: array of TDie; const die: TDie): integer;
var
  d: TDie;
begin
  Result := 0;
  for d in dice do
    if d = die then
      Inc(Result);
end;

function equal(const dice: array of TDie; dices: TDieSet): boolean;
var
  d: TDie;
  uniques: TDieArray;
begin
  Result  := True;
  uniques := RemoveDuplicates(dice);
  if length(uniques) <> 5 then exit(False);
  for d in uniques do
    if not (d in dices) then
      exit(False);
end;

function score(const category: TCategory; const dice: array of TDie): integer;
var
  uniques: TDieArray;
  a, b: integer;
  d: TDie;
begin
  Result := 0;
  case category of
    kOnes, kTwos, kThrees, kFours, kFives, kSixes:
      Result := Count(dice, Ord(category)) * Ord(category);
    kFullHouse: begin
      uniques := sort(RemoveDuplicates(dice));
      a := Count(dice, uniques[0]);
      b := Count(dice, uniques[high(uniques)]);
      if ((a = 2) and (b = 3)) or ((a = 3) and (b = 2)) then
        for d in dice do Inc(Result, d);
    end;
    kFourOfAKind: for d in dice do
        if Count(dice, d) >= 4 then exit(d * 4);
    kLittleStraight: if equal(dice, [1..5]) then Result := 30;
    kBigStraight: if equal(dice, [2..6]) then Result := 30;
    kChoice: for d in dice do Inc(Result, d);
    kYacht: if length(RemoveDuplicates(dice)) = 1 then Result := 50;
  end;
end;

end.
