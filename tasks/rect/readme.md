# Task 'rect'

from lesson 4

- create a `struct Rect` with `width` and `height`
- derive Debug so that `println!("r: {:?}", r);`, looks like (a)
- implement `fmt::Display` for it so you can easily `print!("{}", r)` it
- create some, maybe implement `Rect::new(...)`
- implement `r.area()` and check if it works
- implement `r.can_contain(other)` to compare two rectangles
- implement `r.draw()` to print some `#`s

(a)
```
r: Rect { width: 5, height: 3 }
```
(b)
```
r: Rect(5 x 3)
s: Rect(4 x 3)
r.area(): 15
r.can_contain(s): true
s.can_contain(r): false
#####
#####
#####
```
