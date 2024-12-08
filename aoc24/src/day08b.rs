use std::collections::{HashMap, HashSet};

use crate::common::*;

struct Map {
    frequencies: HashMap<char, Vec<Location>>,
    cols: usize,
    rows: usize,
}

pub fn main() {
    let res = process(read_file("data/day08.txt"));
    println!("res = {}", res);
}

fn process(lines: impl Iterator<Item = String>) -> usize {
    let map = collect_data(lines);
    let antinodes = get_antinodes(&map);

    antinodes
        .iter()
        .filter(|loc| loc.x < map.cols && loc.y < map.rows)
        .count()
}

fn collect_data(lines: impl Iterator<Item = String>) -> Map {
    let mut frequencies: HashMap<char, Vec<Location>> = HashMap::new();

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
                frequencies.get_mut(&c).unwrap().push(Location::new(i, row));
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

fn get_antinodes(map: &Map) -> HashSet<Location> {
    let mut antinodes: HashSet<Location> = HashSet::new();
    for frequency in map.frequencies.values() {
        antinodes.extend(frequency);
        for i in 0..frequency.len() {
            for j in i + 1..frequency.len() {
                get_antinode(frequency[i], frequency[j], map.cols, map.rows)
                    .iter()
                    .for_each(|loc| {
                        antinodes.insert(*loc);
                    });
            }
        }
    }
    antinodes
}

fn get_antinode(freq1: Location, freq2: Location, cols: usize, rows: usize) -> Vec<Location> {
    let mut res: Vec<Location> = Vec::new();

    let dis = freq2 - freq1;

    let mut i = 1;
    loop {
        let Ok(l) = freq1.moved_by(dis * -i) else {
            break;
        };
        if l.x >= cols || l.y >= rows {
            break;
        }
        res.push(l);
        i += 1;
    }

    i = 1;
    loop {
        let Ok(l) = freq2.moved_by(dis * i) else {
            break;
        };
        if l.x >= cols || l.y >= rows {
            break;
        }
        res.push(l);
        i += 1;
    }

    res
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
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
}
