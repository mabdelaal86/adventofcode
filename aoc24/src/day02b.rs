use itertools::Itertools;

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut safe_count = 0;
    // parse and sort the two lists
    for line in lines {
        let values = line
            .split_whitespace()
            .map(|n| n.parse().unwrap())
            .collect_vec();

        if is_tolerated_safe(&values) {
            safe_count += 1;
        }
    }

    safe_count
}

fn is_tolerated_safe(values: &Vec<i32>) -> bool {
    if is_safe(&values) {
        return true;
    }

    for i in 0..values.len() {
        let mut v2 = values.clone();
        v2.remove(i);
        if is_safe(&v2) {
            return true;
        }
    }

    false
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
    use crate::data::*;

    #[test]
    fn test_example() {
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

        assert_eq!(process(lines), 4);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(2)), 493);
    }
}
