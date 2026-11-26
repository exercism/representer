#[derive(Debug, PartialEq, Eq)]
pub struct CustomSet<T> {
    data: Vec<T>,
}

impl<T: PartialEq + Clone + Ord> CustomSet<T> {
    pub fn new(input: &[T]) -> Self {
        let mut data = input.to_vec();
        data.sort_unstable();
        data.dedup();
        CustomSet {
            data: data,
        }
    }

    pub fn contains(&self, element: &T) -> bool {
        if self.data.len() < 128 {
            self.data.iter().find(|x| **x == *element).is_some()
        } else {
            self.data.binary_search(element).is_ok()
        }
    }

    pub fn add(&mut self, element: T) {
        if let Err(index) = self.data.binary_search(&element) {
            self.data.insert(index, element);
        }
    }

    pub fn is_subset(&self, other: &Self) -> bool {
        if self.data.len() > other.data.len() {
            return false;
        } else if self.data.len() * 8 < other.data.len() {
            for elem in self.data.iter() {
                if let Err(_) = other.data.binary_search(&elem) {
                    return false;
                }
            }
        } else {
            let mut other = other.data.iter();
            'next_elem:
            for elem in self.data.iter() {
                while let Some(other_elem) = other.next() {
                    if elem == other_elem {
                        continue 'next_elem;
                    } else if elem >= other_elem {
                        return false;
                    }
                }
                return false;
            }   
        }
        true
    }

    pub fn is_empty(&self) -> bool {
        self.data.is_empty()
    }

    pub fn is_disjoint(&self, other: &Self) -> bool {
        let other_last = other.data.last();
        self.data.last().zip(other.data.first()).map(|(elem1, elem2)| elem1 < elem2).unwrap_or(true)
            && other.data.last().zip(self.data.first()).map(|(elem1, elem2)| elem1 < elem2).unwrap()
            || !self.data.iter().any(|elem| other.contains(elem))
    }

    #[must_use]
    pub fn intersection(&self, other: &Self) -> Self {
        Self {
           data: self.data.iter().filter(|elem| other.contains(elem)).cloned().collect(),
        }
    }

    #[must_use]
    pub fn difference(&self, other: &Self) -> Self {
        Self {
           data: self.data.iter().filter(|elem| !other.contains(elem)).cloned().collect(),
        }
    }

    #[must_use]
    pub fn union(&self, other: &Self) -> Self {
        let (bigger, smaller) = if self.data.len() < other.data.len() { 
            (other, self) 
        } else { 
            (self, other) 
        };
        let mut res = Self { data: bigger.data.clone(), };
        for elem in smaller.data.iter() {
            res.add(elem.clone());
        }
        res
    }
}
