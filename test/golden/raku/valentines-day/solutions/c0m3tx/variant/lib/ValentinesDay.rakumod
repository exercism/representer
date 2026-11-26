unit module ValentinesDay;

enum Answer is export (Yes => True, No => False);

# You may use enums, subsets, classes, or roles as you see fit.
class  Chill       is export {}
enum   Restaurant  is export ('Korean','Turkish');
enum   Movie       is export ('Crime', 'Horror', 'Romance');
enum   Game        is export ('Chess', 'TicTacToe', 'GlobalThermonuclearWar');
subset Walk of Num is export where 0 < * <= Inf;

subset Activity is export where * ~~ any(Chill,Restaurant,Movie,Game,Walk);

multi rate-activity ( Chill --> Answer ) is export {
    No
}

multi rate-activity ( Restaurant $cuisine --> Answer ) is export {
    return Yes if $cuisine eq 'Korean';
    Answer
}

multi rate-activity ( Movie $genre --> Answer ) is export {
    return Yes if $genre == Romance;
    No
}

multi rate-activity ( Game $genre --> Answer ) is export {
    return Yes if $genre == Chess;
    No
}

multi rate-activity ( Walk $km --> Answer ) is export {
    return Yes if $km < 15;
    No
}