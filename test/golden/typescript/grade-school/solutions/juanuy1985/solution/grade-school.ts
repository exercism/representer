export class GradeSchool {
  private map: Map<string, Array<string>> = new Map<string, Array<string>>();
  private studentToGrade: Map<string, string> = new Map<string, string>();
  
  roster() {
    const entries = Array.from(this.map.entries())
        .map((entry) => [entry[0], [...entry[1]]]);
    return Object.fromEntries(entries);
  }

  add(name: string, grade: string) {
    const usedGrade = this.studentToGrade.get(name);
    if (usedGrade != grade && usedGrade != undefined) {
      const updatedList = (this.map.get(usedGrade) || [])
        .filter(element => element != name);
      this.map.set(usedGrade, updatedList);
      this.studentToGrade.delete(name);
    }
    const array = this.map.get(grade);
    if (array != undefined) {
      array.push(name);
      array.sort();
    } else {
      this.map.set(grade, [name]);
    }
    this.studentToGrade.set(name, grade);
  }

  grade(grade: string): Array<string> {
    const result = this.map.get(grade);
    if (result != undefined) {
      return [...result];
    }
    return [];
  }
}
