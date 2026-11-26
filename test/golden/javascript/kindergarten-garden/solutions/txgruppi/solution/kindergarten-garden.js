const DEFAULT_STUDENTS = [
  "Alice",
  "Bob",
  "Charlie",
  "David",
  "Eve",
  "Fred",
  "Ginny",
  "Harriet",
  "Ileana",
  "Joseph",
  "Kincaid",
  "Larry",
];

const PLANT_CODES = {
  G: "grass",
  V: "violets",
  R: "radishes",
  C: "clover",
};

export class Garden {
  constructor(diagram, students = DEFAULT_STUDENTS) {
    this._diagram = diagram.split("\n");
    this._students = students.sort();
  }

  plants(student) {
    const index = this._students.indexOf(student) * 2;
    const plants = [];
    for (let y = 0; y < 2; y++) {
      for (let x = 0; x < 2; x++) {
        plants.push(PLANT_CODES[this._diagram[y][index + x]]);
      }
    }
    return plants;
  }
}
