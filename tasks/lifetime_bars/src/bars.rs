use super::distribution::Distribution;
pub const HEIGHT: usize = 20;

pub struct Bars<'a> {
    width: i32,
    values: [i32; HEIGHT],
    patterns: [&'a str; HEIGHT],
}

impl<'b> Bars<'b> {
    pub fn new(pattern: &str) -> Bars {
        Bars {
            width: 60,
            values: [0; HEIGHT],
            patterns: [pattern; HEIGHT]
        }
    }

    pub fn change_pattern(&mut self, index: usize, pattern: &'b str) {
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
                let to_print = {
                    let length = self.patterns[i].chars().count();
                    let index = j as usize % length;
                    self.patterns[i].chars().nth(index).unwrap()
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
            self.patterns[j] = "/";
        }
        if self.values[j] > 800 {
            self.patterns[j] = "/¯\\_";
        }
    }
}
