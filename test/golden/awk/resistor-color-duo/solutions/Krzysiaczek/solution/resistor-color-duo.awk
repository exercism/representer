{
split(tolower($0),s," ");
t["black"] = 0;
t["brown"] = 1;
t["red"] = 2;
t["orange"] = 3;
t["yellow"] = 4;
t["green"] = 5;
t["blue"] = 6;
t["violet"] = 7
t["grey"] = 8;
t["white"] = 9;

if ( !(s[1] in t) ){
print "invalid color";
exit 1;
}
n = t[s[1]] * 10 + t[s[2]];
print n;

}
