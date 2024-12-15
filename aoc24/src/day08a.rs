use std::collections::{HashMap, HashSet};

use crate::map::*;

struct Map {
    frequencies: HashMap<char, Vec<Location>>,
    cols: usize,
    rows: usize,
}

pub fn process(lines: impl Iterator<Item = String>) -> usize {
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
        for i in 0..frequency.len() {
            for j in i + 1..frequency.len() {
                get_antinode(frequency[i], frequency[j])
                    .iter()
                    .for_each(|loc| {
                        antinodes.insert(*loc);
                    });
            }
        }
    }
    antinodes
}

fn get_antinode(freq1: Location, freq2: Location) -> Vec<Location> {
    let mut res: Vec<Location> = Vec::new();

    let dis = distance_to(freq1, freq2).unwrap();
    let min_x = freq1.x.min(freq2.x) as i32 - dis.x;
    let min_y = freq1.y.min(freq2.y) as i32 - dis.y;
    let max_x = freq1.x.max(freq2.x) + dis.x as usize;
    let max_y = freq1.y.max(freq2.y) + dis.y as usize;

    if freq1.x <= freq2.x && freq1.y <= freq2.y {
        res.push(Location::new(max_x, max_y));
        if min_x >= 0 && min_y >= 0 {
            res.push(Location::new(min_x as usize, min_y as usize));
        }
    } else {
        if min_x >= 0 {
            res.push(Location::new(min_x as usize, max_y));
        }
        if min_y >= 0 {
            res.push(Location::new(max_x, min_y as usize));
        }
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

        assert_eq!(process(lines), 14);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(8)), 392);
    }
}
