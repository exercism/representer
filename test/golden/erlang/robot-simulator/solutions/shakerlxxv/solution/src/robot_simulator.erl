-module(robot_simulator).
-behaviour(gen_server).

-export([advance/1, control/2, create/0, direction/1, left/1, right/1, place/3, position/1, test_version/0]).

-export([init/1, handle_call/3, handle_cast/2]).

advance(Robot) ->
    gen_server:cast(Robot,advance),
    Robot.

control(Robot, []) ->
    Robot;
control(Robot,[N|R]) ->
    control(case N of
        $A -> advance(Robot);
        $R -> right(Robot);
        $L -> left(Robot);
        _X -> Robot % unknown commands are ignored
    end,R).

% use gen_server to manage the robot
create() ->
    {ok, RobotPid} = gen_server:start_link(robot_simulator,[],[]),
    RobotPid.

direction(Robot) ->
    gen_server:call(Robot,direction).

left(Robot) ->
    gen_server:cast(Robot,left),
    Robot.

right(Robot) ->
    gen_server:cast(Robot,right),
    Robot.

place(Robot, Direction, Position) ->
    gen_server:cast(Robot,{place,Direction,Position}),
    Robot.

position(Robot) ->
    gen_server:call(Robot,position).

test_version() -> 1.

%-------------------------------------------------------------------------------
% gen_server callbacks
init([]) ->
    % return the Robot initial state as undefined
    {ok,{undefined, {undefined,undefined}}}.

handle_call(direction,_From,{Direction,_Position}=State) ->
    {reply,Direction,State};
handle_call(position,_From,{_Direction,Position}=State) ->
    {reply,Position,State}.

handle_cast({place,NewDirection,NewPosition},_State) ->
    {noreply,{NewDirection,NewPosition}};
handle_cast(left,{Direction,Position}) ->
    NewDirection = turn_left(Direction),
    {noreply,{NewDirection,Position}};
handle_cast(right,{Direction,Position}) ->
    NewDirection = turn_right(Direction),
    {noreply,{NewDirection,Position}};
handle_cast(advance,{Direction,{PosX,PosY}}) ->
    NewState = advance_position(Direction,{PosX,PosY}),
    {noreply,NewState}.

%-------------------------------------------------------------------------------
% below here is all the "server" for the Robot process

turn_left(Direction) ->
    case Direction of
        north -> west;
        south -> east;
        east -> north;
        west -> south
    end.

turn_right(Direction) ->
    case Direction of
        north -> east;
        south -> west;
        east -> south;
        west -> north
    end.

advance_position(Direction,{PosX,PosY}) ->
    case Direction of
        north -> {Direction,{PosX,PosY+1}};
        south -> {Direction,{PosX,PosY-1}};
        east -> {Direction,{PosX+1,PosY}};
        west -> {Direction,{PosX-1,PosY}}
    end.