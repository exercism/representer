import java.util.ArrayList;
import java.util.Arrays;

public class Transpose {
    public String transpose(String toTranspose) {
        String[] arr = toTranspose.split("\n");
        int max = 0;
        // padding dependent of future line lengths
        for (int i = arr.length - 1; i >= 0; i--) {
            max = Math.max(max, arr[i].length());
            if (max > 0)
                arr[i] = String.format("%-" + max + "s", arr[i]);
        }
        String[] out = new String[max];
        Arrays.fill(out, "");
        for (int i = 0; i < arr.length; i++) {
            for (int j = 0; j < arr[i].length(); j++) {
                out[j] += arr[i].substring(j, j + 1);
            }
        }
        return String.join("\n", new ArrayList<>(Arrays.asList(out)));
    }
}
