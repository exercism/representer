.input
| .desiredGrade as $grade
| .students | unique_by(first)
| map(select($grade == null or last == $grade))
| sort_by(last)
| map(first) 
