use itertools::Itertools;

use crate::common::*;

pub fn main() {
    let res = process(read_file("data/day02.txt"));
    println!("res = {}", res);
}

fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut safe_count = 0;
    // parse and sort the two lists
    for line in lines {
        let values = line
            .split_whitespace()
            .map(|n| n.parse().unwrap())
            .collect_vec();

        if is_safe(&values) {
            safe_count += 1;
        }
    }

    safe_count
}

fn is_safe(values: &Vec<i32>) -> bool {
    let d1 = values[1] - values[0];
    for i in 1..values.len() {
        let d = values[i] - values[i - 1];
        if d.abs() < 1 || d.abs() > 3 || d.is_positive() != d1.is_positive() {
            return false;
        }
    }

    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let lines = indoc::indoc! {"
            7 6 4 2 1
            1 2 7 8 9
            9 7 6 2 1
            1 3 2 4 5
            8 6 4 4 1
            1 3 6 7 9
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 2);
    }
}
