use crate::map::*;
use std::collections::HashMap;

const PREV_DIRECTIONS: [Distance; 2] = [Distance::new(0, -1), Distance::new(-1, 0)];

const DIRECTIONS: [Distance; 4] = [
    Distance::new(0, -1),
    Distance::new(-1, 0),
    Distance::new(1, 0),
    Distance::new(0, 1),
];

struct Plot {
    x: usize,
    y: usize,
    value: char,
    sides: i32,
}

struct Region {
    plot_params: Vec<i32>,
    value: char,
}

impl Region {
    fn new(value: char) -> Self {
        Self {
            plot_params: vec![],
            value,
        }
    }
}

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let map = to_matrix(lines);
    let mut regions: Vec<Region> = vec![];
    let mut plots: HashMap<ValidLocation, &Region> = HashMap::new();
    for (loc, ch) in map.iter() {
        let region: &Region = get_region(loc, ch, &map, &mut regions, &mut plots);
    }

    0
}

fn get_region<'s>(
    loc: ValidLocation,
    ch: &char,
    map: &Matrix<char>,
    regions: &'s mut Vec<Region>,
    plots: &'s mut HashMap<ValidLocation, &Region>,
) -> &'s Region {
    for dir in PREV_DIRECTIONS.iter() {
        // get top or left plot
        let side = moved_by(loc, *dir);
        let Some(side) = map.validate_loc(&side) else {
            continue;
        };
        let Some(region) = plots.get(&side) else {
            continue;
        };
        if region.value == *ch {
            return *region;
        }
    }
    regions.push(Region::new(*ch));
    regions.last().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
        let lines = indoc::indoc! {"
            AAAA
            BBCD
            BBCC
            EEEC
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 4*10 + 4*8 + 4*10 + 1*4 + 3*8);
    }

    #[test]
    fn test_example_2() {
        let lines = indoc::indoc! {"
            OOOOO
            OXOXO
            OOOOO
            OXOXO
            OOOOO
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 772);
    }

    #[test]
    fn test_example_3() {
        let lines = indoc::indoc! {"
            RRRRIICCFF
            RRRRIICCCF
            VVRRRCCFFF
            VVRCCCJFFF
            VVVVCJJCFE
            VVIVCCJJEE
            VVIIICJJEE
            MIIIIIJJEE
            MIIISIJEEE
            MMMISSJEEE
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 1930);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(12)), 0);
    }
}
