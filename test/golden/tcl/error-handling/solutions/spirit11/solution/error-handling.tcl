proc custom_error_message {message} {
    throw error $message
}

proc handle_error {script} {
    set returnCode [catch {
        eval $script
    } result options] 
    if $returnCode {
        set errorCode [dict get $options "-errorcode"]
        switch -regexp -- $errorCode  {
            {ARITH DIVZERO} {
                set result "division by zero"
            }
            {POSIX ENOENT} {
                set result "file does not exist"
            }
            {TCL LOOKUP COMMAND} {
                set result "proc does not exist"
            }
        }
        return $result
    } else {
        return success
    }
}
