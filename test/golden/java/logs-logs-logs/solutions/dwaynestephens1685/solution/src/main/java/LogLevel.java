public enum LogLevel {

    TRACE(1),
    DEBUG(2),
    INFO(4),
    WARNING(5),
    ERROR(6),
    FATAL(42),
    UNKNOWN(0);

    private final int encodedValue;

    // Constructor to assign encoded values to each log level
    LogLevel(int encodedValue) {
        this.encodedValue = encodedValue;
    }

    // Getter for encoded value
    public int getEncodedValue() {
        return encodedValue;
    }

    // Method to parse a string and return the corresponding LogLevel
    public static LogLevel fromString(String level) {
        switch (level) {
            case "TRC": return TRACE;
            case "DBG": return DEBUG;
            case "INF": return INFO;
            case "WRN": return WARNING;
            case "ERR": return ERROR;
            case "FTL": return FATAL;
            default: return UNKNOWN;
        }
    }
}
