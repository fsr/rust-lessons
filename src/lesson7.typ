#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet",
    short-title: "Rust-Kurs Lesson 7",
    subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Generics")

#slide(title: "Generic functions")[
#columns(2, gutter: -10%)[
```rust
fn largest_i32(list: &[i32]) -> &i32 {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}
```
#colbreak()
```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest_i32(&number_list);
    println!("The largest number is {}", result);
}
```
]
]

#slide(title: "Generic functions")[
#columns(2, gutter: -10%)[
```rust
fn largest<T>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}
```
#colbreak()
#alternatives[
```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest(&number_list);
    println!("The largest number is {}", result);
}
```
][
```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    // we can specify the type explicitly
    // with the turbo fish syntax
    let result = largest::<u8>(&number_list);
    println!("The largest number is {}", result);
}
```
]
]
- this will not work (yet), we need the `PartialOrd` trait for comparison
]

#slide(title: "Generic structs")[
#columns(2, gutter: -15%)[
```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let unsigned: Point<u32> = Point { x: 9, y: 20 };
    let float = Point { x: 1.0, y: 4.0 };

    // This will not work. Why?
    let wont_work = Point { x: 5, y: 4.0 };
}
```
#colbreak()
#begin(2)[
```rust
struct MultiPoint<T, U> {
    x: T,
    y: U,
}
```
]
]
]

#slide(title: "Generic methods")[
#alternatives[
```rust
struct Point {
    x: u32,
    y: u32,
}

impl Point {
    fn x(&self) -> &u32 {
        &self.x
    }
}
```
][
```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}
```
]
]

#slide(title: "Non generic methods for generic structs")[
```rust
struct Point<T> {
    x: T,
    y: T,
}

impl Point<i32> {
    fn manhattan_distance(&self, other: &Self) -> i32 {
        (*self.x).abs_diff(*other.x) + (*self.y).abs_diff(*other.y)
    }
}
```
]

#new-section("Traits")

#slide(title: "Defining a trait")[
- defines some set of behavior
- types that implement a trait need to implement the behavior

#uncover(2)[
```rust
pub trait Display {
    // Required method
    fn fmt(&self, f: &mut Formatter<'_>) -> Result<(), Error>;
}
```
]
#uncover(3)[
```rust
// file: src/news.rs
pub trait Summary {
    fn summarize(&self) -> String;
}
```
]
]

#slide(title: "Implementing a trait on a type")[
```rust
// file: src/news.rs
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}
```
#begin(2)[
```rust
impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}
```
]

#begin(3)[
#text(15pt)[
Note: implementing an external trait on an external type is more complicated,
#link("https://rust-lang.github.io/rfcs/2451-re-rebalancing-coherence.html#concrete-orphan-rules")[see the orphan rules]
]
]
]

#slide(title: "Using a trait from another module")[
```rust
// file: src/main.rs

// to call a trait function, the trait needs to be in scope
use news::{Summary, NewsArticle};

fn main() {
    let article = NewsArticle {
        headline: String::from("Patina takes over"),
        location: String::from("Dimmsdale"),
        author: String::from("Timmy Turner"),
        content: String::from("Protect your metal wares, everyone!"),
    };

    println!("1 new article: {}", article.summarize());
}
```
]


#slide(title: "Default implementations")[
- written in the trait definition
```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

#uncover(2)[
- implement the trait with an empty `impl` block
```rust
impl Summary for NewsArticle {}
```
]
]

#slide(title: "Default implementations")[
- allowed to call other methods on the same trait
```rust
pub trait Summary {
    // this is a required method
    fn summarize_author(&self) -> String;

    // this method can be implemented but does not have to be
    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}
```
]

#slide(title: "Traits as Parameters")[
#alternatives[
- using an explizit trait bound
```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```
][
- syntactic sugar for trait bounds
```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
```
][
- multiple trait bounds
```rust
// using a trait bound:
pub fn notify<T: Summary + Display>(item: &T) {...}

