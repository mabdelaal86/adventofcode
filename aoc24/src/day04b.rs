use crate::common;
use crate::common::Matrix;

pub const DIRECTIONS: [[(i32, i32); 2]; 2] = [
    [(-1, -1), (1,  1)], // left-up , right-down
    [(-1,  1), (1, -1)], // left-down , right-up
];

pub fn main() -> i32 {
    process(common::read_file("data/day04.txt"))
}

fn process(lines: impl IntoIterator<Item=String>) -> i32 {
    let matrix = common::to_matrix(lines);

    matrix.indices()
        .filter(|(r, c)| is_mas(&matrix, *r, *c))
        .count() as i32
}

fn is_mas(data: &Matrix<char>, r: usize, c: usize) -> bool {
    if *data.at(r, c) != 'A' {
        return false
    }

    DIRECTIONS.iter()
        .map(|dir| get_ms(data, r as i32, c as i32, dir))
        .all(|ms| ms == ['M', 'S'] || ms == ['S', 'M'])
}

fn get_ms(data: &Matrix<char>, r: i32, c: i32, dir: &[(i32, i32); 2]) -> [char; 2] {
    dir
        .map(|(x, y)| (r + y, c + x))
        .map(|(x, y)| *data.get(x as usize, y as usize).unwrap_or(&'.'))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process1() {
        let lines = indoc::indoc! {"
            M.S
            .A.
            M.S
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 1);
    }

    #[test]
    fn test_process2() {
        let lines = indoc::indoc! {"
            .M.S......
            ..A..MSMS.
            .M.S.MAA..
            ..A.ASMSM.
            .M.S.M....
            ..........
            S.S.S.S.S.
            .A.A.A.A..
            M.M.M.M.M.
            ..........
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 9);
    }
}
