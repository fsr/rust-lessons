use super::bars::HEIGHT;

pub struct Distribution {
    density: fn(f32) -> f32,
    area: f32,
}

impl Distribution {
    pub fn new(density: fn(f32) -> f32) -> Distribution {
        let mut result = Distribution { density, area: 1.0 };
        result.area = result.cumulated(1.0f32, HEIGHT);
        result
    }

    pub fn cumulated(&self, x: f32, samples: usize) -> f32 {
        let mut sum = 0f32;
        let step = 1.0f32 / ((samples - 1) as f32);
        let j = (x / step) as usize;
        for i in 0..j {
            sum += (self.density)((i as f32) * step);
        }
        sum / self.area
    }
}
