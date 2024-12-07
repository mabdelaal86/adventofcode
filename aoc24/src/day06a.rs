use std::collections::HashSet;
use std::num;

use crate::common;

pub fn main() -> u32 {
    process(common::read_file("data/day06.txt"))
}

fn process(lines: impl Iterator<Item = String>) -> u32 {
    let map = common::to_matrix(lines);
    let start_loc = map.find('^').expect("No starting location found");
    let mut guard = Guard::new(start_loc, '^');
    let mut visited: HashSet<common::Location> = HashSet::new();
    visited.insert(start_loc);

    while move_guard(&mut guard, &map) {
        visited.insert(guard.location);
    }

    visited.len() as u32
}

struct Guard {
    location: common::Location,
    direction: char,
}

impl Guard {
    fn new(location: common::Location, direction: char) -> Self {
        Self {
            location,
            direction,
        }
    }

    fn turn_90(&mut self) {
        self.direction = match self.direction {
            '^' => '>',
            '>' => 'v',
            'v' => '<',
            '<' => '^',
            _ => panic!("Invalid direction"),
        }
    }

    fn next_location(&self) -> Result<common::Location, num::TryFromIntError> {
        let (dx, dy) = match self.direction {
            '^' => (0, -1),
            'v' => (0, 1),
            '<' => (-1, 0),
            '>' => (1, 0),
            _ => panic!("Invalid direction"),
        };

        self.location.moved_by(dx, dy)
    }
}

fn move_guard(guard: &mut Guard, map: &common::Matrix<char>) -> bool {
    let Ok(new_loc) = guard.next_location() else {
        return false;
    };
    if new_loc.x >= map.cols() || new_loc.y >= map.rows() {
        return false;
    }

    if *map.at(&new_loc) == '#' {
        guard.turn_90();
    } else {
        guard.location = new_loc;
    }

    true
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
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 41);
    }
}
