use regex::Regex;

use crate::common;

pub fn main() -> u32 {
    process(common::read_file("data/day03.txt"))
}

fn process(lines: impl Iterator<Item=String>) -> u32 {
    let mut res = 0;
    let re = Regex::new(r"mul\((\d+),(\d+)\)").unwrap();
    for line in lines {
        for (_, [n1, n2]) in re.captures_iter(&line).map(|c| c.extract()) {
            res += n1.parse::<u32>().unwrap() * n2.parse::<u32>().unwrap();
        }
    }

    res
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let lines = indoc::indoc! {"
            xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 161);
    }
}
