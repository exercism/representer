-module(robot_simulator).
-behavior(gen_server).
-export([advance/1, create/0, direction/1, left/1, place/3, position/1, right/1]).
-export([init/1, handle_cast/2, handle_call/3]).
init([]) -> {ok, {north, {0, 0}}}.
update_direction({_, Position}, Direction) ->
    {Direction, Position}.
update_y_position({Direction, {X, _}}, Y) ->
    {Direction, {X, Y}}.
update_x_position({Direction, {_, Y}}, X) ->
    {Direction, {X, Y}}.
handle_cast(right, {Direction, _} = Robot) ->
    NewRobot = case Direction of
        north -> update_direction(Robot, east);
        east -> update_direction(Robot, south);
        south -> update_direction(Robot, west);
        west -> update_direction(Robot, north)
    end,
    {noreply, NewRobot};
handle_cast(left, {Direction, _} = Robot) ->
    NewRobot = case Direction of
        north -> update_direction(Robot, west);
        east -> update_direction(Robot, north);
        south -> update_direction(Robot, east);
        west -> update_direction(Robot, south)
    end,
    {noreply, NewRobot};
handle_cast(advance, {Direction, {X, Y}} = Robot) ->
    NewRobot = case Direction of
        north -> update_y_position(Robot, Y + 1);
        east -> update_x_position(Robot, X + 1);
        south -> update_y_position(Robot, Y - 1);
        west -> update_x_position(Robot, X - 1)
    end,
    {noreply, NewRobot};
handle_cast(NewRobot, _Robot) ->
    {noreply, NewRobot}.
handle_call(direction, _From, {Direction, _} = Robot) ->
    {reply, Direction, Robot};
handle_call(position, _From, {_, Position} = Robot) ->
    {reply, Position, Robot};
handle_call(_, _From, Robot) ->
    {reply, Robot, Robot}.
advance(_Robot) -> gen_server:cast(_Robot, advance).
create() -> 
    {ok, Pid} = gen_server:start_link(?MODULE, [], []),
    Pid.
direction(_Robot) -> 
    gen_server:call(_Robot, direction).
left(_Robot) -> gen_server:cast(_Robot, left).
place(_Robot, Direction, Position) -> 
    gen_server:cast(_Robot, {Direction, Position}).
position(_Robot) -> 
    gen_server:call(_Robot, position).
right(_Robot) -> gen_server:cast(_Robot, right).