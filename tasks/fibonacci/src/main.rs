use std::collections::HashMap;

fn fib(n: u64, map: &mut HashMap<u64, u64>) -> u64 {
    if !map.contains_key(&n) {
        let result = if n < 2 {
            n
        } else {
            fib(n - 1, map) + fib(n - 2, map)
        };
        map.entry(n).or_insert(result);
    }
    map[&n]
}

fn main() {
    let mut map = HashMap::new();
    for n in 0..90 {
        println!("fib({:3}): {:30}", n, fib(n, &mut map));
    }
}
