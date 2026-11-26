unit PhoneNumber;

{$mode ObjFPC}{$H+}

interface

function clean(const phrase : string) : string;

implementation

uses SysUtils;

type
  allowedT = set of char;
  numT = set of char;

function clean(const phrase : string) : string;
var
  I : integer;
  str : string;
  allowed : allowedT;
  num : numT;
begin
  result := '';
  str := '';

  allowed := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9','-', ' ', '.', '(', ')', '+'];

  num := ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  for I := low(phrase) to high(phrase) do
  begin
    if not (phrase[I] in allowed) then
    begin
      if phrase[I] in ['a'..'z', 'A'..'Z'] then
      begin
        raise Exception.Create('letters not permitted');
        exit;
      end
      else
      begin
        raise Exception.Create('punctuations not permitted');
        exit;
      end;
    end;
  end;

  for I := (Low(phrase) + 1) to high(phrase) do
  begin
    if phrase[I] = '+' then
    begin
      raise Exception.Create('punctuations not permitted');
      exit;
    end;
  end;

  for I := low(phrase) to high(phrase) do
  begin
    if phrase[I] in num then
      str := str + phrase[I];
  end;

  if (length(str) <> 11) and (length(str) <> 10) then
  begin
    if length(str) < 10 then
    begin
      raise Exception.Create('must not be fewer than 10 digits');
      exit;
    end
    else
    begin
      raise Exception.Create('must not be greater than 11 digits');
      exit;
    end
  end;

  if length(str) = 11 then
  begin
    if str[1] <> '1' then
    begin
      raise Exception.Create('11 digits must start with 1');
      exit;
    end;

    if (str[2] = '0') or (str[2] = '1') or (str[5] = '0') or (str[5] = '1') then
    begin
      if str[2] = '0' then
        raise Exception.Create('area code cannot start with zero')
    
      else if str[2] = '1' then
        raise Exception.Create('area code cannot start with one')
    
      else if str[5] = '0' then
        raise Exception.Create('exchange code cannot start with zero')
    
      else
        raise Exception.Create('exchange code cannot start with one');

      exit;
    end;

    for I := (low(str) + 1) to high(str) do
    begin
      result := result + str[I];
    end;
  end;

  if length(str) = 10 then
  begin
    if (str[1] = '0') or (str[1] = '1') or (str[4] = '0') or (str[4] = '1') then
    begin
    if str[1] = '0' then
      raise Exception.Create('area code cannot start with zero')
    
    else if str[1] = '1' then
      raise Exception.Create('area code cannot start with one')
    
    else if str[4] = '0' then
      raise Exception.Create('exchange code cannot start with zero')
    
    else
      raise Exception.Create('exchange code cannot start with one');

    exit;
  end;

      result := str;
  end;
end;
  //raise ENotImplemented.Create('Please implement your solution.'); result := phrase;

end.
