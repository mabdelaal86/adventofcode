use std::collections::{HashMap, HashSet};

use crate::map::*;

struct Map {
    frequencies: HashMap<char, Vec<ValidLocation>>,
    cols: usize,
    rows: usize,
}

impl MapTrait for Map {
    fn rows(&self) -> usize { self.rows }
    fn cols(&self) -> usize { self.cols }
}

pub fn process(lines: impl Iterator<Item = String>) -> usize {
    let map = collect_data(lines);
    let antinodes = get_antinodes(&map);

    antinodes
        .iter()
        .count()
}

fn collect_data(lines: impl Iterator<Item = String>) -> Map {
    let mut frequencies: HashMap<char, Vec<ValidLocation>> = HashMap::new();

    let mut row = 0;
    let mut cols = 0;
    for line in lines {
        line.chars()
            .enumerate()
            .filter(|(_, c)| *c != '.')
            .for_each(|(i, c)| {
                if !frequencies.contains_key(&c) {
                    frequencies.insert(c, vec![]);
                }
                frequencies.get_mut(&c).unwrap().push(ValidLocation::new(i, row));
            });

        row += 1;
        cols = line.len();
    }

    Map {
        frequencies,
        cols,
        rows: row,
    }
}

fn get_antinodes(map: &Map) -> HashSet<ValidLocation> {
    let mut antinodes: HashSet<ValidLocation> = HashSet::new();
    for frequency in map.frequencies.values() {
        antinodes.extend(frequency);
        for i in 0..frequency.len() {
            for j in i + 1..frequency.len() {
                get_antinode(frequency[i], frequency[j], map)
                    .iter()
                    .for_each(|loc| {
                        antinodes.insert(*loc);
                    });
            }
        }
    }
    antinodes
}

fn get_antinode(freq1: ValidLocation, freq2: ValidLocation, map: &Map) -> Vec<ValidLocation> {
    let mut res: Vec<ValidLocation> = Vec::new();

    let dis = freq2.to_i32() - freq1.to_i32();

    let mut i = 1;
    loop {
        let l = moved_by(freq1, dis * -i);
        let Some(l) = map.validate_loc(&l) else {
            break;
        };
        res.push(l);
        i += 1;
    }

    i = 1;
    loop {
        let l = moved_by(freq2, dis * i);
        let Some(l) = map.validate_loc(&l) else {
            break;
        };
        res.push(l);
        i += 1;
    }

    res
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let lines = indoc::indoc! {"
            ............
            ........0...
            .....0......
            .......0....
            ....0.......
            ......A.....
            ............
            ............
            ........A...
            .........A..
            ............
            ............
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 34);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(8)), 1235);
    }
}
