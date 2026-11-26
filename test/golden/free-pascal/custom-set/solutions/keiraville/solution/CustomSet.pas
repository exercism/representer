unit CustomSet;

{$mode ObjFPC}{$H+}

interface

type
  TIntArray = Array Of Integer;

function empty(const ASet : TIntArray) : boolean;
function contains(const ASet : TIntArray; const element : integer) : boolean;
function subset(const ASetOne, ASetTwo : TIntArray) : boolean;
function disjoint(const ASetOne, ASetTwo : TIntArray) : boolean;
function equal(const ASetOne, ASetTwo : TIntArray) : boolean;
function add(const ASet : TIntArray; const element : integer) : TIntArray;
function intersection(const ASetOne, ASetTwo: TIntArray) : TIntArray;
function difference(const ASetOne, ASetTwo: TIntArray) : TIntArray;
function union(const ASetOne, ASetTwo : TIntArray) : TIntArray;

implementation

uses SysUtils, Generics.Collections;

type
  TIntArrayHelper = Specialize TArrayHelper<Integer>;

function empty(const ASet : TIntArray) : boolean;
begin
  result := (Length(ASet) = 0);
end;

function contains(const ASet : TIntArray; const element : integer) : boolean;
var
  entry : Integer;
begin
  for entry in ASet do
    if entry = element then
      exit(true);

  result := false;
end;

function subset(const ASetOne, ASetTwo : TIntArray) : boolean;
var
  entry : Integer;
begin
  for entry in ASetOne do
    if not contains(ASetTwo, entry) then
      exit(false);

  result := true;
end;

function disjoint(const ASetOne, ASetTwo : TIntArray) : boolean;
var
  entry : Integer;
begin
  for entry in ASetOne do
    if contains(ASetTwo, entry) then
      exit(false);

  result := true;
end;

function equal(const ASetOne, ASetTwo : TIntArray) : boolean;
begin
  result := subset(ASetOne, ASetTwo) and subset(ASetTwo, ASetOne);
end;

function add(const ASet : TIntArray; const element : integer) : TIntArray;
begin
  result := Copy(ASet);
  if not contains(ASet, element) then
    Insert(element, result, Length(result));

  TIntArrayHelper.Sort(result);
end;

function intersection(const ASetOne, ASetTwo: TIntArray) : TIntArray;
var
  entry : Integer;
begin
  result := nil;
  for entry in ASetOne do
    if contains(ASetTwo, entry) then
      Insert(entry, result, Length(result));

  TIntArrayHelper.Sort(result);
end;

function difference(const ASetOne, ASetTwo: TIntArray) : TIntArray;
var
  entry : Integer;
begin
  result := nil;
  for entry in ASetOne do
    if not contains(ASetTwo, entry) then
      Insert(entry, result, Length(result));

  TIntArrayHelper.Sort(result);
end;

function union(const ASetOne, ASetTwo : TIntArray) : TIntArray;
var
  entry : Integer;
begin
  result := Copy(ASetTwo);

  for entry in ASetOne do
    if not contains(ASetTwo, entry) then
      Insert(entry, result, Length(result));

  TIntArrayHelper.Sort(result);
end;

end.
