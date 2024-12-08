use std::collections::HashSet;
use std::num;

use crate::common::*;

pub fn main() {
    let res = process(read_file("data/day06.txt"));
    println!("res = {}", res);
}

fn process(lines: impl Iterator<Item = String>) -> usize {
    let map = to_matrix(lines);
    let start_loc = map.find('^').expect("No starting location found");
    let mut guard = Guard::new(start_loc, '^');
    let mut visited: HashSet<Location> = HashSet::new();
    visited.insert(guard.location);

    while move_guard(&mut guard, &map) {
        visited.insert(guard.location);
    }

    visited.len()
}

struct Guard {
    location: Location,
    direction: char,
}

impl Guard {
    fn new(location: Location, direction: char) -> Self {
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

    fn next_location(&self) -> Result<Location, num::TryFromIntError> {
        let d = match self.direction {
            '^' => Distance::new(0, -1),
            'v' => Distance::new(0, 1),
            '<' => Distance::new(-1, 0),
            '>' => Distance::new(1, 0),
            _ => panic!("Invalid direction"),
        };

        self.location.moved_by(d)
    }
}

fn move_guard(guard: &mut Guard, map: &Matrix<char>) -> bool {
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
