mod common;
mod day01a;
mod day01b;

fn main() {
    let puzzle = std::env::args().nth(1).expect("no puzzle given");
    
    let res = match puzzle.as_str() {
        "day01a" => day01a::main(),
        "day01b" => day01b::main(),
        _ => panic!("Invalid puzzle name"),
    };

    println!("res = {}", res);
}
