chatty(gustavo).
chatty(valeria).

likes(esteban, malena).
likes(malena, esteban).
likes(gustavo, valeria).

pairing(X,Y) :-
  chatty(X), !;
  chatty(Y), !;
  likes(X,Y), likes(Y,X), !.

seating(A,B,C,D,E) :-
  pairing(A,B),
  pairing(B,C),
  pairing(C,D),
  pairing(D,E).
