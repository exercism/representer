% create(+X, +Y, +Direction, -Robot)
create(X, Y, Direction, Robot) :-
	Robot = robot(coordinate(x(X), y(Y)), direction(Direction)).

% move(+Robot, +Instructions, -MovedRobot)
move(Robot, Instructions, MovedRobot) :-
	string_chars(Instructions, InstructionList),
	perform(InstructionList, Robot, MovedRobot).

% perform(+Instructions, +Robot, -MovedRobot)
perform([], Robot, Robot).
perform(['L'|Instructions], Robot, ResultRobot) :-
	turn('L', Robot, TurnedRobot),
	perform(Instructions, TurnedRobot, ResultRobot).
perform(['R'|Instructions], Robot, ResultRobot) :-
	turn('R', Robot, TurnedRobot),
	perform(Instructions, TurnedRobot, ResultRobot).
perform(['A'|Instructions], Robot, ResultRobot) :-
	advance(Robot, AdvancedRobot),
	perform(Instructions, AdvancedRobot, ResultRobot).

% turn(+Direction, +Robot, -TurnedRobot)
turn('L', robot(Coord, direction(north)), robot(Coord, direction(west))).
turn('L', robot(Coord, direction(west)),  robot(Coord, direction(south))).
turn('L', robot(Coord, direction(south)), robot(Coord, direction(east))).
turn('L', robot(Coord, direction(east)),  robot(Coord, direction(north))).
turn('R', robot(Coord, direction(north)), robot(Coord, direction(east))).
turn('R', robot(Coord, direction(east)),  robot(Coord, direction(south))).
turn('R', robot(Coord, direction(south)), robot(Coord, direction(west))).
turn('R', robot(Coord, direction(west)),  robot(Coord, direction(north))).

% advance(+Direction, +Robot, -AdvancedRobot)
advance(robot(coordinate(X,y(Y)), direction(north)),
	robot(coordinate(X,y(NewY)), direction(north))) :-
	NewY is Y + 1.
advance(robot(coordinate(X,y(Y)), direction(south)),
	robot(coordinate(X,y(NewY)), direction(south))) :-
	NewY is Y + 1.
advance(robot(coordinate(x(X),Y), direction(east)),
	robot(coordinate(x(NewX),Y), direction(east))) :-
	NewX is X + 1.
advance(robot(coordinate(x(X),Y), direction(west)),
	robot(coordinate(x(NewX),Y), direction(west))) :-
	NewX is X - 1.

