/// various log levels
#[derive(Drop)]
pub enum LogLevel {
    Info,
    Warning,
    Error,
    Debug
}

/// primary function for emitting logs
pub fn log(level: LogLevel, message: ByteArray) -> ByteArray {
    let mut s: ByteArray = match level {
        LogLevel::Error => "[ERROR]: ",
        LogLevel::Info => "[INFO]: ",
        LogLevel::Warning => "[WARNING]: ",
        LogLevel::Debug => "[DEBUG]: ",
    };
    s.append(@message);
    s
}

pub fn info(message: ByteArray) -> ByteArray {
    log(LogLevel::Info, message)
}

pub fn warn(message: ByteArray) -> ByteArray {
    log(LogLevel::Warning, message)
}

pub fn error(message: ByteArray) -> ByteArray {
    log(LogLevel::Error, message)
}
