pub mod bars;
pub mod distribution;

fn ramp(x: f32) -> f32 {
    2.0 * x
}

fn main() {
    let mut data = bars::Bars::new(60);
    let distr = distribution::Distribution::new(ramp);
    for i in 0..10 {
        for _j in 0..1000 {
            data.grow(&distr);
        }
        println!("round {}", i * 10);
        data.print();
    }
}
