mod common;
mod day01a; mod day01b;
mod day02a; mod day02b;

fn main() {
    let puzzle = std::env::args().nth(1).expect("no puzzle given");
    
    let res = match puzzle.as_str() {
        "day01a" => day01a::main(),
        "day01b" => day01b::main(),
        "day02a" => day02a::main(),
        "day02b" => day02b::main(),
        _ => panic!("Invalid puzzle name"),
    };

    println!("res = {}", res);
}
