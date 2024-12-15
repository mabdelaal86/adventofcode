use regex::Regex;

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut res = 0;
    let mut enabled = true;
    let re = Regex::new(r"(mul|do|don't)\(((?:\d+,\d+)?)\)").unwrap();
    for line in lines {
        for (_, [instr, params]) in re.captures_iter(&line).map(|c| c.extract()) {
            if instr == "do" {
                enabled = true;
            } else if instr == "don't" {
                enabled = false;
            } else if enabled && !params.is_empty() {
                res += params
                    .split(',')
                    .map(|x| x.parse::<u32>().unwrap())
                    .product::<u32>();
            }
        }
    }

    res
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let lines = indoc::indoc! {"
            xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 48);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(3)), 98729041);
    }
}
