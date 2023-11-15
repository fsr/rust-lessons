use super::distribution::Distribution;
pub const HEIGHT: usize = 20;

pub struct Bars {
    width: i32,
    values: [i32; HEIGHT],
}

impl Bars {
    pub fn new(width: i32) -> Bars {
        Bars {
            width,
            values: [0; HEIGHT],
        }
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

            for _ in 0..scaled {
                print!("#");
            }
            println!(" {}", value);
        }
    }

    pub fn grow(&mut self, dist: &Distribution) {
        let r = rand::random::<f32>() % 1.0f32;
        for i in 0..HEIGHT {
            let x = (i as f32) / (HEIGHT as f32);
            if r <= dist.cumulated(x, HEIGHT) {
                self.values[i] += 1;
                break;
            }
        }
    }
}
