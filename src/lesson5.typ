#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 5", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Enums")

#slide(title: "Enums: Overview")[
- define a type by _enumerating_ its possible _variants_
- can represent only _one_ variant at a time
- hold associated data like a struct or a tuple
- access variants with the _namespace_ operator *`::`* 

#columns(2)[
#begin(2)[
```rust
#[derive(Debug)]
enum MouseButton {
    Left,
    Middle,
    Right,
}

println!("{:?}", MouseButton::Left);
// prints `Left`
println!("{:?}", MouseButton::Right as u8);
// prints `2`

```
]
#colbreak()
#begin(3)[
```rust
#[derive(Debug)]
enum WindowEvent {
    Mouse { 
        btn: MouseButton,
        x: u32,
        y: u32,
    },
    KeyPress(u16), // contains keycode
    FocusLost,
    FocusGained,
}
```
]
]
]

#slide(title: "Non-existent values: the Option type")[
```rust
enum Option<T> {
    None,
    Some(T),
}
```
- generic over its encapsulated type
- globally usable, no need to prefix `Option::`
- None theref there is no value
- Some theref there is a value


```rust
let m_btn = Some(MouseButton::Left);

```

]

#slide(title: "The match expression")[
```rust
let my_bool = true;
match my_bool {
    true => {},
    false => {},
}

let btn = MouseButton::Middle;
match btn {
    MouseButton::Left => { println!("left") },
    MouseButton::Middle => { println!("middle") },
    MouseButton::Right => { println!("right") },
}
```
]

#slide(title: "The match expression")[
#columns(2)[
```rust
let num = Some(12);
let num = match num {
    Some(x) => x * 2,
    None => 9,
};

// binding with a catch all pattern
match num {
    3 => println!("three"),
    5 => prinltn!("five"),
    other => println!("got {other}"),
}
```

#colbreak()
```rust
// the _ placeholder
match num {
    3 => println!("still three"),
    _ => {} // ignores other possibilities
}
```
]
]


#slide(title: "Exercise: Temperature conversion (mit mat(s)ch spielen)", theme-variant: "action")[
Write 3 methods for the `Temperature` type that convert the inner value to the desired unit.
The functions should be called `to_celsius`, `to_fahrenheit`, `to_kelvin`.
They should return the corresponding integer value; `i32`, `i32`, `u32` respectively.
Use the `match` statement.
You can ignore decimals and rounding errors.


```rust
enum Temperature {
    Celsius(i32),
    Fahrenheit(i32),
    Kelvin(u32),
}
```

At the end you should be able to do this:
```rust
let temp1 = Temperature::Celsius(-20);
println!("temp1: {}°C", temp1.to_celsius()); // -20
println!("temp1: {}°F", temp1.to_fahrenheit()); // -4
println!("temp1: {}K", temp1.to_kelvin()); // 253
```
]

#new-section("Patterns and matching")

#slide(title: "Matching literals")[
```rust
let n = 1;

match n {
    1 => println!("one"),
    2 => println!("two"),
    _ => println!("anything"),
}
```
]

#slide(title: "Matching named variables")[
```rust
let n = 1;

match n {
    1 => println!("one"),
    2 => println!("two"),
    n => println!("n = {n}"),
}
```
]

#slide(title: "Matching multiple patterns")[
- using the _or_ operator `|` or using a range expression
```rust
let n = 1;

match n {
    1 | 2 => println!("one or two"),
    3..=6 => println!("[3,6]"),
    7..10 | 13 => println!("[7,10) or 13"),
    n => println!("n = {n}"),
}
```
]


#slide(title: "Destructuring: structs")[
```rust
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

let p = Point { x: 0, y: 7 };
match p {
    Point { x, y: 0, z: 0 } => println!("On the x axis at {x}"),
    Point { x: 0, y, z: 0 } => println!("On the y axis at {y}"),
    Point { x: 0, y: 0, z } => println!("On the z axis at {z}"),
    Point { x: a, y: b, z: c } => { // `x`, `y`, `z` are renamed to `a`, `b`, `c`
        println!("On neither axis: ({a}, {b}, {c})");
    }
}
```
]

#slide(title: "Destructuring: enums")[
```rust
enum WindowEvent {
    Mouse { btn: MouseButton, x: u32, y: u32 },
    KeyPress(u16),
    FocusLost,
    FocusGained,
}
let event = WindowEvent::Mouse { btn: MouseButton::Left, x: 20, y: 100 };
match event {
    WindowEvent::Mouse { btn: MouseButton::Left | MouseButton::Right, x, y } => { ... },
    WindowEvent::Mouse { btn: MouseButton::Middle, x, y } => { ... },
    WindowEvent::KeyPress(keycode) => { ... },
    WindowEvent::FocusLost => { ... },
    WindowEvent::FocusGained => { ... },
}
```
]

#slide(title: "Ignoring values")[
- with the `_` catch-all
```rust
fn foo(_: u16, b: u16) {
    println!("we only need b: {b}");
}

fn main() {
    foo(5, 6);

    let numbers = (1, 2, 3, 4, 5);
    match numbers{
        (_, b, _, d, _) => println!("(_, {b}, _, {d}, _)"),
    }
}
```
]

#slide(title: "Ignoring values")[
- with the `..` range
```rust
let numbers = (1, 2, 3, 4, 5);
match numbers {
    (first, .., last) => {
        println!("Some numbers: {first}, {last}");
    }
}

let origin = Point { x: 0, y: 0, z: 0 };
let Point { x, .. } = origin;
println!("x is {x}");
```
]

