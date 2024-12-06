use std::collections::HashSet;
use crate::common;

struct Guard {
    location: common::Location,
    direction: char,
}

impl Guard {
    fn new(location: common::Location, direction: char) -> Self {
        Self { location, direction }
    }

    // fn next_loc(self) -> common::Location {
    //     let (dx, dy) = direction(self.direction);
    //     self.location.moved_by(dx, dy)
    // }

    fn turn_90(&mut self) {
        self.direction = match self.direction {
            '^' => '>',
            '>' => 'v',
            'v' => '<',
            '<' => '^',
            _ => panic!("Invalid direction"),
        }
    }
}

fn direction(c: char) -> (i32, i32) {
    match c {
        '^' => (0, -1),
        'v' => (0, 1),
        '<' => (-1, 0),
        '>' => (1, 0),
        _ => panic!("Invalid direction"),
    }
}

pub fn main() -> u32 {
    process(common::read_file("data/day06.txt"))
}

fn process(lines: impl Iterator<Item=String>) -> u32 {
    let map = common::to_matrix(lines);
    let start_loc = map.find('^').expect("No starting location found");
    let mut visited: HashSet<common::Location> = HashSet::new();
    visited.insert(start_loc);

    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let lines = indoc::indoc! {"
            ....#.....
            .........#
            ..........
            ..#.......
            .......#..
            ..........
            .#..^.....
            ........#.
            #.........
            ......#...
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 0); // 41
    }
}
