use itertools::Itertools;

use crate::common;

pub fn main() -> i32 {
    process(common::read_file("data/day02.txt"))
}

fn process(lines: impl IntoIterator<Item=String>) -> i32 {
    let mut safe_count = 0;
    // parse and sort the two lists
    for line in lines {
        let values = line.split_whitespace()
            .map(|n| n.parse().unwrap())
            .collect_vec();

        let safe = is_safe(&values);
        if safe == (0, 0) {
            safe_count += 1;
            continue;
        }

        for i in 0..values.len() {
            let mut v2 = values.clone();
            v2.remove(i);
            if is_safe(&v2) == (0, 0) {
                safe_count += 1;
                break;
            }
        }
    }

    safe_count
}

fn is_safe(values: &Vec<i32>) -> (usize, usize) {
    let d1 = values[1] - values[0];
    for i in 1..values.len() {
        let d = values[i] - values[i - 1];
        if d.abs() < 1 || d.abs() > 3 || d.is_positive() != d1.is_positive() {
            return (i - 1, i);
        }
    }

    (0, 0)
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
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 4);
    }
}
