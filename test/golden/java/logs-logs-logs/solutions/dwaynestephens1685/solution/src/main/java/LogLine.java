class LogLine {
    private final String logLine;

    public LogLine(String logLine) {
        this.logLine = logLine;
    }

    // Method to parse and return the log level as a LogLevel enum
    public LogLevel getLogLevel() {
        String levelCode = logLine.substring(1, 4);  // Extract the log level code
        return LogLevel.fromString(levelCode);       // Use enum to get the LogLevel
    }

    // Method to get the short log line format
    public String getOutputForShortLog() {
        LogLevel logLevel = getLogLevel();  // Get the parsed log level
        int encodedLevel = logLevel.getEncodedValue();  // Retrieve encoded value from the enum
        String message = logLine.substring(logLine.indexOf(":") + 2);  // Extract the message

        // Format the output as "[<ENCODED_LEVEL>]:<MESSAGE>"
        return String.format("%d:%s", encodedLevel, message);
    }
}
