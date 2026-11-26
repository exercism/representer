import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.ArrayList;

class Tournament {
private Map<String, Integer> matchesPlayed = new HashMap<>();
    private Map<String, Integer> matchesWon = new HashMap<>();
    private Map<String, Integer> matchesDrawn = new HashMap<>();
    private Map<String, Integer> points = new HashMap<>();
    String printTable() {
        StringBuilder res= new StringBuilder();
        res.append("Team                           | MP |  W |  D |  L |  P\n");
    Set<String> allTeams = new HashSet<>();
    allTeams.addAll(matchesPlayed.keySet());
    allTeams.addAll(matchesWon.keySet());
    allTeams.addAll(matchesDrawn.keySet());
    allTeams.addAll(points.keySet());

    List<String> sortedTeams = new ArrayList<>(allTeams);
    sortedTeams.sort((a, b) -> {
        int pA = points.getOrDefault(a, 0);
        int pB = points.getOrDefault(b, 0);
        if (pA != pB) return Integer.compare(pB, pA); // descending
        return a.compareTo(b); // alphabetical
    });

    for (String team : sortedTeams) {
        int played = matchesPlayed.getOrDefault(team, 0);
        int won = matchesWon.getOrDefault(team, 0);
        int drawn = matchesDrawn.getOrDefault(team, 0);
        int lost = played - won - drawn;
        int point = points.getOrDefault(team, 0);

        res.append(String.format("%-31s| %2d | %2d | %2d | %2d | %2d\n",
            team, played, won, drawn, lost, point));
    }

    return res.toString();
    }
    void applyResults(String resultString) {
        String[] separate = resultString.split("\n");
        String a;
        String b;
        String [] t;
        for (int i=0; i<separate.length;i++){
            t=separate[i].split(";");
            a=t[0];
            b=t[1];
            if (t[2].equals("win")){
                    matchesPlayed.put(a, matchesPlayed.getOrDefault(a, 0) + 1);
                    matchesWon.put(a, matchesWon.getOrDefault(a, 0) + 1);
                    points.put(a, points.getOrDefault(a, 0) + 3);
                    matchesPlayed.put(b, matchesPlayed.getOrDefault(b, 0) + 1);
            }
            else if (t[2].equals("loss")){
                    matchesPlayed.put(b, matchesPlayed.getOrDefault(b, 0) + 1);
                    matchesWon.put(b, matchesWon.getOrDefault(b, 0) + 1);
                    points.put(b, points.getOrDefault(b, 0) + 3);
                    matchesPlayed.put(a, matchesPlayed.getOrDefault(a, 0) + 1);
            }
            else{
                    matchesPlayed.put(a, matchesPlayed.getOrDefault(a, 0) + 1);
                    matchesDrawn.put(a, matchesDrawn.getOrDefault(a, 0) + 1);
                    points.put(a, points.getOrDefault(a, 0) + 1);
                    matchesPlayed.put(b, matchesPlayed.getOrDefault(b, 0) + 1);
                    matchesDrawn.put(b, matchesDrawn.getOrDefault(b, 0) + 1);
                    points.put(b, points.getOrDefault(b, 0) + 1);
            }
        }
    }
}
