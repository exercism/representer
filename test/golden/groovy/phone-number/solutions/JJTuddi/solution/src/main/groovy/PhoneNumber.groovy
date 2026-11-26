import java.util.regex.Pattern;
import java.util.regex.Matcher;

class PhoneNumber {
    static Pattern pattern = Pattern.compile(/[.\s()+-]+/);
    
    static String clean(String input) {
          String replaced = Pattern.compile(/[.+()\s-]+/).matcher(input).replaceAll("");
          Matcher matcher = Pattern.compile(/([2-9]\d{2,}[2-9]\d{6,})/).matcher(replaced);
          if (matcher.find()) {
            def result = matcher.group(0);
            if (result.length() != 10) {
              throw new Exception();
            }
            return result;
          } else {
            throw new Exception()
          }
    }

}
