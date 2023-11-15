use std::vec::Vec;
use std::ops::{Add, AddAssign, Mul, MulAssign};

#[derive(Debug, Clone)]
struct LongNumber {
    data: Vec<u32>,
}

impl LongNumber {
    fn new() -> LongNumber {
        LongNumber {
            data: Vec::new()
        }
    }
    fn from(val: u128) -> LongNumber {
        let power32 = 1u128 << 32;
        let lowest  = val % power32; let val = val / power32;
        let second  = val % power32; let val = val / power32;
        let third   = val % power32; let val = val / power32;
        let highest = val % power32; let val = val / power32;
        LongNumber {
            data: vec![
                lowest as u32,
                second as u32,
                third as u32,
                highest as u32
            ]
        }
    }
    fn shrink(&mut self) {
        while (self.data.len() > 1) && (*(self.data.last().unwrap()) == 0) {
            self.data.pop();
        }
    }
}
impl AddAssign<&LongNumber> for LongNumber {
    fn add_assign (&mut self, other: &LongNumber) {
        // make sure self has enough space
        if other.data.len() > self.data.len() {
            self.data.resize(other.data.len(), 0);
        }

        let mut carry = 0u64;
        for i in 0..self.data.len() {
            carry += self.data[i] as u64;
            carry += if i < other.data.len() {
                other.data[i] as u64 } else { 0 };
            self.data[i] = (carry & 0xffffffff) as u32;
            carry = carry >> 32;
        }
        self.shrink();
    }
}
impl AddAssign<LongNumber> for LongNumber {
    fn add_assign (&mut self, other: Self) {
        self.add_assign(&other);
    }
}
impl Add<&LongNumber> for &LongNumber {
    type Output = LongNumber;

    fn add (self, other: &LongNumber) -> LongNumber {
        let mut result = (*self).clone();
        result += other;
        return result;
    }
}

impl Add<LongNumber> for LongNumber {
    type Output = LongNumber;

    fn add (self, other: LongNumber) -> LongNumber {
        let mut result = self.clone();
        result += other;
        return result;
    }
}
impl MulAssign<u32> for LongNumber {
    fn mul_assign (&mut self, other: u32) {
        // make sure self has enough space
        self.data.push(0);

        let mut carry = 0u64;
        for i in 0..self.data.len() {
            carry += (self.data[i] as u64) * (other as u64);
            self.data[i] = (carry & 0xffffffff) as u32;
            carry = carry >> 32;
        }
        self.shrink();
    }
}
impl Mul<u32> for &LongNumber {
    type Output = LongNumber;

    fn mul (self, other: u32) -> LongNumber {
        let mut result = (*self).clone();
        result *= other;
        return result;
    }
}
impl MulAssign<&LongNumber> for LongNumber {
    fn mul_assign (&mut self, other: &LongNumber) {
        // make sure self has enough space
        let max_len = self.data.len() + other.data.len() + 1;
        let old = self.clone();
        self.data = Vec::with_capacity(max_len);
        self.data.resize(max_len, 0);

        for i in 0..self.data.len() {
            let mut part = LongNumber {
                data: Vec::with_capacity(max_len)
            };
            part.data.resize(i, 0);
            part.data.extend(old.data.iter());
            if i < other.data.len() {
                *self += &old * other.data[i];
            };
        }
        self.shrink();
    }
}
impl MulAssign<LongNumber> for LongNumber {
    fn mul_assign (&mut self, other: Self) {
        self.mul_assign(&other);
    }
}
impl Mul<&LongNumber> for &LongNumber {
    type Output = LongNumber;

    fn mul (self, other: &LongNumber) -> LongNumber {
        let mut result = (*self).clone();
        result *= other;
        return result;
    }
}

impl Mul<LongNumber> for LongNumber {
    type Output = LongNumber;

    fn mul (self, other: LongNumber) -> LongNumber {
        let mut result = self.clone();
        result *= other;
        return result;
    }
}

fn main() {
    let a = LongNumber::from(10000);
    let b = LongNumber::from(20000);
    let e = LongNumber::from(12345678901234567890);
    let mut c = &a + &b;
    println!("Hello, {:?} + {:?} = {:?}!", a, b, c);
    c += &a;
    println!(" += {:?} == {:?}!", a, c);
    println!("Hello, {:?} + {:?} = {:?}!", a, e, &a + &e);

    println!("Hello, {:?} * 5 = {:?}!", a, &a * 5);
    let mut d = &a * &b;
    println!("Hello, {:?} * {:?} = {:?}!", a, b, d);
    d *= &a;
    println!(" *= {:?} == {:?}!", a, d);
}
