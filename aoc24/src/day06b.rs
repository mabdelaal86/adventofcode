use std::collections::HashSet;
use std::num;

use crate::map::*;

pub fn process(lines: impl Iterator<Item = String>) -> usize {
    let mut map = to_matrix(lines);
    let start_loc = map.find('^').expect("No starting location found");
    let mut guard = Guard::new(start_loc, '^');

    let visited = visited_locations(&map, &mut guard);

    visited
        .iter()
        .filter(|l| can_make_loop(*l, &mut map))
        .count()
}

#[derive(Debug, PartialEq, Eq, Hash, Copy, Clone)]
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

        moved_by(self.location, d)
    }
}

fn move_guard(guard: &mut Guard, map: &Matrix<char>) -> bool {
    let Ok(new_loc) = guard.next_location() else {
        return false;
    };
    if new_loc.x >= map.cols() || new_loc.y >= map.rows() {
        return false;
    }

    if ['#', 'O'].contains(map.at(&new_loc)) {
        guard.turn_90();
    } else {
        guard.location = new_loc;
    }

    true
}

fn visited_locations(map: &Matrix<char>, mut guard: &mut Guard) -> HashSet<Location> {
    let mut visited: HashSet<Location> = HashSet::new();
    visited.insert(guard.location);

    while move_guard(&mut guard, &map) {
        visited.insert(guard.location);
    }

    visited
}

fn can_make_loop(loc: &Location, map: &mut Matrix<char>) -> bool {
    if *map.at(&loc) == '^' {
        return false;
    }

    map.replace(loc, 'O');
    let res = is_loop(map);
    map.replace(loc, '.');

    res
}

fn is_loop(map: &Matrix<char>) -> bool {
    let start_loc = map.find('^').expect("No starting location found");
    let mut guard = Guard::new(start_loc, '^');
    let mut visited: HashSet<Guard> = HashSet::new();
    visited.insert(guard);

    while move_guard(&mut guard, &map) {
        if visited.contains(&guard) {
            return true;
        }
        visited.insert(guard);
    }

    false
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

        assert_eq!(process(lines), 6);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(6)), 1721);
    }
}
