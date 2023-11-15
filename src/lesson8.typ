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


#new-section("Lifetimes")

#slide(title: "Let's pretend we're the compiler")[
```rust
fn biggest(x: &i32, y: &i32) -> &i32 {
    if *x > *y {
        x
    } else {
        y
    }
}
```
#begin(2)[
```rust
fn main() {
    let i1 = 7;
    let result;
    {
        let i2 = 8;
        result = biggest(&i1, &i2);
    }
    println!("The bigger value is {}", result);
}
```
]
]

#slide(title: "What makes up the type of a reference?")[
#begin(1)[
- the underlying type, `i32`
]
#begin(2)[
- the mutability, `&` vs `&mut`
]
#begin(3)[
- the lifetime, how long does the underlying value live?
]
]

#slide(title: "Terminology")[
*lexical scope:*
Section of code where a _variable_ is valid.
Starts with `{` and ends with `}`

*liveness scope:*
Section of code where the _value_ of a variable is valid.
Starts where the value is created and ends where the value is dropped.

*lifetime:*
Section of code where the _reference_ to a value is valid.
Starts at creation of reference.
Is _at most_ as long as the liveness scope of the underlying value.
]

#slide(title: "Lifetime annotation syntax")[
```rust
&i32                       // a reference
&'a i32                    // a reference with an explicit lifetime
&'a mut i32                // a mutable reference with an explicit lifetime
&'this_can_be_anything i32 // a reference with a long lifetime identifier
```
]

#slide(title: "A dangling reference")[
#one-by-one[
how does the compiler know this shouldn't compile?
][
- `x` has a liveness scope, it ends with the inner lexical scope
][
- `ref_to_x` has lifetime `'b`, which is _at most_ as long as the liveness scope of `x`
]
```rust
fn main() {
    let r;

    {
        let x = 5;
        let ref_to_x /*  &'b i32  */= &x; // -+-- 'b
        r = ref_to_x;                     //  |
    }                                     // -+ `x` is dropped theref lifetime 'b ends here

    println!("r: {}", r);
}
```
]

#slide(title: "Fixing the biggest function")[
#set text(15pt)
- by annotating lifetimes
#alternatives[
```rust
fn biggest(x: &i32, y: &i32) -> &i32 {
    if *x > *y {
        x
    } else {
        y
    }
}
fn main() {
    let i1 = 7;
    let result;
    {
        let i2 = 8;
        result = biggest(&i1, &i2);
    }
    println!("The bigger value is {}", result);
}
```
][
```rust
fn biggest<'a>(x: &'a i32, y: &'a i32) -> &'a i32 {
    if *x > *y {
        x
    } else {
        y
    }
}
fn main() {
    let i1 = 7;
    let result;
    {
        let i2 = 8;
        result = biggest(&i1, &i2);
    }   // i2 is dropped
    println!("The bigger value is {}", result);
}
```
]
#begin(2)[
- `biggest` is generic over lifetime `'a`
- the returned `&'a i32` is assigned to result
  theref `'a` must be _at least_ as long as liveness scope of result
- "`i2` does not live long enough"
]
]

#slide(title: "Using references in structs")[
- needs lifetime annotations

```rust
struct Person<'a> {
    name: &'a str,
    age: u8,
}
```
]

#slide(title: "Lifetime elision")[
#begin(2)[
1. compiler assigns a different lifetime to every reference missing an annotation
]
#begin(3)[
2. one input lifetime parameter theref this lifetime is assigned to all output parameters
]
#begin(4)[
3. more than one input lifetime parameter && there is `&self` theref lifetime of `&self` is assigned to all output parameters
]

#alternatives[
```rust
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}
```
][
```rust
fn first_word<'a>(s: &'a str) -> &str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}
```
][
```rust
fn first_word<'a>(s: &'a str) -> &'a str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}
```
][
rule 3 does not apply here:
```rust
fn first_word<'a>(s: &'a str) -> &'a str {
    let bytes = s.as_bytes();
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    &s[..]
}
```
]
]


#slide(title: "Lifetime annotations in method definitions")[
```rust
impl<'a> Person<'a> {
    fn age(&self) -> i32 {
        *self.age
    }

    fn name(&self) -> &'a str {
        self.name
    }
}
```
#begin(2)[
- without the explicit annotation `'a` the returned `&str` would have the same lifetime as `&self`
- in some cases `'a` can be longer than liveness scope of self  
]
]

#slide(title: "The static lifetime")[
- special lifetime `'static` is valid over the length of the whole program
```rust
let s: &'static str = "I have a static lifetime.";
```
- string slices are embedded in programs binary theref is always available
]

