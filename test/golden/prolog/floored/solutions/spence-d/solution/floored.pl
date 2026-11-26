floor_num(1).
floor_num(2).
floor_num(3).
floor_num(4).
floor_num(5).

floor(amara, Floor) :-
   floor_num(Floor),
   Floor < 5.
floor(bjorn, Floor) :-
   floor_num(Floor),
   Floor > 1.
floor(cora,  Floor) :-
   floor_num(Floor),
   Floor > 1,
   Floor < 5.
floor(dale,  Floor) :-
   floor_num(Floor),
   floor(bjorn, BjornFloor),
   floor_num(BjornFloor),
   Floor > BjornFloor.
floor(emiko,  Floor) :-
   floor_num(Floor),
   floor(cora, CoraFloor),
   floor_num(CoraFloor),
   Floor =\= CoraFloor + 1,
   Floor =\= CoraFloor - 1.
floor(cora,  Floor) :-
   floor_num(Floor),
   floor(bjorn, BjornFloor),
   floor_num(BjornFloor),
   Floor =\= BjornFloor + 1,
   Floor =\= BjornFloor - 1.