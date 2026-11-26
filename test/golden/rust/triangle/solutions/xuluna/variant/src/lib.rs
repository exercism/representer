use std::ops::Add;

pub struct Triangle<T> {
    sides: [T; 3],
}

impl<T: Add<Output = T> + PartialOrd + Default + Copy> Triangle<T> {
    pub fn build(sides: [T; 3]) -> Option<Triangle<T>> {
        if sides.iter().any(|&s| s <= T::default()) {
            return None;
        }
        if sides[0] + sides[1] <= sides[2]
            || sides[1] + sides[2] <= sides[0]
            || sides[0] + sides[2] <= sides[1]
        {
            return None;
        }
        Some(Triangle { sides: sides })

        //unimplemented!("Construct new Triangle from following sides: {:?}. Return None if the sides are invalid.", sides);
    }

    pub fn is_equilateral(&self) -> bool {
        self.sides[0] == self.sides[1] && self.sides[1] == self.sides[2]
        //unimplemented!("Determine if the Triangle is equilateral.");
    }

    pub fn is_scalene(&self) -> bool {
        self.sides[0] != self.sides[1]
            && self.sides[1] != self.sides[2]
            && self.sides[0] != self.sides[2]
        //unimplemented!("Determine if the Triangle is scalene.");
    }

    pub fn is_isosceles(&self) -> bool {
        self.sides[0] != self.sides[1]
            || self.sides[1] == self.sides[2]
            || self.sides[0] == self.sides[2]
        //unimplemented!("Determine if the Triangle is isosceles.");
    }
}
