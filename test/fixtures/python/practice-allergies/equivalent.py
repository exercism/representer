class placeholder_0:
    placeholder_1 = ['eggs', 'peanuts', 'shellfish', 'strawberries', 'tomatoes', 'chocolate', 'pollen', 'cats']

    def __init__(self, placeholder_3):
        self.placeholder_3 = placeholder_3

    def placeholder_4(self, placeholder_5):
        return bool(self.placeholder_3 & 1 << self.placeholder_1.index(placeholder_5))

    @property
    def placeholder_6(self):
        return [placeholder_7 for placeholder_7 in self.placeholder_1 if self.placeholder_4(placeholder_7)]
