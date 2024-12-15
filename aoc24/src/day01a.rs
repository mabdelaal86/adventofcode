use itertools::Itertools;

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut list1 = Vec::new();
    let mut list2 = Vec::new();
    // parse and sort the two lists
    for line in lines {
        let (a, b) = line
            .split_whitespace()
            .map(|n| n.parse::<u32>().unwrap())
            .collect_tuple()
            .unwrap();
        list1.push(a);
        list2.push(b);
    }
    list1.sort();
    list2.sort();
    // calc the absolute diff
    let res = list1
        .into_iter()
        .zip(list2.into_iter())
        // .map(|(a, b)| {println!("** {:?}", (a, b)); (a, b)})
        .map(|(a, b)| a.abs_diff(b))
        .sum();

    res
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
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

        assert_eq!(process(lines), 11);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(1)), 1590491);
    }
}
