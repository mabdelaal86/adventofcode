use crate::common;
use crate::common::Matrix;

pub const DIRECTIONS: [(i32, i32); 4] = [
    (-1, -1), (1, -1),
    (-1,  1), (1,  1),
];

const WORD: [char; 4] = ['X', 'M', 'A', 'S'];

pub fn main() -> i32 {
    process(common::read_file("data/day04.txt"))
}

fn process(lines: impl IntoIterator<Item=String>) -> i32 {
    let matrix = common::to_matrix(lines);

    matrix.indices()
        .map(|(r, c)| count_word(&matrix, r, c))
        .sum()
}

fn count_word(data: &Matrix<char>, r: usize, c: usize) -> i32 {
    if data.at(r, c) != &WORD[0] {
        return 0;
    }

    DIRECTIONS.iter()
        .map(|dir| {
            (1..WORD.len()).all(|i| is_xmas(data, r as i32, c as i32, i, dir))
        })
        .map(|b| b as i32)
        .sum()
}

fn is_xmas(data: &Matrix<char>, r: i32, c: i32, i: usize, dir: &(i32, i32)) -> bool {
    let nr = r + dir.1 * i as i32;
    let nc = c + dir.0 * i as i32;

    if nr < 0 || nr >= data.rows() as i32 || nc < 0 || nc >= data.cols() as i32 {
        false
    } else {
        data.at(nr as usize, nc as usize) == &WORD[i]
    }
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
        "}.lines().map(|l| l.to_string());

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
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 18);
    }
}
