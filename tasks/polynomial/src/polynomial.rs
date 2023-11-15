use std::vec::Vec;
use std::ops::Add;
use std::fmt;

#[derive(Debug, Clone, PartialEq)]
pub struct Polynomial {
    base: i8,
    values: Vec::<u64>,
}

impl Polynomial {
    pub fn new (base: i8) -> Polynomial {
        Polynomial {
            base,
            values: Vec::<u64>::new(),
        }
    }
    pub fn from (base: i8, values: &Vec::<u64>) -> Polynomial {
        Polynomial {
            base,
            values: values.clone()
        }
    }
}

impl fmt::Display for Polynomial {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[")?;
        let val_len = self.values.len();
        if self.values.len() > 0 {
            write!(f, "{}", self.values[val_len - 1])?;
        }
        for i in 2..val_len+1 {
            write!(f, " {}", self.values[val_len - i])?;
        }
        write!(f, "]")
    }
}

impl Add for &Polynomial {
    type Output = Polynomial;

    fn add(self, other: Self) -> Polynomial {
        if self.base != other.base {
            panic!("bases of {:?} and {:?} incompatible!", self, other);
        }
        let mut result = (*self).clone();
        if other.values.len() > result.values.len() {
            let len_diff = other.values.len() - result.values.len();
            result.values.reserve(len_diff);
            for _ in 0..len_diff {
                result.values.push(0);
            }
        }

        for i in 0..other.values.len() {
            result.values[i] += other.values[i];
        }
        result
    }
}

