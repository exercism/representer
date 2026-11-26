export class GradeSchool {
  private _roster: Map <number, string[]>;
  private _studentGrade: Map<string, number>;
  constructor() {
    this._roster = new Map();
    this._studentGrade = new Map();
  }
  roster(): Record<number, string[]> {
    const result: Record<number, string[]> = {};
    for (const [grade, students] of this._roster.entries()){
      result[grade] = [...students].sort();
    }
    return result;
  }

  add(name: string, grade: number): void {
    if(!this._roster.has(grade)){
      this._roster.set(grade, []);
    }
    this._roster.get(grade)!.push(name);
    this._studentGrade.set(name, grade);
  }

  grade(gradeNumber: number): string[] {
    if (!this._roster.has(gradeNumber)){
      return [];
    }
    const studentsInGrade = this._roster.get(gradeNumber)!;
    for (const student of studentsInGrade) {
      const registeredGrade = this._studentGrade.get(student);
      if (registeredGrade === gradeNumber) {
        return [];
      }
    }
    return [...studentsInGrade.sort()]
  }
}
