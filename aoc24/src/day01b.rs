use itertools::Itertools;

use crate::common::*;

pub fn main(data_file: &str) {
    let res = process(read_lines(data_file));
    println!("res = {}", res);
}

fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut list1 = Vec::new();
    let mut list2 = Vec::new();
    // parse and sort the two lists
    for line in lines {
        let (a, b) = line
            .split_whitespace()
            .map(|n| n.parse().unwrap())
            .collect_tuple()
            .unwrap();
        list1.push(a);
        list2.push(b);
    }
    // calc the absolute diff
    let res = list1
        .iter()
        .map(|x| x * list2.iter().filter(|y| *y == x).count() as u32)
        // .map(|x| {println!("** {}", x); x})
        .sum();

    res
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let lines = indoc::indoc! {"
            3   4
            4   3
            2   5
            1   3
            3   9
            3   3
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 31);
    }
}
