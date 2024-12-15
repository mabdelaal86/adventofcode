use itertools::Itertools;

#[derive(Debug)]
struct Block {
    index: u128,
    count: u32,
    is_space: bool,
}

impl Block {
    fn new(index: usize, count: u32) -> Self {
        Self {
            index: (index / 2) as u128,
            count,
            is_space: index % 2 == 1,
        }
    }

    fn space(count: u32) -> Self {
        Self {
            index: 0,
            count,
            is_space: true,
        }
    }

    fn value(&self) -> u128 {
        if self.is_space {
            0
        } else {
            self.index
        }
    }
}

pub fn process(data: String) -> u128 {
    let mut data = data
        .char_indices()
        .map(|(i, c)| (i, c.to_digit(10).unwrap()))
        .map(|(i, c)| Block::new(i, c))
        .collect_vec();

    let mut end: usize = data.len() - 1;
    while end > 0 {
        if !data[end].is_space {
            for start in 0..end {
                if data[start].is_space && data[start].count >= data[end].count {
                    data[start].count -= data[end].count;
                    let item = data.remove(end);
                    data.insert(end, Block::space(item.count));
                    data.insert(start, item);
                    break;
                }
            }
        }
        end -= 1;
    }

    let mut block: u128 = 0;
    let mut res: u128 = 0;

    for item in data {
        for _ in 0..item.count {
            res += block * item.value();
            block += 1;
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
        let data = String::from("2333133121414131402");

        assert_eq!(process(data), 2858);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_all(9)), 6427437134372);
    }
}
