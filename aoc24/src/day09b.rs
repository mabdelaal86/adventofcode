use itertools::Itertools;

enum Block {
    File(u32, u128),
    Space(u32),
}

impl Block {
    fn new(count: u32, index: usize) -> Self {
        if index % 2 == 0 {
            Self::File(count, (index / 2) as u128)
        } else {
            Self::Space(count)
        }
    }
}

pub fn process(data: String) -> u128 {
    let mut data = data
        .char_indices()
        .map(|(i, c)| (i, c.to_digit(10).unwrap()))
        .map(|(i, c)| Block::new(c, i))
        .collect_vec();

    let mut end: usize = data.len() - 1;
    while end > 0 {
        if let Block::File(file_size, _) = data[end]
        {
            for start in 0..end {
                let Block::Space(space_size) = &mut data[start] else {
                    continue;
                };
                if *space_size >= file_size {
                    *space_size -= file_size;
                    let item = data.remove(end);
                    data.insert(end, Block::Space(file_size));
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
        match item {
            Block::Space(count) => {
                block += count as u128;
            }
            Block::File(count, index) => {
                for _ in 0..count {
                    res += block * index;
                    block += 1;
                }
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
        let data = String::from("2333133121414131402");

        assert_eq!(process(data), 2858);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_all(9)), 6427437134372);
    }
}
