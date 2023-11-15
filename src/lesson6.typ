#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet",
    short-title: "Rust-Kurs Lesson 6",
    subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("collections")

#slide(title: "collections")[
#columns(2)[
#begin(1)[
- rust library with `Vec`, `HashMap`, `BTree...`
- include with `use`
]
#begin(2)[
- when to use which? 
    1. study computer science
    2. see here: https://doc.rust-lang.org/std/collections/
- how to use each?
]
#colbreak()
#begin(1)[
```rust
use std::collections::Vec;
use std::collections::HashMap;
```
]
#begin(2)[
```rust
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
```
]
]
]

#slide(title: "Vectors")[
#columns(2)[
- an array that can grow (and shrink)
- stores objects of one type (even your own struct/enum)
- create with `Vec::new();`, `vec![];`
- access at the end: `v.push()`, `v.pop()`
- access anywhere: `v.get(i)` != `&v[i]`
    - `.get(i)` does bounds check `0 <= i < v.len()`
#colbreak()
#alternatives[
```rust
let v = Vec::new();
let v = vec![1, 2, 3];
v.push(4);
let last = v.pop();
let last = v.pop();

// what’s in last?
```][```rust
let v: Vec<u32> = Vec::new();
let mut v = vec![1, 2, 3];
v.push(4); // add a 4 to the end
let last = v.pop().unwrap(); // 3
let last = v.pop().unwrap(); // 4
// .pop() returns an Option,
// either Some(...) or None
```]
]
]

#slide(title: "Iterating over Vector")[
#alternatives[
```rust
let vec: Vec<u32> = vec![1, 2, 3];
for n in vec.iter() {
    println!("{}", n);
}
for n in vec.iter_mut() {
    n += 1;
    println!("{}", n);
}
for n in vec.into_iter() {
    println!("{}", n);
}
```][
```rust
let mut vec: Vec<u32> = vec![1, 2, 3];
for n in vec.iter() {
    println!("{}", *n);
}
for n in vec.iter_mut() {
    *n += 1;
    println!("{}", *n);
}
for n in vec.into_iter() {
    println!("{}", n);
} // vec is gone now
```][
```rust
let mut vec: Vec<u32> = vec![1, 2, 3];
for n in &vec {
    println!("{}", *n); // n is also fine
}
for n in &mut vec {
    *n += 1; // *n needed here!
    println!("{}", *n); // works without *
}
for n in vec.into_iter() {
    println!("{}", n);
} // vec is gone now
```]
]

#slide(title: "Task 'fibonacci'")[
#begin(1)[- implement the fibonacci series]
#begin(2)[- `fib(n) := n if n < 2 else fib(n-1) + fib(n-2)`]
#begin(3)[- why is this inefficient?]
#begin(4)[- use a `HashMap` (global or passed into `fib(n, map)`)]
]

#slide(title: "Task 'polynomial'")[
#begin(1)[- implement a `struct Polynomial`]
#begin(2)[- `[1 3 5]` is x² + 3x + 5]
#begin(2)[- `[2 4]` is 2x + 4]
#begin(3)[- use `Vec::<u32>` internally]
#begin(4)[```rust
fn main() {
    let poly = Polynomial::from([1, 3, 5]);
    let moly = Polynomial::from([2, 4]);
    println!("poly: {:?}", poly); // #[derive(Debug)]
    println!("moly: {:?}", moly);
    println!("p+m:  {:?}", &poly + &moly); // impl Add for &Polynomial {...
    println!("m+p:  {:?}", &moly + &poly);
}
```]
]
