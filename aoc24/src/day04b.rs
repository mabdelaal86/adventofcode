use crate::map::*;

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

pub fn process(lines: impl Iterator<Item = String>) -> usize {
    let matrix = to_matrix(lines);

    matrix.indices().filter(|l| is_mas(&matrix, l)).count()
}

fn is_mas(data: &Matrix<char>, loc: &ValidLocation) -> bool {
    if *data.at(&loc) != 'A' {
        return false;
    }

    DIRECTIONS
        .iter()
        .map(|dir| get_ms(data, loc, dir))
        .all(|ms| ms == ['M', 'S'] || ms == ['S', 'M'])
}

fn get_ms(data: &Matrix<char>, loc: &ValidLocation, dir: &[Distance; 2]) -> [char; 2] {
    dir.map(|d| {
        let l = moved_by(*loc, d);
        let Some(l) = data.validate_loc(&l) else {
            return '.';
        };
        *data.at(&l)
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
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
    fn test_example_2() {
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

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(4)), 1945);
    }
}
