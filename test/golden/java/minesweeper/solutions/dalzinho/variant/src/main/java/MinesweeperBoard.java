import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static java.util.Collections.emptyList;

public class MinesweeperBoard {

    private final List<List<String>> boardMatrixWithNumbers;

    public MinesweeperBoard(List<String> inputBoard) {
        List<List<String>> boardMatrix = parseMatrixFromInput(inputBoard);

        boardMatrixWithNumbers = boardMatrix.isEmpty() ? emptyList()
                : calculateNumbersFromEmptyMatrix(boardMatrix);
    }

    private List<List<String>> parseMatrixFromInput(List<String> inputBoard) {
        return inputBoard.stream()
                .map(string -> string.split(""))
                .map(Arrays::asList)
                .collect(Collectors.toList());
    }

    private List<List<String>> calculateNumbersFromEmptyMatrix(final List<List<String>> emptyMatrix) {
        return IntStream.range(0, emptyMatrix.size())
                .mapToObj(row -> processColumn(row, emptyMatrix))
                .collect(Collectors.toList());
    }

    private List<String> processColumn(final int row, final List<List<String>> matrix) {
        return IntStream.range(0, matrix.get(0).size())
                .mapToObj(column -> processSquare(row, column, matrix))
                .collect(Collectors.toList());
    }

    private String processSquare(int row, int column, List<List<String>> matrix) {
        return matrix.get(row).get(column).equals("*") ? "*" : getMineCount(row, column, matrix);
    }

    private String getMineCount(int row, int column, List<List<String>> matrix) {
        List<String> surroundingSquares = new ArrayList<>();
        updateSurroundingSquaresFor(row - 1, column + 1, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row - 1, column, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row - 1, column + 1, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row, column - 1, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row, column + 1, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row + 1, column - 1, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row + 1, column, matrix, surroundingSquares);
        updateSurroundingSquaresFor(row + 1, column + 1, matrix, surroundingSquares);

        long surroundingMineCount = surroundingSquares.stream().filter(s -> s.equals("*")).count();
        return surroundingMineCount > 0 ? String.valueOf(surroundingMineCount) : matrix.get(row).get(column);
    }

    private void updateSurroundingSquaresFor(int row, int column, List<List<String>> matrix, List<String> surroundingSquares) {
        try {
            String square = matrix.get(row).get(column);
            surroundingSquares.add(square);
        } catch (IndexOutOfBoundsException ignored) {
        }
    }

    public List<String> withNumbers() {
        return boardMatrixWithNumbers
                .stream()
                .map(list -> String.join("", list))
                .collect(Collectors.toList());
    }
}