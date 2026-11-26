import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class KindergartenGarden {

    private String[] students = { "Alice", "Bob", "Charlie", "David", "Eve",
        "Fred", "Ginny", "Harriet", "Ileana", "Joseph", "Kincaid", "Larry" };
    char[][] studentsGarden = new char[12][4];

    KindergartenGarden(String garden, String[] students) {

    }

    KindergartenGarden(String garden) {
        String row1 = "";
        String row2 = "";

        Pattern r = Pattern.compile("(.*)\n(.*)");
        Matcher m = r.matcher(garden);
        m.find();
        row1 = m.group(1);
        row2 = m.group(2);

        int j = 0;
        for (int i = 0; i < row1.length(); i = i + 2) {
            char c = row1.charAt(i);
            studentsGarden[j][0] = c;
            c = row1.charAt(i+1);
            studentsGarden[j][1] = c;
            c = row2.charAt(i);
            studentsGarden[j][2] = c;
            c = row2.charAt(i+1);
            studentsGarden[j][3] = c;
            j++;
        }
    }

    List<Plant> getPlantsOfStudent(String student) {
        int i = 0;
        String s = "";
        while (s != student) {
            s = students[i];
            i++;
        }
        List<Plant> plants = new ArrayList<>();
        for (char c : studentsGarden[i-1]) {
            plants.add(Plant.getPlant(c));
        }

        return plants;
    }

}