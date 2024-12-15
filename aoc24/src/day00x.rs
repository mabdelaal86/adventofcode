pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    for line in lines {
        println!("{}", line);
    }

    0
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let lines = indoc::indoc! {"

        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 0);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(0)), 0);
    }
}
