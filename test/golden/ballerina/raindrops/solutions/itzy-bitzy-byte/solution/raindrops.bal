public function convert(int n) returns string {
    string sound = "";
    if (n % 3 == 0){
        sound += "Pling";
    }
    if (n % 5 == 0){
        sound += "Plang";
    }
    if (n % 7 == 0){
        sound += "Plong";
    }

    return sound.length() != 0 ? sound : n.toString();
}
