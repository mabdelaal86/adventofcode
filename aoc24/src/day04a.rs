use crate::common::*;

pub fn main() {
    let res = process(read_file("data/day04.txt"));
    println!("res = {}", res);
}

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

fn process(lines: impl Iterator<Item = String>) -> u32 {
    let matrix = to_matrix(lines);

    matrix.indices().map(|l| count_word(&matrix, &l)).sum()
}

fn count_word(data: &Matrix<char>, loc: &Location) -> u32 {
    if data.at(loc) != &WORD[0] {
        return 0;
    }

    DIRECTIONS
        .iter()
        .map(|dir| (1..WORD.len()).all(|i| is_xmas(data, loc, i, *dir)))
        .map(|b| b as u32)
        .sum()
}

fn is_xmas(data: &Matrix<char>, loc: &Location, i: usize, dir: Distance) -> bool {
    let Ok(loc) = loc.moved_by(dir * i as i32) else {
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
