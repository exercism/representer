import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

class HighScores {

    private final List<Integer> scores;

    public HighScores(List<Integer> highScores) {
        scores = highScores;
    }

    List<Integer> scores() {
        return scores;
    }

    Integer latest() {
        return scores.get(scores.size() - 1);
    }

    Integer personalBest() {
        int max = 0;
        for (int score : scores) {
            if (score > max) {
                max = score;
            }
        }
        return max;
    }

    List<Integer> personalTopThree() {
        List<Integer> tops = new ArrayList<>(scores);
        Collections.sort(tops);
        Collections.reverse(tops);
        List<Integer> tmp = new ArrayList<>(3);
        int cpt = 0;
        while (cpt < 3 && !tops.isEmpty()) {
            tmp.add(tops.remove(0));
            cpt += 1;
        }
        return tmp;
    }

}