// using the `impl` syntax:
pub fn notify(item: &(impl Summary + Display)) {...}
```
][
- one more way to specify trait bounds
```rust
fn foo<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {...}

fn foo<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{...}
```
]
]

#slide(title: "Fixing the largest function")[
#alternatives[
```rust
fn largest<T>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}
```
][
```rust
fn largest<T: std::cmp::PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];

    for item in list {
        if item > largest {
            largest = item;
        }
    }

    largest
}
```
]
]

#slide(title: "Returning types that implement traits")[
#alternatives(position: top)[
```rust
fn returns_summarizable() -> impl Summary {...}
```
][
```rust
fn returns_summarizable() -> impl Summary {
    NewsArticle {
        headline: String::from("Patina takes over"),
        location: String::from("Dimmsdale"),
        author: String::from("Timmy Turner"),
        content: String::from("Protect your metal wares, everyone!"),
    }
}
```
]
```rust
fn main() {
    let sumthing = returns_summarizable();
    // we only know that the type of `sumthing` implements `Summarize`
    // so we can only use methods from the `Summarize` trait
    // (this is called an opaque type) 
    println!("{}", sumthing.summarize());
}
```
]

#slide(title: "Returning types that implement traits")[
- useful when returning a closure
```rust
fn returning_closure() -> impl Fn(i32) -> bool {
    |x: i32| x % 3 == 0
}

```
]

#slide(title: "Implementing methods on specific trait bounds")[
#columns(gutter: -14%)[
```rust
use std::fmt::Display;
use std::cmp::PartialOrd;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}
```
#colbreak()
#begin(2)[
```rust
impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("x = {} is the largest", self.x);
        } else {
            println!("y = {} is the largest", self.y);
        }
    }
}
```
]
]
]

#slide(title: "Blanket implementations")[
```rust
impl<T: Display> ToString for T {
    ...
}
```

- read as: an implementation for `ToString` for every type that implements `Display`
theref call `to_string()` on every type that implements `Display`
]

#slide(title: "From and Into")[
#two-grid(right-width: 60%)[
#alternatives[
```rust
struct Meters(u32);
struct Millimeters(u32);

impl From<?> for ? {
  fn from(value: ?) -> Self {
    ?
  }
}

fn main() {
  let m = Meters(1);
  let mm: Millimeters = m.into();
  println!("1m == {}", mm.0);
}
```
][
```rust
struct Meters(u32);
struct Millimeters(u32);

impl From<Meters> for Millimeters {
  fn from(value: Meters) -> Self {
    Millimeters(value.0 * 1000)
  }
}

fn main() {
  let m = Meters(1);
  let mm: Millimeters = m.into();
  println!("1m == {}", mm.0);
}
```
]
][
#alternatives[
- implement conversion (which direction do you need here?)
- test your conversion in main (how?)
][
1. `From<Meters> for Millimeters` or
2. `Into<Millimeters> for Meters`
- when implementing `From<Meters>`,
	- you can use `mm... = m.into()` as well
- the `Temperature` task could also be done like this
]
]
]

#slide(title: "Extending Numbers")[
- with `u32` you _cannot_ get up to `fib(196)`. How far do you come?
- how can we do more?
#alternatives(position: top)[
```rust
use std::ops::{???};
struct Number(u32, u32);

impl AddAssign<?> for ? {
  fn add_assign(?????self, ???) -> ? { ? }
}
impl Add<?> for ? {
  fn add(???) -> ? { ? }
}

fn main() {
  println!("fib(200): {:?}", fib(200));
}
```
][
```rust
use std::ops::Add;
struct Number(u32, u32, u32, u32);

impl Add<&Number> for &Number {
  fn add(self, other: &Number) -> Number { ... }
}

fn main() {
  println!("fib(200): {:?}", fib(200));
}
```
]
]

#slide(title: "The Add trait")[
- has an associated type
- `Output` is associated to the `Add` trait
- is a generic type in the trait scope
```rust
pub trait Add<Rhs = Self> {
    type Output;

    // Required method
    fn add(self, rhs: Rhs) -> Self::Output;
}
```
]
