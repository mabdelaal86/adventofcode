use std::collections::HashMap;

type Stone = u128;
type Blinks = u32;
type Count = u128;
type Dict = HashMap<Stone, HashMap<Blinks, Count>>;

pub fn process(data: &str, blinks: Blinks) -> Count {
    let mut dict: Dict = HashMap::new();
    data.split_whitespace()
        .map(|x| x.parse().unwrap())
        .map(|x| count(x, blinks, &mut dict))
        .sum()
}

fn count(stone: Stone, blinks: Blinks, dict: &mut Dict) -> Count {
    // check cache
    if !dict.contains_key(&stone) {
        dict.insert(stone, HashMap::new());
    }
    if dict[&stone].contains_key(&blinks) {
        return dict[&stone][&blinks];
    }
    // apply rules
    let str_stone = stone.to_string();
    let res = if blinks == 1 {
        [2, 1][str_stone.len() % 2]
    } else if str_stone.len() % 2 == 1 {
        let new_stone = if stone == 0 { 1 } else { stone * 2024 };
        count(new_stone, blinks - 1, dict)
    } else {
        let (right, left) = str_stone.split_at(str_stone.len() / 2);
        count(left.parse().unwrap(), blinks - 1, dict)
            + count(right.parse().unwrap(), blinks - 1, dict)
    };
    dict.get_mut(&stone).unwrap().insert(blinks, res);
    res
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
        assert_eq!(process("0 1 10 99 999", 1), 7);
    }

    #[test]
    fn test_example_2() {
        assert_eq!(process("125 17", 6), 22);
    }

    #[test]
    fn test_example_3() {
        assert_eq!(process("125 17", 25), 55312);
    }

    #[test]
    fn test_data_a() {
        assert_eq!(process(read_all(11).as_str(), 25), 220999);
    }

    #[test]
    fn test_data_b() {
        assert_eq!(process(read_all(11).as_str(), 75), 261936432123724);
    }
}
