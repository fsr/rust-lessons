#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 4", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Structs")

#slide(title: "Structs: Overview")[
- custom type which contains structured data
- add meaning and context to the representation of your data \
  e.g. variable names: `age` provides meaning, `a` does not tell you what it contains

Kinds of structs:
- structs (most common) 
- tuple structs
- unit-like structs
]


#slide(title: "Structs: Definiton, Instatiation and Access")[
#columns(2)[
- struct names are _CamelCase_
- field names are _snake_case_
- data is stored in named fields

#begin(2)[
```rust
// file: src/main.rs

// Definition of the Rectangle type
// which is a struct
struct Rectangle {
    width: u32,
    height: u32,
}
```
]

#begin(5)[
Can you mark individual fields as _mutable_?
Why or why not?
]

#colbreak()
#begin(3)[
- access fields of an instance with \
  the _dot_ operator *`.`*
```rust
// file: src/main.rs
fn main() {
    // `r1` is an instance of
    // the Rectangle struct
    let mut r1 = Rectangle {
        width: 20,
        height: 40,
    };

    // field access with `.` operator
    println!("width: {}", r1.width);
    r1.height = 12;
}
```
]
]
]


#slide(title: "Field init shorthand")[
- avoid repetition when parameter names and field names are the same

#alternatives[
```rust
fn new_rectangle(width: u32, height: u32) -> Rectangle {
    Rectangle {
        width: width,
        height: height,
    }
}
```
][
```rust
fn new_rectangle(width: u32, height: u32) -> Rectangle {
    Rectangle {
        width,
        height,
    }
}
```
]
]

#slide(title: "Struct update syntax")[
- copy fields with the same data to another struct
```rust
struct ManyFields {
    a: bool,
    b: i16,
    c: String,
}

let mf1 = ManyFields { a: true, b: -12, c: String::from("message") };
let mf2 = ManyFields {
    c: String::from("important message"),
    ..mf1, // `a` and `b` are copied from `mf1` into `mf2`
};
```
#uncover(2)[
- fields with types that cannot be copied (e.g. `c` of type `String`), will be moved \
  theref `mf1` cannot be used anymore
]
]

#slide(title: "Tuple structs")[
- field access via _dot_ operator *`.`*
- indices start from 0
theref basically _named tuples_
```rust
struct ColorRGB(u8, u8, u8);

fn main() {
    let unnamed_tuple = (0, 12, 9);
    let magenta = ColorRGB(255, 0, 255);
```
#uncover(2)[
```rust
    println!("second field of unnamed_tuple: {}", unnamed_tuple.1);

    // access a tuple struct like a normal tuple
    println!("blue value of magenta: {}", magenta.2);
```
]
```rust
}
```
]

#slide(title: "Unit-like structs")[
- a struct without any fields or data
```rust
struct MyUnit;

fn main() {
    let my_unit1 = MyUnit;
    let my_unit2 = MyUnit {};
    // `my_unit2` contains the same value as `my_unit1`
    // the `{}` are unnecessary 
}
```
]

#slide(title: "Adding functionality with derived traits")[
- "deriving a trait" theref Asking rustc to implement it for us 
- add `#[derive(TraitA, TraitB)]` in front of a struct definition
- does not work with every trait
]

#slide(title: "Adding functionality with derived traits: Printing structs")[
- the `Debug` trait will let us use the debug formatter
```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let r1 = Rectangle { width: 20, height: 40 };
    println!("my struct: {:?}", r1);
    println!("my struct: {}", r1); // will not work, because `{}` requires the `Display` trait
}
```
]

#slide(title: "Adding functionality with derived traits: Cloning structs")[
#columns(2)[
- the `Clone` trait will implement an element-wise deep copy \
  theref every data on the heap will be allocated again
```rust
#[derive(Debug, Clone)]
struct User {
    name: String,
    age: u32,
}
```

#colbreak()

```rust
fn main() {
    let u1 = User {
        name: String::from("Bob"),
        age: 40
    };
    let u2 = User {
        age: 20,
        ..u1.clone()
    };
    // without `.clone()` accessing `u1`
    // would be invalid now
    println!("user 1: {:?}", u1);
}
```
]
]

#new-section("Associated functions")

#slide(title: "Initialising structs with functions")[
#columns(2, gutter: -25%)[
```rust
// file: src/main.rs
struct Rectangle {
    width: u32,
    height: u32,
}
```
#colbreak()
#alternatives[
```rust
// file: src/main.rs
fn main() {
    let r1 = Rectangle {
        width: 20,
        height: 40,
    };

    let r2 = Rectangle {
        width: 9_000,
        height: 10,
    };
}
```
][
```rust
// file: src/main.rs
fn new_rectangle(width: u32, height: u32) -> Rectangle {
    Rectangle {
        width,
        height,
    }
}

fn main() {
    let r1 = new_rectangle(20, 40);
    let r2 = new_rectangle(9_000, 10);
}
```
]
]
]

