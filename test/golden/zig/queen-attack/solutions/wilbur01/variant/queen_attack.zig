pub const QueenError = error{ InitializationFailure, };

pub const Queen = struct {
    x: i8, y: i8,
    
    pub fn init(row: i8, col: i8) QueenError!Queen {
        return if (!(row >= 0 and row <= 7) or !(col >= 0 and col <= 7)) QueenError.InitializationFailure else Queen { .x = row, .y = col }; 
    }

    pub fn canAttack(self: Queen, other: Queen) QueenError!bool {
        return if (!(other.x >= 0 and other.x <= 7) and !(other.y >= 0 and other.y <= 7)) QueenError.InitializationFailure else ((self.x == other.x) or (self.y == other.y) or (@abs(self.x-other.x) == @abs(self.y-other.y)));
    }
};
