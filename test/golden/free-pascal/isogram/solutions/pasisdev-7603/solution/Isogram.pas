unit Isogram;

{$mode ObjFPC}{$H+}

interface

function IsIsogram(const phrase : string) : boolean;

implementation

uses SysUtils;

function IsIsogram(const phrase : string) : boolean;
var
  i,j,cnt : integer;
  s : string;
begin
  if length(phrase) = 0 then
  begin
    result := true;
    exit;
  end;

  s := phrase;
  s := stringreplace(s,'-','',[rfReplaceAll]);
  s := stringreplace(s,' ','',[rfReplaceAll]);
  s := lowercase(s);
  
  cnt := 0;
  
  for i := 1 to length(s) do
  begin
    cnt := 0;
    for j := 1 to length(s) do
    begin
      if s[i] = s[j] then
      begin
        cnt := cnt + 1;
      end;
      if cnt > 1 then
      begin
        result := false;
        exit;
      end;
    end;
  end;
  
  result := true;
  //raise ENotImplemented.Create('Please implement your solution.'); result := phrase <> phrase;

end;

end.
