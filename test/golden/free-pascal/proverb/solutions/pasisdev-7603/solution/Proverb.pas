unit Proverb;

{$mode ObjFPC}{$H+}

interface

function recite(const strings : Array Of String) : string;

implementation

uses SysUtils, Classes;

function recite(const strings : Array Of String) : string;
var
  k : integer;
begin
  if length(strings) = 0 then
  begin
    result := '';
    exit;
  end;

  for k := length(strings) downto 1 do
  begin
    if k = 1 then
    begin
      result := result + 'And all for the want of a ' + strings[k-1] + '.';
    end
    else
    begin
      result := result + 'For want of a ' + strings[length(strings)-k] + ' the ' + strings[length(strings)-k+1] + ' was lost.' + #10;
    end;
  end;
end;

end.
