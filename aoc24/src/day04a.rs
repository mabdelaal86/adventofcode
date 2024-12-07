use crate::common;

pub fn main() {
    let res = process(common::read_file("data/day04.txt"));
    println!("res = {}", res);
}

const DIRECTIONS: [(i32, i32); 8] = [
    (-1, -1),
    (0, -1),
    (1, -1),
    (-1, 0),
    (1, 0),
    (-1, 1),
    (0, 1),
    (1, 1),
];

const WORD: [char; 4] = ['X', 'M', 'A', 'S'];

fn process(lines: impl Iterator<Item = String>) -> u32 {
    let matrix = common::to_matrix(lines);

    matrix.indices().map(|l| count_word(&matrix, &l)).sum()
}

fn count_word(data: &common::Matrix<char>, loc: &common::Location) -> u32 {
    if data.at(loc) != &WORD[0] {
        return 0;
    }

    DIRECTIONS
        .iter()
        .map(|dir| (1..WORD.len()).all(|i| is_xmas(data, loc, i, dir)))
        .map(|b| b as u32)
        .sum()
}

fn is_xmas(
    data: &common::Matrix<char>,
    loc: &common::Location,
    i: usize,
    dir: &(i32, i32),
) -> bool {
    let Ok(loc) = loc.moved_by(dir.0 * i as i32, dir.1 * i as i32) else {
        return false;
    };

    Some(&WORD[i]) == data.get(&loc)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process1() {
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
    fn test_process2() {
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
}