#slide(title: "Creating our first associated function")[
```rust
struct Rectangle {
    width: u32,
    height: u32,
}
```
\

#columns(2)[
What we have:
```rust
let r1 = new_rectangle(20, 40);
```
`new_rectangle` is a *free function* \
theref it does _not belong_ to a certain namespace

#colbreak()

What we want:
```rust
let r1 = Rectangle::new(20, 40);
```
`new` is an *associated function* \
theref it belongs to the `Rectangle` namespace
]
]

#slide(title: "Creating our first associated function")[
#alternatives(position: top)[
```rust
fn main() {
    let r1 = new_rectangle(20, 40);
}

fn new_rectangle(width: u32, height: u32) -> Rectangle {
    Rectangle {
        width,
        height,
    }
}
```
][
```rust
fn main() {
    let r1 = Rectangle::new_rectangle(20, 40);
}

impl Rectangle {
    fn new_rectangle(width: u32, height: u32) -> Rectangle {
        Rectangle {
            width,
            height,
        }
    }
}
```
][
```rust
fn main() {
    let r1 = Rectangle::new(20, 40);
}

impl Rectangle {
    fn new(width: u32, height: u32) -> Rectangle {
        Rectangle {
            width,
            height,
        }
    }
}
```
- every function defined in `impl` belongs to the namespace
][
```rust
fn main() {
    let r1 = Rectangle::new(20, 40);
}

impl Rectangle {
    fn new(width: u32, height: u32) -> Self {
        Self {
            width,
            height,
        }
    }
}
```
- `Self` is an alias to the type from the `impl` block \
  theref avoids repetion
]
]

#slide(title: "Summary: Associated functions")[
- defined in an `impl` block
- belong to the namespace of the type 
- called using the _namespace_ operator *`::`* \
  `Rectangle::new(20, 40)`
- e.g. `String::from("")`, `String::new()`
]

#slide(title: "Adding more functionality with methods")[

```rust
fn set_width(rect: &mut Rectangle, width: u32) {
    rect.width = width
}
```
\

#columns(2)[
What we have:
```rust
let mut r1 = Rectangle::new(20, 40);
set_width(&mut r1, 70);
```
`set_width` is a *free function*

#colbreak()

What we want:
```rust
let mut r1 = Rectangle::new(20, 40);
r1.set_width(70);
```
`set_width` is a *method* that operates on an instance of `Rectangle` \
theref the _dot_ operator *`.`* is used to call it
]
]

#slide(title: "The methodic way from functions to methods")[
#alternatives(position: bottom)[
Starting with `set_width` as a free function
```rust

    fn set_width(rect: &mut Rectangle, width: u32) {
        rect.width = width
    }


fn main() {
    let mut r1 = Rectangle::new(20, 40);
    set_width(&mut r1, 70);
}
```
][
Moving `set_width` into the `impl` block
```rust
impl Rectangle {
    fn set_width(rect: &mut Rectangle, width: u32) {
        rect.width = width
    }
}

fn main() {
    let mut r1 = Rectangle::new(20, 40);
    Rectangle::set_width(&mut r1, 70);
}
```
][
`Rectangle` theref `Self`, `rect` theref `self`
```rust
impl Rectangle {
    fn set_width(self: &mut Self, width: u32) {
        self.width = width
    }
}

fn main() {
    let mut r1 = Rectangle::new(20, 40);
    Rectangle::set_width(&mut r1, 70);
}
```
][
`&mut self` is an alias to `self: &mut Self`, replace it
```rust
impl Rectangle {
    fn set_width(&mut self, width: u32) {
        self.width = width
    }
}

fn main() {
    let mut r1 = Rectangle::new(20, 40);
    Rectangle::set_width(&mut r1, 70);
}
```
][
`set_width` is now a method and we can call on an instance \
in the same way we can access fields of an instance \
theref with the _dot_ operator *`.`*
```rust
impl Rectangle {
    fn set_width(&mut self, width: u32) {
        self.width = width
    }
}

fn main() {
    let mut r1 = Rectangle::new(20, 40);
    r1.set_width(70);
}
```
]
]


#slide(title: "Summary: Methods")[
- special *associated functions* with `self` as their first parameter
- also called *member* functions
- operate on an instance of a type
- called using the _dot_ operator *`.`* \
  `r1.set_width(70)`
