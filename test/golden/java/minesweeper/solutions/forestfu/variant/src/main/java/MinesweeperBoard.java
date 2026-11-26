import java.util.List;

class MinesweeperBoard {
    private final List<String> board;
    MinesweeperBoard (List<String> board) {
        this.board = board;
    }
    public List<String> withNumbers() {
        if (board.size() == 0) {
            return board;
        }
        String[] boardArray = new String[board.size()];
        StringBuilder sb;
        for (int y = 0; y < board.size(); y++) {
            sb = new StringBuilder();
            for (int x = 0; x < board.get(0).length(); x++) {
                if (board.get(y).charAt(x) == '*') {
                    sb.append('*');
                } else {
                    int count = 0;
                    for (int i = y - 1; i <= y + 1; i++) {
                        for (int j = x - 1; j <= x + 1; j++) {
                            if (i > 0 && i < board.size() && j >= 0 && j < board.get(0).length()) {
                                if (board.get(i).charAt(j) == '*') {
                                    count++;
                                }
                            }
                        }
                    }
                    if (count == 0) {
                        sb.append(' ');
                    } else {
                        sb.append(count);
                    }
                }
            }
            boardArray[y] = sb.toString();
        }
        return List.of(boardArray);
    }
}