use std::vec::Vec;
use std::collections::HashMap;

fn main() {
    // empty vector of u32 values
    let numbers = Vec::<u32>::new();
    // initialize with values
    let names = HashMap::<u32, &str>::from([
        (1, "one"),
        (2, "two"),
        (3, "three"),
    ]);

    // macros, equivalent to Vec::from(...)
    let numbers = vec![1, 2, 3];
    let v: Vec<i32> = Vec::new();
    let mut v = vec![1, 2, 3];
    v.push(4); // add a 4 to the end
    let last = v.pop().unwrap(); // 3
    let last = v.pop().unwrap(); // 4

    let mut vec: Vec<u32> = vec![1, 2, 3];
    for n in &vec {
        // n is also fine, rust adds the * also
        println!("{}", *n);
    }
    for n in &mut vec {
        // *n needed here!
        *n += 1;
        println!("{}", *n); // works without *
    }
    for n in vec.into_iter() {
        println!("{}", n);
    } // vec is gone now

}
