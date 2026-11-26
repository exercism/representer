proc two-fer {{name 3}} {
    if { $name == {Alice} || $name == {Bob} || $name == {Zaphod} } {  
        return "One gor $name, one for me."
    } else {
        return "One for you, one for me."
    }     
}


