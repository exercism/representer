proc custom_error_message {message} {
    return -code error $message
}

proc handle_error {script} {
    if {[catch $script err]} {
        switch -glob -- $err {
            "divide by zero"             { return "division by zero" }
            "*no such file or directory" { return "file does not exist" }
            "invalid command name*"      { return "proc does not exist" }
            default                      { return "unknown error" }
        }
    }
    return "success"
}

        

          
