static NEIGBOURHOOD_OFFSETS: &'static [(i32, i32)] = &[
    (-1, -1), (0, -1), (1, -1),
    (-1,  0),          (1,  0),
    (-1,  1), (0,  1), (1,  1),
];
pub fn annotate(field: &[&str]) -> Vec<String> {
    let height = field.len() as i32;
    //取高度为y从0开始遍历
    (0..height).map(|y| {
        let width = field[y as usize].len() as i32;
        //取每一行为x从0开始遍历
        (0..width).map(|x| {
            //如果是雷直接返回雷标识
            if field[y as usize].as_bytes()[x as usize] == b'*' {
                '*'
            } else {
                //其它的进行匹配 按当前位置的周围8个位置进行匹配，用map获取到所有位置的坐标，然后过滤掉y坐标小于0大于高度的，过滤掉x坐标小于0大于宽度的
                //再过滤掉是雷的，然后统计数量
                match NEIGBOURHOOD_OFFSETS.iter()
                    .map(|&(ox, oy)| (x + ox, y + oy))
                    .filter(|&(x, y)| (0 <= x && x < width) && (0 <= y && y < height))
                    .filter(|&(x, y)| field[y as usize].as_bytes()[x as usize] == b'*')
                    .count() {
                    0 => ' ',
                    n => (n as u8 + '0' as u8) as char
                }
            }
        }).collect()
    }).collect()
}
