class CustomSet:
    def __init__(self, elements=[]):
        self.els = []
        for e in elements:
            if e not in self.els:
                self.els.append(e)

    def isempty(self):
        return len(self.els) == 0

    def __contains__(self, element):
        return element in self.els

    def issubset(self, other):
        for e in self.els:
            if e not in other:
                return False
        return True

    def isdisjoint(self, other):
        for e in self.els:
            if e in other:
                return False
        for e in other:
            if e in self.els:
                return False
        return True

    def __iter__(self):
        self.current = -1
        return self

    def __next__(self):
        if self.current < len(self.els) - 1:
            self.current += 1
            return self.els[self.current]
        raise StopIteration

    def __len__(self):
        return len(self.els)

    def __eq__(self, other):
        print('other', other)
        if other is None:
            return False
        if len(self.els) == 0 == len(other):
            return True
        if len(self.els) != len(other):
            return False
        for el in other:
            if el not in self.els:
                return False
        return True

    def add(self, element):
        if element not in self.els:
            self.els.append(element)

    def intersection(self, other):
        return CustomSet([e for e in self.els if e in other])

    def __sub__(self, other):
        if not len(self.els):
            return CustomSet()
        if not len(other):
            return CustomSet(self.els)
        return CustomSet([e for e in self.els if e not in other])

    def __add__(self, other):
        return CustomSet(self.els - [e for e in other if e not in self.els])
