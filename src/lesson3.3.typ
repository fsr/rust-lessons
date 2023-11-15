#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 3", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Ownership, References and Slices")

#slide(title: "Ownership")[
- memory is managed through system of ownership
    - a set of rules checked by the compiler
- memory safety guarantees without a garbage collector
- rule violation theref compile error
- no runtime overhead
]

#slide(title: "Ownership rules")[
From the original Rust Book:
- Each value in Rust has an *owner*.
- There can only be one owner at a time.
- When the owner goes out of scope, the value will be _dropped_.
]


#slide(title: "The String type")[
#columns(2)[
- can store data of arbitrary length
- meta data stored on stack
- content allocated on heap

#begin(2)[
```rust
{
    // allocates memory to store
    // "hello" on the heap
    let s1 = String::from("hello");

    // s1 is valid here
}
// s1 is out of scope
// String will be dropped, memory deallocated
```
]

#colbreak()

#begin(3)[
#figure(
  image("assets/l3.3_string-memory-representation.svg", width: 100%),
  caption: [Memory representation of s1.],
)
]
]
]

#slide(title: "Move Ownership out of function")[
```rust
fn main() {
  let outer_string = foo();
  println!("{}", outer_string);
}

fn foo() -> String {
  let inner_string = String::from("hello world");
  inner_string
}
```
]

#slide(title: "Is this valid code?", theme-variant: "action")[
```rust
fn strings() -> String {
  let original = String::from("hello");
  let new_owner = original;
```#only(2)[```rust
  // new_owner takes the ownership from original
  // which means original does not own it anymore
  // „one owner“-Rule
```]```rust
  println!("{}", original);
  new_owner
}
```
]

#slide(title: "Move Ownership into function")[
#columns(2)[
```rust
fn main() {
  let s = String::from("hello");
  let len = get_length(s);
``` #begin(3)[```rust
  // s has been moved into function,
  // is invalid now
```] ```rust
  println!("|{}| == {}", s, len);
}

fn get_length(some_string: String) -> usize {
  println!("{}", some_string);
  some_string.len()
``` #begin(4)[```rust
  // some_string is dropped here
```] ```rust
}
```

#colbreak()
#uncover("2-")[
in this code:
- where are strings moved?
- where are strings dropped?
]
]
]

#slide(title: "References and Borrowing")[
```rust
fn main() {
  let s = String::from("hello");
  let len = get_length(&s);
  println!("|{}| == {}", s, len);
}

``` #uncover(2)[```rust
// here, get_length borrows the string,
// it doesn't move it and doesn't own it
```] ```rust
fn get_length(some_string: &String) -> usize {
  some_string.len()
}
```
]

#slide(title: "References and Borrowing: mutably")[
```rust
fn main() {
  let s = String::from("hello");
  append_world(&mut s);
  println!("|{}|", s);
}

``` #uncover(2)[```rust
// here, append_world gets a mutable reference
// that it changes
```] ```rust
fn append_world(some_string: &mut String) {
  some_string.push_str(", world!");
}
```
]

#slide(title: "Scope of References")[
```rust
fn main() {
  let s = String::from("hello");
  let ref1 = &s;  // why is this not allowed?
  append_world(&mut s);
  println!("|{}|", ref1);
  println!("|{}|", s);
}

``` #uncover(2)[```rust
// references exist until their last use
// an immutable reference is not allowed while there‘s also a &mut
```]]

#slide(title: "Dereferencing")[
#columns(2)[
- the `*` operator follows the reference to its original location
```rust
let a = 13; // a has type `i32`
let b = &a; // b has type `&i32`
let c = *b; // c has type `i32`
```

#colbreak()
#uncover(2)[
```rust
let mut value = 12;
let value_ref = &mut value;
*value_ref = 6;

println!("{value}");
// prints 6, because we changed the
// content of `value` with `value_ref`
```
]
]
]

#slide(title: "Dangling References")[
- returning a reference to a value that will be dropped is an error
```rust
fn create_dangling_ref() -> &String {
    let s = String::from("hello");
    &s // `s` will be dropped, so any reference to `s` will be invalid
}
```
]

#slide(title: "Summary: Rules of References")[
- you can have _either_ \
  *one mutable reference* _XOR_ \
  *any number of immutable references*
- references must always be valid \
  theref no references to dropped memory
]

#slide(title: "The Slice type")[
#grid(
  columns: (1fr, 1fr),
  align(horizon)[
- a *slice is a reference* to a contiguous sequence of elements in a collection \
    theref does not take ownership

#uncover("2-")[
- `&str` is a _string slice_
```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world: &str = &s[6..11];
```
]
\

#uncover("4-")[
```rust
let string_literals = "are slices too!";
```
- they point to a place in the binary (data segment), not in the heap
]
],

align(right + horizon)[
  #uncover("3-")[
    #image("assets/l3.3_string_slice.svg", height: 80%)
  ]
],

)]

#slide(title: "Range Syntax")[
- [a, b) $<==>$ `[inclusive..exclusive]`
- [a, b] $<==>$ `[inclusive..=inclusive]`
```rust
let s = String::from("range fun");
//                    012345678

let range = &s[..5];    // same as [0..5]
let fun = &s[6..];      // same as [6..(s.len())]
let range_fun = &s[..]; // same as [0..=(s.len()-1)]
```

]

#slide(title: "String slices as parameters")[
- converting a `String` to a `&str` is easy
- converting a `&str` to a `String` requires heap allocation
#columns(2)[
```rust
fn compute_string(s: &String) -> &str {...}
```
- takes a reference to a `String`
- can only be called with a reference to a `String`

#colbreak()

```rust
fn compute_str(s: &str) -> &str {...}
```
- takes a _string slice_
- can easily be called with any `String`, _string slice_,
  _string literal_, reference to a `String`
- generally preferred
]
]

#slide(title: "Slicing arrays")[
```rust
let array = [1, 2, 3, 4, 5];

let slice: &[i32] = &array[1..4];

assert_eq!(slice, &[2, 3, 4]);

```
]

#slide(title: "Exercise", theme-variant: "action")[
Write a program that reads a sentence from standard input.
Print each word from that sentence in a new line.
Hint: Try to separate the words by whitespace.

You can use this code to read a single line from standard input.
```rust
let mut sentence = String::new();
std::io::stdin().read_line(&mut sentence).expect("Failed to read sentence");
```
]
