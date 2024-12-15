use crate::common::*;

pub fn main(data_file: &str) {
    let res = process(read_all(data_file));
    println!("res = {}", res);
}

fn process(data: String) -> u32 {
    println!("{}", data);

    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_process() {
        let data = String::from("");

        assert_eq!(process(data), 0);
    }
}
