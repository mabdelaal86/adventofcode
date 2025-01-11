use crate::map::*;

const DIRECTIONS: [Distance; 4] = [
    Distance::new(0, -1),
    Distance::new(-1, 0),
    Distance::new(1, 0),
    Distance::new(0, 1),
];

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let map = to_matrix(lines);

    map.find_all('0')
        .map(|loc| calc_score(loc, &map))
        .sum::<u32>()
}

fn calc_score(trailhead: ValidLocation, map: &Matrix<char>) -> u32 {
    let trails = find_trails(trailhead, 0, &map);
    trails.len() as u32
}

fn find_trails(loc: ValidLocation, val: u32, map: &Matrix<char>) -> Vec<ValidLocation> {
    if val == 9 {
        return vec![loc];
    }
    DIRECTIONS
        .map(|d| moved_by(loc, d))
        .iter()
        .filter_map(|l| map.validate_loc(&l))
        .filter_map(|l| {
            let v = map.at(&l).to_digit(10)?;
            Some((l, v))
        })
        .filter(|(_, v)| *v == val + 1)
        .map(|(l, v)| find_trails(l, v, map))
        .reduce(|mut acc, mut e| {
            acc.append(&mut e);
            acc
        })
        .unwrap_or(vec![])
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
        let lines = indoc::indoc! {"
            .....0.
            ..4321.
            ..5..2.
            ..6543.
            ..7..4.
            ..8765.
            ..9....
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 3);
    }

    #[test]
    fn test_example_2() {
        let lines = indoc::indoc! {"
            ..90..9
            ...1.98
            ...2..7
            6543456
            765.987
            876....
            987....
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 13);
    }

    #[test]
    fn test_example_3() {
        let lines = indoc::indoc! {"
            012345
            123456
            234567
            345678
            4.6789
            56789.
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 227);
    }

    #[test]
    fn test_example_4() {
        let lines = indoc::indoc! {"
            89010123
            78121874
            87430965
            96549874
            45678903
            32019012
            01329801
            10456732
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 81);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(10)), 875);
    }
}
