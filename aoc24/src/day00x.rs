use crate::common;

pub fn main() -> i32 {
    process(common::read_file("data/day.txt"))
}

fn process(lines: impl IntoIterator<Item=String>) -> i32 {
    for line in lines {
        println!("{}", line);
    }

    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let lines = indoc::indoc! {"

        "}.lines().map(|l| l.to_string());

        assert_eq!(process(lines), 0);
    }
}
