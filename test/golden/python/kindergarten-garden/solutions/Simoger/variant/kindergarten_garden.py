default_names = ["Alice", "Bob", "Charlie", "David", "Eve", "Fred", "Ginny",
"Harriet", "Ileana", "Joseph", "Kincaid", "Larry"]
plant_names = {"G": "Grass","C": "Clover", "R": "Radishes", "V": "Violets"}

class Garden(object):
    
    def __init__(self, garden, students = default_names):
        self.students = sorted(students)
        self.garden = garden
        
    def plants(self, students):
        pos = self.students.index(students)
        garden_up = self.garden.split("\n")[0]
        garden_down = self.garden.split("\n")[1]
        student_plants = garden_up[pos*2:pos*2+2] + garden_down[pos/2:pos*2+2]
        return list(map(lambda x: plant_names[x],student_plants))