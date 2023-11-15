use std::fmt;

#[derive(Debug)]
struct Rect {
    width: i32,
    height: i32,
}

impl fmt::Display for Rect {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "R{{{}x{}}}", self.width, self.height)
    }
}

impl Rect {
    fn new(width: i32, height: i32) -> Rect {
        Rect {
            width,
            height,
        }
    }

    fn area(&self) -> i32 {
        self.width * self.height
    }

    fn can_contain(&self, other: &Self) -> bool {
        self.width >= other.width && self.height >= other.height
    }
}

fn main() {
    let a = Rect::new(5, 3);
    let b = Rect::new(4, 3);
    let c = Rect::new(4, 4);

    println!("|{:?}|: {}", a, a.area());
    println!("|{}|: {}", a, a.area());
    println!("|{}|: {}", b, b.area());
    println!("|{}|: {}", c, c.area());
    println!("{} > {}: {}", a, b, a.can_contain(&b));
    println!("{} > {}: {}", a, c, a.can_contain(&c));
    println!("{} > {}: {}", b, c, b.can_contain(&c));
}
