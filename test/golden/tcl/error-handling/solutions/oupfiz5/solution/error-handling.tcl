proc custom_error_message {message} {
    return -code error -level 0 -errorinfo info $message
}

proc handle_error {script} {
   # set returnCode [ catch { eval $script } result options ]
   # puts $returnCode
   # puts $options
   switch [ catch { eval $script } result options ] {
    0 { return -code ok -level 0 -errorinfo info "success"}
    1 { switch -glob [dict get $options -errorinfo] {
        divide* {return -code ok -level 0 -errorinfo info "division by zero"}
        couldn't* {return -code ok -level 0 -errorinfo info "file does not exist"}
        invalid* {return -code ok -level 0 -errorinfo info "proc does not exist"}
        couldn't* {return -code ok -level 0 -errorinfo info "file does not exist"}
        default { puts "other handling - ohoho [dict get $options -errorinfo]" }
        }
    }
    default { 
        puts "other handling" }
  }
}
