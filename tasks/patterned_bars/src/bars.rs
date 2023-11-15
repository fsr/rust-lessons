use super::distribution::Distribution;
pub const HEIGHT: usize = 20;

#[derive(Clone, Copy)]
pub enum Pattern {
    Normal,
    Single(char),
    Multiple(&'static str),
}

pub struct Bars {
    width: i32,
    values: [i32; HEIGHT],
    normal_pattern: char,
    patterns: [Pattern; HEIGHT],
}

impl Bars {
    pub fn new(width: i32) -> Bars {
        Bars {
            width,
            values: [0; HEIGHT],
            normal_pattern: '#',
            patterns: [Pattern::Normal; HEIGHT]
        }
    }

    pub fn change_pattern(&mut self, index: usize, pattern: Pattern) {
        self.patterns[index] = pattern;
    }

    pub fn get_max(&self) -> i32 {
        let mut max_pile = -1;
        for p in 0..HEIGHT {
            if self.values[p] > max_pile {
                max_pile = self.values[p];
            }
        }
        max_pile
    }

    pub fn print(&self) {
        let max_value = self.get_max();
        for i in 0..HEIGHT {
            let value = self.values[i];
            let scaled = if max_value > self.width {
                self.width * value / max_value
            } else {
                value
            };

            for j in 0..scaled {
                let to_print = match self.patterns[i] {
                    Pattern::Normal => self.normal_pattern,
                    Pattern::Single(ch) => ch,
                    Pattern::Multiple(string) => {
                        let length = string.chars().count();
                        let index = j as usize % length;
                        string.chars().nth(index).unwrap()
                    }
                };
                print!("{}", to_print);
            }
            println!(" {}", value);
        }
    }

    pub fn grow(&mut self, dist: &Distribution) {
        let r = rand::random::<f32>() % 1.0f32;
        let mut j = 0;
        for i in 0..HEIGHT {
            let x = (i as f32) / (HEIGHT as f32);
            if r <= dist.cumulated(x, HEIGHT) {
                self.values[i] += 1;
                j = i;
                break;
            }
        }
        if self.values[j] > 500 {
            self.patterns[j] = Pattern::Single('/');
        }
        if self.values[j] > 800 {
            self.patterns[j] = Pattern::Multiple("/¯\\_");
        }
    }
}
