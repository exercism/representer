["Alice","Bob","Charlie","David","Eve","Fred","Ginny","Harriet","Ileana","Joseph","Kincaid","Larry"] as $students
| {G: "grass", C: "clover", R: "radishes", V: "violets"} as $seeds
| .student as $student
| ($students | index($student) * 2) as $i
| .diagram / "\n"
| .[0][$i : $i+2] + .[1][$i : $i+2]
| . / ""
| map($seeds[.])