random_name(Name) :-
  random_between(65, 90, L1),
  random_between(65, 90, L2),
  random_between(48, 57, D1),
  random_between(48, 57, D2),
  random_between(48, 58, D3),
  string_codes(Name, [L1, L2, D1, D2, D3]).

create_robot(robot(Name)) :- random_name(Name).

robot_name(robot(Name), Name).

reset_name(Robot) :- random_name(Name), setarg(1, Robot, Name).

