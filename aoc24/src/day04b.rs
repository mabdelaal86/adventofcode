use crate::common;

pub fn main() {
    let res = process(common::read_file("data/day04.txt"));
    println!("res = {}", res);
}

const DIRECTIONS: [[(i32, i32); 2]; 2] = [
    [(-1, -1), (1, 1)], // left-up , right-down
    [(-1, 1), (1, -1)], // left-down , right-up
];

fn process(lines: impl Iterator<Item = String>) -> usize {
    let matrix = common::to_matrix(lines);

    matrix.indices().filter(|l| is_mas(&matrix, l)).count()
}

fn is_mas(data: &common::Matrix<char>, loc: &common::Location) -> bool {
    if *data.at(&loc) != 'A' {
        return false;
    }

    DIRECTIONS
        .iter()
        .map(|dir| get_ms(data, loc, dir))
        .all(|ms| ms == ['M', 'S'] || ms == ['S', 'M'])
}

fn get_ms(data: &common::Matrix<char>, loc: &common::Location, dir: &[(i32, i32); 2]) -> [char; 2] {
    dir.map(|(x, y)| {
        let Ok(l) = loc.moved_by(x, y) else {
            return '.';
        };
        if l.x >= data.cols() || l.y >= data.rows() {
            return '.';
        };
        *data.at(&l)
    })
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
        "}
        .lines()
        .map(|l| l.to_string());

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
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 9);
    }
}
