pub mod bars;
pub mod distribution;

fn ramp(x: f32) -> f32 {
    2.0 * x
}

fn main() {
    println!("give me a pattern: ");
    let mut user_pattern = String::new();
    std::io::stdin()
        .read_line(&mut user_pattern)
        .expect("Failed to read line");
    user_pattern.pop();

    let mut data = bars::Bars::new(&user_pattern);
    data.change_pattern(10, &user_pattern);
    let distr = distribution::Distribution::new(ramp);
    for i in 0..10 {
        for _j in 0..1000 {
            data.grow(&distr);
        }
        println!("round {}", i * 10);
        data.print();
    }
}
