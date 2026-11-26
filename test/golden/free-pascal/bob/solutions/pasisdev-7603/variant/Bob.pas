unit Bob;

{$mode ObjFPC}{$H+}

interface

function response(const HeyBob: string) : string;

implementation

uses SysUtils;

function response(const HeyBob: string) : string;
var
  lowerset : set of char = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
  upperset : set of char = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
  question,lowercase,uppercase : boolean;
  i : integer;
begin
question := false;
lowercase := false;
uppercase :=  false;
  if trim(HeyBob) = '' then
  begin
    result := 'Fine. Be that way!';
    exit;
  end;

  for i := 1 to length(HeyBob) do
  begin
    if HeyBob[i] in lowerset then
    begin
      lowercase := true;
    end;
    if HeyBob[i] in upperset then
    begin
      uppercase := true;
    end;
  end;

  if (HeyBob[length(trim(HeyBob))] = '?') or (HeyBob[length(HeyBob)] = '?') then
  begin
    question := true;
  end;

  if (not(lowercase) and uppercase) or question then
  begin
    result := 'Calm down, I know what I''m doing!';
    exit;
  end;

  if not(lowercase) and uppercase then
  begin
    result := 'Whoa, chill out!';
    exit;
  end;

  if question then 
  begin
    result := 'Sure.';
    exit;
  end;
  
  result := 'Whatever.';
end;

end.
