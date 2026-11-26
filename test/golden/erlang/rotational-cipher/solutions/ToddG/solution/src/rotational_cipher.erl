-module(rotational_cipher).

%% API
-export([test_version/0, encrypt/2, decrypt/2]).


test_version() ->
  1.

encrypt(Text, 0) ->
  Text;
encrypt(Text, 26) ->
  Text;
encrypt(Text, -26) ->
  Text;
encrypt(Text, Rotation) when Rotation > 0, Rotation < 26;Rotation < 0, Rotation > -26->
  [rotate(C, Rotation) || C <- Text];
encrypt(_, _) ->
  error.

% symmetric encrypt/decrypt, so just encrypt with negative Rotation
decrypt(T, R) ->
  encrypt(T, -R).

% upper case letter
rotate(Char, Rot) when Char >= 65, Char =< 90 ->
  charmod(Char, Rot, 65);
% lower case letter
rotate(Char, Rot) when Char >= 97, Char =< 122 ->
  charmod(Char, Rot, 97);
% non letters are unchanged
rotate(Char, _) ->
  Char.

charmod(Char, Rot, Shift) ->
  Index = Char - Shift,
  Index2 = mod(Index + Rot, 26),
  Index2 + Shift.

mod(X,Y) when X > 0 -> X rem Y;
mod(X,Y) when X < 0 -> Y + X rem Y;
mod(0,_) -> 0.