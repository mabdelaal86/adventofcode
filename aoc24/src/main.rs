mod common;
mod day00x;
mod day01a; mod day01b;
mod day02a; mod day02b;
mod day03a; mod day03b;

fn main() {
    let puzzle = std::env::args().nth(1).expect("no puzzle given");
    
    let res = match puzzle.as_str() {
        "day00x" => day00x::main(),
        "day01a" => day01a::main(),
        "day01b" => day01b::main(),
        "day02a" => day02a::main(),
        "day02b" => day02b::main(),
        "day03a" => day03a::main(),
        "day03b" => day03b::main(),
        _ => panic!("Invalid puzzle name"),
    };

    println!("res = {}", res);
}
