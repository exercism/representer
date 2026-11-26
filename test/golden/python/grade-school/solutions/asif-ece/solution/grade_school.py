from collections import OrderedDict
class School:
    def __init__(self):
        self.students = OrderedDict()
        self.addition = []

    def add_student(self, name, grade):
        if name in self.students:
            self.addition.append(False)
        else:
            self.students[name] = grade
            self.addition.append(True)

    def roster(self):
        res = []
        keys = sorted(list(set(self.students.values())))
        print(keys)
        for i in keys:
            res.extend(sorted([k for k,v in self.students.items() if v == i]))
        print(res)
        return res

    def grade(self, grade_number):
        return sorted([k for k,v in self.students.items() if v == grade_number])

    def added(self):
        return self.addition