- calling a method automatically (de-)references the variable \
  `r1.set_width(70)` theref `(&mut r1).set_width(70)`
]

#slide(title: "The impl block")[
- `impl` (implementation) block contains function definitions for a type
- multiple `impl` blocks for the same type are allowed

Aliases in an `impl` block:
- `Self` is an alias to the type
- `fn method(&mut self)` theref `fn method(self: &mut Self)`
- `fn method(&self)` theref `fn method(self: &Self)`
- `fn method(self)` theref `fn method(self: Self)`
]

#new-section("Tasks")

#slide(title: "Task 'rect'", theme-variant: "action")[
#two-grid()[
	#uncover("1-")[- create a `struct Rect` with `width` and `height`]
	#uncover("2-")[- implement `fmt::Display` for it so you can easily `print!("{}", r)` it]
	#uncover("3-")[- create some, maybe implement `Rect::new(...)`]
	#uncover("4-")[- implement `r.area()` and check if it works]
	#uncover("5-")[- implement `r.can_contain(other)` to compare two rectangles]
	#uncover("6-")[- implement `r.draw()` to print some `#`s]
][
	#alternatives()[```
	r: Rect { width: 5, height: 3 }








	```][```
	r: Rect(5 x 3)








	```][```
	r: Rect(5 x 3)
	s: Rect(4 x 3)







	```][```
	r: Rect(5 x 3)
	s: Rect(4 x 3)
	r.area(): 15






	```][```
	r: Rect(5 x 3)
	s: Rect(4 x 3)
	r.area(): 15
	r.can_contain(s): true
	s.can_contain(r): false




	```][```
	r: Rect(5 x 3)
	s: Rect(4 x 3)
	r.area(): 15
	r.can_contain(s): true
	s.can_contain(r): false
	#####
	#####
	#####
	```]
]
]

#slide(title: "Task 'rect' – fmt::Debug", theme-variant: "action")[
so that `println!("{:?}", rect);` works

#alternatives()[```rust






fn main() {
  let r = Rect::new(5, 3);
  println!("{:?}", r);
}
```][```rust

struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}
fn main() {
  let r = Rect::new(5, 3);
  println!("{:?}", r);
}
```][```rust
#[derive(Debug)]
struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}
fn main() {
  let r = Rect::new(5, 3);
  println!("{:?}", r);
}
```]
]

#slide(title: "Task 'rect' – fmt::Display", theme-variant: "action")[
so that `println!("{}", rect);` works

#alternatives()[```rust
use std::fmt;












```][```rust
use std::fmt;
struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}







```][```rust
use std::fmt;
struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}
impl fmt::Display for Rect {
  fn fmt(&self,                       ) ->             {

  }
}
```][```rust
use std::fmt;
struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}
impl fmt::Display for Rect {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "             ",                        )
  }
}
```][```rust
use std::fmt;
struct Rect {...}
impl Rect {
  fn new(...) -> Rect {...}
  ...
}
impl fmt::Display for Rect {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    write!(f, "Rect({} x {})", self.width, self.height)
  }
}
```]
]

#slide(title: "Task 'bars'", theme-variant: "action")[
drawing bar diagrams of functions


#columns(2)[
#uncover("1-")[- define `height` and `width`]
#uncover("2-")[- create an array with test values]
#uncover("3-")[- write a function that draws your array]
#uncover("4-")[- write a function that finds the maximum]
#uncover("5-")[- add some very large values]
#uncover("6-")[- scale your diagram to your `width`]
#uncover("7-")[- use one or more structs where useful]
#colbreak()
#alternatives(position: bottom)[
```
/–  width  –\

                  \
                  |
                  |_height
                  |
                  |
                  /
```
][
```
/–  width  –\

9                 \
4                 |
7                 |_height
1                 |
12                |
5                 /
```
][
```
/–  width  –\

######### 9       \
#### 4            |
####### 7         |_height
# 1               |
############ 12   |
##### 5           /
```
][
```
/–  width  –\

######### 9       \
#### 4            |
####### 7         |_height
# 1               |
############ 12   |
##### 5           /
```
][
```
/–  width  –\

######### 9       \
#### 4            |
####### 7         |_height
# 1               |
####################################################################################################################### 120
##### 5           /
```
][
```
/–  width  –\

######### 90      \
#### 40           |
####### 70        |_height
# 10              |
############ 120  |
##### 50          /
```
][
```


######### 90
#### 40
####### 70
# 10
############ 120
##### 50
```
]
]
]
