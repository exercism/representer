pub const QueenError = error{
    InitializationFailure,
};

pub const Queen = struct {
    row: i8 = undefined,
    col: i8 = undefined,

    pub fn init(row: i8, col: i8) QueenError!Queen {
        if (!check(row, col)) {
            return QueenError.InitializationFailure;
        }
        return Queen{
            .row = row,
            .col = col,
        };
    }

    pub fn canAttack(self: Queen, other: Queen) QueenError!bool {
        if (!check(self.row, self.col)) {
            return QueenError.InitializationFailure;
        }
        if (!check(other.row, other.col)) {
            return QueenError.InitializationFailure;
        }
        if (self.row == other.row or self.col == other.col) {
            return true;
        }
        if (@abs(self.row - other.row) == @abs(self.col - other.col)) {
            return true;
        }
        return false;
    }
    fn check(row: i8, col: i8) bool {
        if (row > 7 or row < 0 or col > 7 or col < 0) {
            return false;
        }
        return true;
    }
};
