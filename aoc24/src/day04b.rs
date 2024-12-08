use crate::common::*;

pub fn main() {
    let res = process(read_file("data/day04.txt"));
    println!("res = {}", res);
}

const DIRECTIONS: [[Distance; 2]; 2] = [
    [
        Distance::new(-1, -1), // left-up
        Distance::new(1, 1),   // right-down
    ],
    [
        Distance::new(-1, 1), // left-down
        Distance::new(1, -1), // right-up
    ],
];

fn process(lines: impl Iterator<Item = String>) -> usize {
    let matrix = to_matrix(lines);

    matrix.indices().filter(|l| is_mas(&matrix, l)).count()
}

fn is_mas(data: &Matrix<char>, loc: &Location) -> bool {
    if *data.at(&loc) != 'A' {
        return false;
    }

    DIRECTIONS
        .iter()
        .map(|dir| get_ms(data, loc, dir))
        .all(|ms| ms == ['M', 'S'] || ms == ['S', 'M'])
}

fn get_ms(data: &Matrix<char>, loc: &Location, dir: &[Distance; 2]) -> [char; 2] {
    dir.map(|d| {
        let Ok(l) = loc.moved_by(d) else {
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
