component {

    function twoFer(name) {
        if (not isDefined("arguments.name") or len(trim(arguments.name)) EQ 0) {
            return "One for you, one for me.";
        } else {
            return "One for #arguments.name#, one for me.";
        }
    }

}
