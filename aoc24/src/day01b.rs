use itertools::Itertools;

use crate::common;

#[allow(unused)]
pub fn main() -> u32 {
    process(common::read_file("data/day01.txt"))
}

fn process(lines: impl IntoIterator<Item=String>) -> u32 {
    let mut list1 = Vec::new();
    let mut list2 = Vec::new();
    // parse and sort the two lists
    for line in lines {
        let (a, b) = line.split_whitespace()
            .map(|n| n.parse::<u32>().unwrap())
            .collect_tuple().unwrap();
        list1.push(a);
        list2.push(b);
    }
    // calc the absolute diff
    let res = list1
        .iter().map(|x| {x * list2.iter().filter(|y| *y == x).count() as u32})
        // .map(|x| {println!("** {}", x); x})
        .sum::<u32>();

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
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 31);
    }
}
