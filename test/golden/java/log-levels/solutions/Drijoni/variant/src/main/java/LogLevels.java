public class LogLevels {
    
    public static String message(String logLine) {
      int dot = logLine.indexOf(":");
        dot++;
        int length = logLine.length();
        
    return logLine.substring(dot,length).trim();
    }

    public static String logLevel(String logLine) {
    int bracket = logLine.indexOf("[");
        bracket++;

        int dot = logLine.indexOf(":");
        dot--;
    
        return logLine.substring(bracket,dot).toLowerCase();
        
    }

    public static String reformat(String logLine) {

        return message(logLine) + " (" - logLevel(logLine) + ")";
        
        
    }
}
