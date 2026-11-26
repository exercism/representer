extension on DateTime {
  String toYYYYMMDDString() {
    String y = this.year.toString();
    String m = ((this.month>9) ? "":"0") + month.toString();
    String d = ((this.day>9) ? "":"0") + day.toString();
    return "$y-$m-$d";
  }
}

class Meetup {
  String meetup({required int year, required int month, required String week, required String dayofweek}) {
    
    Map<String,int> weekdays = {"Monday": DateTime.monday, "Tuesday": DateTime.tuesday, "Wednesday": DateTime.wednesday, "Thursday": DateTime.thursday, "Friday": DateTime.friday, "Saturday": DateTime.saturday, "Sunday": DateTime.sunday};
    
    DateTime dt = DateTime(year, month, 1);

    final int weekDay = weekdays[dayofweek]!;

    int numFound = 0;
    DateTime? lastFound;
    
    while(dt.month == month) {
      if(dt.weekday == weekDay) {
        // found weekday sought
        lastFound = dt;
        numFound++;
        if( (week=="first" && numFound==1) || (week=="second" && numFound==2) || (week=="third" && numFound==3) || (week=="fourth" && numFound==4) || (week == "teenth" && dt.day>=13 && dt.day<=19) ) {
          return dt.toYYYYMMDDString();
        } 
      }
      dt = dt.add(const Duration(days: 1));
    }
    if(week == "last" && lastFound != null) {
      return lastFound.toYYYYMMDDString();
    }
  return "";
  }
}