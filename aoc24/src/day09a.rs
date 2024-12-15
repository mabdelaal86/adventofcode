pub fn process(data: String) -> u32 {
    println!("{}", data);

    0
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::data::*;

    #[test]
    fn test_example() {
        let data = String::from("");

        assert_eq!(process(data), 0);
    }

    #[test]
    fn test_data() {
        assert_eq!(process(read_all(9)), 0);
    }
}
