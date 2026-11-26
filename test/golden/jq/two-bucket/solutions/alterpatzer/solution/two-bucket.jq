def gcd:
    until(.[1] == 0; [.[1], .[0] % .[1]]) | .[0]
;

def stringify: map(tostring) | join(";");

def winner(goal): .contents | any(. == goal);

def fill1(capacity): [capacity[0], .contents[1]];

def fill2(capacity): [.contents[0], capacity[1]];

def empty1: [0, .contents[1]];

def empty2: [.contents[0], 0];

def move12(capacity):
   ([.contents[0], capacity[1] - .contents[1]] | min) as $delta |
   [.contents[0] - $delta, .contents[1] + $delta]
;

def move21(capacity):
    ([.contents[1], capacity[0] - .contents[0]] | min) as $delta |
    [.contents[0] + $delta, .contents[1] - $delta]
;

def extend(capacity):
    .seen as $seen |
    .move as $move |
    [fill1(capacity), fill2(capacity), empty1, empty2,
     move12(capacity), move21(capacity)] |
    map(select(stringify | in($seen) | not)) as $steps |
    ([($steps | .[] | {(. | stringify): ($move + 1)})] | add) as $newlyseen |
    $steps |
    map({contents: ., move: ($move + 1), seen: ($seen + $newlyseen)})
;

def search(goal; capacity):
    until (first | winner(goal); .[1:] + (first | extend(capacity))) | first
;

[.bucketOne, .bucketTwo] as $capacity |
($capacity | max) as $m |
($capacity | gcd) as $g |
.goal as $goal |
(if .startBucket == "one" then 0 else 1 end) as $start |
if $goal > $m or $goal % $g != 0 then
    "impossible" | halt_error
else
    [[$capacity[0], 0], [0, $capacity[1]]] as $initial |
    ([($initial | .[] | {(. | stringify): 1})] | add) as $seen |
    [{contents: $initial[$start], move: 1, seen: $seen}] |
    search($goal; $capacity) |
    if .contents[0] == $goal then
        {moves: .move, goalBucket: "one", otherBucket: .contents[1]}
    else
        {moves: .move, goalBucket: "two", otherBucket: .contents[0]}
    end
end
