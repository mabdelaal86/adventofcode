use crate::map::*;

const DIRECTIONS: [Distance; 8] = [
    Distance::new(-1, -1),
    Distance::new(0, -1),
    Distance::new(1, -1),
    Distance::new(-1, 0),
    Distance::new(1, 0),
    Distance::new(-1, 1),
    Distance::new(0, 1),
    Distance::new(1, 1),
];

const WORD: [char; 4] = ['X', 'M', 'A', 'S'];

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let matrix = to_matrix(lines);

    matrix.indices().map(|l| count_word(&matrix, &l)).sum()
}

fn count_word(data: &Matrix<char>, loc: &ValidLocation) -> u32 {
    if data.at(loc) != &WORD[0] {
        return 0;
    }

    DIRECTIONS
        .iter()
        .map(|dir| (1..WORD.len()).all(|i| is_xmas(data, loc, i, *dir)))
        .map(|b| b as u32)
        .sum()
}

fn is_xmas(data: &Matrix<char>, loc: &ValidLocation, i: usize, dir: Distance) -> bool {
    let loc = moved_by(*loc, dir * i as i32);

    Some(&WORD[i]) == data.get(&loc)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
        let lines = indoc::indoc! {"
            ..X...
            .SAMX.
            .A..A.
            XMAS.S
            .X....
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 4);
    }

    #[test]
    fn test_example_2() {
        let lines = indoc::indoc! {"
            MMMSXXMASM
            MSAMXMSMSA
            AMXSXMAAMM
            MSAMASMSMX
            XMASAMXAMM
            XXAMMXXAMA
            SMSMSASXSS
            SAXAMASAAA
            MAMMMXMMMM
            MXMXAXMASX
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 18);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(4)), 2458);
    }
}
