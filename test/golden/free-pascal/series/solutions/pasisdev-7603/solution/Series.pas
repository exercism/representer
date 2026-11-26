unit Series;

{$mode ObjFPC}{$H+}

interface

type
  TStrArray = Array Of String;

function slices(
  const series : String;
  const sliceLength : Integer
) : TStrArray;

implementation

uses SysUtils;

function slices(
  const series : String;
  const sliceLength : Integer
) : TStrArray;
var
  i,j : integer;
  s : string;
begin
  s := '';
  result := nil;
  i := 0;
  if length(series) = 0 then
  begin
    raise exception.create('series cannot be empty');
    exit;
  end;

  if length(series) < sliceLength then
  begin
    raise exception.create('slice length cannot be greater than series length');
    exit;
  end;

  if sliceLength = 0 then
  begin
    raise exception.create('slice length cannot be zero');
    exit;
  end;

  if sliceLength < 0 then
  begin
    raise exception.create('slice length cannot be negative');
    exit;
  end;
  
  while i + slicelength <= length(series) do
  begin
    for j := i+1 to (i + slicelength) do
    begin
      s := s + series[j];
    end;
    
    setlength(result,length(result)+1);
    result[high(result)] := s;
    s := '';
    i := i + 1;
  end;
  
end;

end.
