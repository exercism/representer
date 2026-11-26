unit ScrabbleScore;

{$mode ObjFPC}{$H+}

interface

function score(const word : string) : integer;

implementation

uses SysUtils;

function score(const word : string) : integer;
var
  i : integer;
begin
  result := 0;

  for i := low(word) to high(word) do
  begin
    case uppercase(word[i]) of
    'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' : result := result + 1;
    'D','G': result := result + 2;
    'B', 'C', 'M', 'P' : result := result + 3;
    'F', 'H', 'V', 'W', 'Y' : result := result + 4;
    'K' : result := result + 5;
    'J','X' : result := result + 8;
    'Q','Z' : result := result + 10;
    end;
  end;
end;

end.
