pub fn spiral_matrix(size: u32) -> Vec<Vec<u32>> {
    let mut list = vec![vec![0; size as usize]; size as usize];
    let mut count = 1;
    let mut x = 0;
    let mut y = 0;
    let mut direction = (1,0);
    while count <= size*size {
        list[y as usize][x as usize] = count;
        count += 1;
        (x,y) = (x + direction.0,y + direction.1);
        if x < 0 || x == size as i32 || y == size as i32 || list[y as usize][x as usize] > 0 {
            (x,y) = (x - direction.0,y - direction.1);
            direction = (-direction.1,direction.0);
            (x,y) = (x + direction.0,y + direction.1);
        }
    }
    list
}