#slide(title: "Match guards")[
- condition, attached to a pattern
- applies to the entire pattern
```rust
let num = Some(4);
match num {
    Some(x) if x % 2 == 0 => println!("The number {} is even", x),
    Some(x) => println!("The number {} is odd", x),
    None => {},
}

let (x, cond) = (4, false);
match x {
// (         ) if cond =>
    4 | 5 | 6  if cond => println!("yes"),
    _ => println!("no"),
}
```
]

#slide(title: "@ Bindings")[
```rust
enum Question {
    Input { n: i32 },
}

let q = Question::Input { n: 24 };
let answer = match q {
    Question::Input { n: num @ 24 } => num + 18,
    Question::Input { n: num @ 50..=100 | num @ 13 } => {
        eprintln!("We don't want number {num}!");
        12 * 4 - 6
    },
    _ => 6 * 7,
}
println!("Answer to the Ultimate Question of Life, the Universe, and Everything is {answer}");
```
]

#slide(title: "The match expression")[
#columns(2)[
```rust
let num = Some(12);
let num = match num {
    Some(x) => x * 2,
    None => 9,
};

// binding with a catch all pattern
match num {
    3 => println!("three"),
    5 => prinltn!("five"),
    other => println!("got {other}"),
}
```

#colbreak()
```rust
// the _ placeholder
match num {
    3 => println!("still three"),
    _ => {} // ignores other possibilities
}
```
]
]


#slide(title: "Exercise: Temperature conversion (mit mat(s)ch spielen)", theme-variant: "action")[
Write 3 methods for the `Temperature` type that convert the inner value to the desired unit.
The functions should be called `to_celsius`, `to_fahrenheit`, `to_kelvin`.
They should return the corresponding integer value; `i32`, `i32`, `u32` respectively.
Use the `match` statement.
You can ignore decimals and rounding errors.


```rust
enum Temperature {
    Celsius(i32),
    Fahrenheit(i32),
    Kelvin(u32),
}
```

At the end you should be able to do this:
```rust
let temp1 = Temperature::Celsius(-20);
println!("temp1: {}°C", temp1.to_celsius()); // -20
println!("temp1: {}°F", temp1.to_fahrenheit()); // -4
println!("temp1: {}K", temp1.to_kelvin()); // 253
```
]

#slide(title: "Non-exhaustive pattern matching with `if let`")[
#alternatives(position: top)[
```rust
fn eval(maybe_inner: Option<i32>) -> bool {
    match maybe_inner {
        Some(inner) => {
            let result = do_some_crazy_computation(inner);
            println!("We have an answer: {:?}", result);
            result
        },
        None => false
    }
}
```
][
```rust
fn eval(maybe_inner: Option<i32>) -> bool {
    if let Some(inner) = maybe_inner {

            let result = do_some_crazy_computation(inner);
            println!("We have an answer: {:?}", result);
            return result;
    }
    false
}
```
]
]

#slide(title: "Task: 'click'", theme-variant: "action")[
#uncover("1-")[- implement a `WindowEvent` enum like in the slides]
#uncover("2-")[- create some instances of it]
#uncover("3-")[- use `if let` to print the coordinates of clicks]
#alternatives()[```rust
fn main() {
    let lost = WindowEvent::FocusLost;




}
```][```rust
fn main() {
    let lost = WindowEvent::FocusLost;
    let click = WindowEvent::Mouse { btn: MouseButton:: Left, x: 20, y: 100 };



}
```][```rust
fn main() {
    let lost = WindowEvent::FocusLost;
    let click = WindowEvent::Mouse { btn: MouseButton:: Left, x: 20, y: 100 };
    print_coordinates_if_click(lost); // lost prints nothing, click does


}
```]
]

#slide(title: "Task: 'Patterned Bars'", theme-variant: "action")[
#two-grid()[
#uncover("1-")[- presumes you have done task 'bars']
#uncover("2-")[- the normal pattern can be set to something other than `#`]
#uncover("3-")[- add an `enum Pattern` for patterned bars]
#uncover("4-")[- include `Normal`, `Single(char)`]
#uncover("5-")[- use them in Bars: in the `struct`, in `print`, ...]
#uncover("5-")[- e.g. to mark the max and min values]
#uncover("6-")[- maybe add a `Multiple(&'static str)` to `Pattern`]
//' fucking highlighting
][
#alternatives()[```
##### 5
### 3
######## 8
###### 6
``` ```rust
pub struct Bars {
  width: i32,
  values: [i32; HEIGHT],


}
```][```
##### 5
### 3
######## 8
###### 6
``` ```rust
pub struct Bars {
  width: i32,
  values: [i32; HEIGHT],
  // set to '#' in Bars::new()
  normal_pattern: char
}
```][```
##### 5     #Pattern::Normal
::: 3       #Pattern::Single(':')
//////// 8  #Pattern::Single('/')
###### 6
``` ```rust
pub enum Pattern {
  Normal,        // needs no extra infos
  Single(char),  // stores a char


}
```][```
##### 5
::: 3
//////// 8
###### 6
``` ```rust
pub enum Pattern {
  Normal,        // needs no extra infos
  Single(char),  // stores a char


}
```][```
##### 5
::: 3
//////// 8
###### 6
``` ```rust
pub enum Pattern {
  Normal,        // needs no extra infos
  Single(char),  // stores a char


}
```][```
##### 5     #Pattern::Normal
::: 3       #Pattern::Single(':')
/¯\_/¯\_ 8  #Pattern::Multiple("/¯\_")
###### 6
``` ```rust
pub enum Pattern {
  Normal,        // needs no extra infos
  Single(char),  // stores a char
  // stores a string literal
  Multiple(&'static str)
}
```] //' fucking highlighting
]
]
