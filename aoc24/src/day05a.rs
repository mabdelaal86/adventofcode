use std::collections::HashMap;

type PageRule = HashMap<u32, Vec<u32>>;

pub fn process(lines: impl Iterator<Item = String>) -> u32 {
    let mut read_rules = true;
    // page : pages after
    let mut rules: PageRule = HashMap::new();
    let mut res = 0;

    for line in lines {
        if line.is_empty() {
            read_rules = false;
            continue;
        }

        if read_rules {
            process_rule(&mut rules, &line);
        } else {
            res += process_update(&mut rules, &line);
        }
    }

    res
}

fn process_rule(rules: &mut PageRule, line: &str) {
    let (p1, p2) = line.split_once("|").unwrap();
    let (p1, p2) = (p1.parse::<u32>().unwrap(), p2.parse::<u32>().unwrap());

    if !rules.contains_key(&p1) {
        rules.insert(p1, Vec::new());
    }
    if !rules.contains_key(&p2) {
        rules.insert(p2, Vec::new());
    }
    rules.get_mut(&p1).unwrap().push(p2);
}

fn process_update(rules: &mut PageRule, line: &str) -> u32 {
    let pages = line
        .split(",")
        .map(|p| p.parse::<u32>().unwrap())
        .collect::<Vec<u32>>();

    for i in 0..pages.len() - 1 {
        let page_rule = rules.get(&pages[i]).unwrap();
        if pages[i + 1..].iter().any(|&p| !page_rule.contains(&p)) {
            return 0;
        }
    }

    pages[pages.len() / 2]
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let lines = indoc::indoc! {"
            47|53
            97|13
            97|61
            97|47
            75|29
            61|13
            75|53
            29|13
            97|29
            53|29
            61|53
            97|53
            61|29
            47|13
            75|47
            97|75
            47|61
            75|61
            47|29
            75|13
            53|13

            75,47,61,53,29
            97,61,53,29,13
            75,29,13
            75,97,47,61,53
            61,13,29
            97,13,75,29,47
        "}
        .lines()
        .map(|l| l.to_string());

        assert_eq!(process(lines), 143);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_lines(5)), 5087);
    }
}
