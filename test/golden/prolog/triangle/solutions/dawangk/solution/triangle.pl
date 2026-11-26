

valid(A, B, C) :- A+B >= C, A+C >= B, B+C >= A, A>0, B>0, C>0. 


t(A,A,A, "equilateral"):- !. 

t(A,A,_, "isosceles"):- !. 
t(_,A,A, "isosceles"):- !.  
t(A,_,A, "isosceles"):- !.  

t(A,B,C, "scalene"):-
    A \= B, B \= C, A \= C.
%d
triangle(Side1, Side2, Side3, Type) :- valid(Side1,Side2,Side3), t(Side1, Side2, Side3, Type). 