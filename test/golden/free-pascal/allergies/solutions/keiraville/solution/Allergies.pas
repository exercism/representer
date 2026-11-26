unit Allergies;

{$mode ObjFPC}{$H+}

interface

type
  TStrArray = Array Of String;

function list(const score : integer) : TStrArray;
function AllergicTo(const item : string; const score : integer) : boolean;

implementation

uses SysUtils;

function list(const score : integer) : TStrArray;
begin
  result := [];
  if score and 1 <> 0 then
    insert('eggs', result, length(result));
  if score and 2 <> 0 then
    insert('peanuts', result, length(result));
  if score and 4 <> 0 then
    insert('shellfish', result, length(result));
  if score and 8 <> 0 then
    insert('strawberries', result, length(result));
  if score and 16 <> 0 then
    insert('tomatoes', result, length(result));
  if score and 32 <> 0 then
    insert('chocolate', result, length(result));
  if score and 64 <> 0 then
    insert('pollen', result, length(result));
  if score and 128 <> 0 then
    insert('cats', result, length(result));
end;

function AllergicTo(const item : string; const score : integer) : boolean;
begin
  case item of
    'eggs': result := (score and 1) <> 0;
    'peanuts': result := (score and 2) <> 0;
    'shellfish': result := (score and 4) <> 0;
    'strawberries': result := (score and 8) <> 0;
    'tomatoes': result := (score and 16) <> 0;
    'chocolate': result := (score and 32) <> 0;
    'pollen': result := (score and 64) <> 0;
    'cats': result := (score and 128) <> 0;
  else
    result := false;
  end;
end;

end.
