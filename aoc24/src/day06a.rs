use std::collections::HashSet;

use crate::map::*;

pub fn process(lines: impl Iterator<Item = String>) -> usize {
    let map = to_matrix(lines);
    let start_loc = map.find('^').expect("No starting location found");
    let mut guard = Guard::new(start_loc, '^');
    let mut visited: HashSet<ValidLocation> = HashSet::new();
    visited.insert(guard.location);

    while move_guard(&mut guard, &map) {
        visited.insert(guard.location);
    }

    visited.len()
}

struct Guard {
    location: ValidLocation,
    direction: char,
}

impl Guard {
    fn new(location: ValidLocation, direction: char) -> Self {
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

    fn next_location(&self) -> Location {
        let d = match self.direction {
            '^' => Distance::new(0, -1),
            'v' => Distance::new(0, 1),
            '<' => Distance::new(-1, 0),
            '>' => Distance::new(1, 0),
            _ => panic!("Invalid direction"),
        };

        moved_by(self.location, d)
    }
}

fn move_guard(guard: &mut Guard, map: &Matrix<char>) -> bool {
    let new_loc = guard.next_location();
    let Some(new_loc) = map.validate_loc(&new_loc) else {
        return false;
    };

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
    use crate::data::*;

    #[test]
    fn test_example() {
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

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(6)), 4826);
    }
}
