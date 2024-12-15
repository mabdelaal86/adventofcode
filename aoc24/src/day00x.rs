use crate::common::*;

pub fn main(data_file: &str) {
    let res = process(read_lines(data_file));
    println!("res = {}", res);
}

fn process(lines: impl Iterator<Item = String>) -> u32 {
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

        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 0);
    }
}
