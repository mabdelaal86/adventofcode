pub fn process(lines: impl Iterator<Item = String>) -> u128 {
    lines
        .map(|l| parse_line(l.as_str()))
        .filter(|(val, equation)| is_possible(*val, equation))
        .map(|(val, _)| val)
        .sum()
}

fn parse_line(line: &str) -> (u128, Vec<u32>) {
    let (val, equation) = line.split_once(": ").unwrap();
    let val = val.parse::<u128>().unwrap();
    let equation = equation
        .split(" ")
        .map(|e| e.parse::<u32>().unwrap())
        .collect::<Vec<_>>();

    (val, equation)
}

fn is_possible(val: u128, equation: &Vec<u32>) -> bool {
    let ops = ['+', '*'];

    let count = ops.len().pow((equation.len() - 1) as u32);
    for i in 0..count {
        let bin = format!("{:0w$b}", i, w = equation.len() - 1);
        let operations = bin
            .chars()
            .map(|c| c.to_digit(10).unwrap())
            .map(|i| ops[i as usize])
            .collect::<Vec<_>>();

        let mut test: u128 = equation[0] as u128;
        for j in 1..equation.len() {
            test = match operations[j - 1] {
                '+' => test + equation[j] as u128,
                '*' => test * equation[j] as u128,
                _ => panic!("Invalid char"),
            }
        }
        if test == val {
            return true;
        }
    }

    false
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let lines = indoc::indoc! {"
            190: 10 19
            3267: 81 40 27
            83: 17 5
            156: 15 6
            7290: 6 8 6 15
            161011: 16 10 13
            192: 17 8 14
            21037: 9 7 18 13
            292: 11 6 16 20
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 3749);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(7)), 12839601725877);
    }
}
