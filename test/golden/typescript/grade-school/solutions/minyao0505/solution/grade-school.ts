export class GradeSchool {
  private database: Record<number, string[]> = {};

  roster(): Record<number, string[]> {
    return JSON.parse(JSON.stringify(this.database));
  }

  add(name: string, grade: number): void {
    for (const currentGrade in this.database) {
      if (this.database[currentGrade].includes(name)) {
        const index = this.database[currentGrade].indexOf(name);
        this.database[currentGrade].splice(index, 1);
      }
    }
    if (this.database[grade]) {
      this.database[grade].push(name);
      this.database[grade].sort();
    } else {
      this.database[grade] = [name];
    }
  }

  grade(grade: number): string[] {
    return this.roster()[grade] || [];
  }
}
