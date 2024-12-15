use std::cmp::min;

pub fn process(data: String) -> u128 {
    let mut start: usize = 0;
    let mut end: usize = data.len() - 1;
    let mut s_count = block_count(&data, start);
    let mut e_count = block_count(&data, end);
    let mut block: u128 = 0;
    let mut res: u128 = 0;

    while start < end {
        if start % 2 == 0 {
            // block
            for _ in 0..s_count {
                res += block * block_index(start);
                block += 1;
            }
            start += 1;
            s_count = block_count(&data, start);
        } else if end % 2 == 1 {
            // space
            end -= 1;
            e_count = block_count(&data, end);
        } else {
            // block
            let count = min(s_count, e_count);
            for _ in 0..count {
                res += block * block_index(end);
                block += 1;
            }
            s_count -= count;
            e_count -= count;
            if s_count == 0 {
                start += 1;
                s_count = block_count(&data, start);
            }
            if e_count == 0 {
                end -= 1;
                e_count = block_count(&data, end);
            }
        }
    }

    if end % 2 == 0 {
        for _ in 0..e_count {
            res += block * block_index(end);
            block += 1;
        }
    }

    res
}

fn block_count(data: &str, index: usize) -> u32 {
    data.chars().nth(index).unwrap().to_digit(10).unwrap()
}

fn block_index(index: usize) -> u128 {
    (index / 2) as u128
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example_1() {
        let data = String::from("12345");

        assert_eq!(process(data), 60);
    }

    #[test]
    fn test_example_2() {
        let data = String::from("2333133121414131402");

        assert_eq!(process(data), 1928);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_all(9)), 6398608069280);
    }
}
