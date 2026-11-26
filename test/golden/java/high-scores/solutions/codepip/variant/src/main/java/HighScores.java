import java.util.List;
import java.util.ArrayList;
import java.util.*;

class HighScores {
    private List<Integer> highScores = new ArrayList<>();
    public HighScores(List<Integer> highScores) {
        this.highScores.addAll(highScores);
    }

    List<Integer> scores() {
        return highScores;
    }

    Integer latest() {
        return highScores.get(highScores.size()-1);
    }

    Integer personalBest() {
        List<Integer> sortedScore = new ArrayList<>();
        sortedScore.addAll(highScores);
        Collections.sort(sortedScore,Collections.reverseOrder());
        return sortedScore.get(0);
    }

    List<Integer> personalTopThree() {
        List<Integer> sortedScore = new ArrayList<>();
        sortedScore.addAll(highScores);
        Collections.sort(sortedScore,Collections.reverseOrder());
        return (highScores.size()<=3)?sortedScore:sortedScore.subList(0,3);
    }

}
