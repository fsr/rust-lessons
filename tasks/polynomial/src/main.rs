pub mod polynomial;

use polynomial::Polynomial;

fn main() {
    let poly = Polynomial::from(10, &vec![1, 2, 3]);
    let moly = Polynomial::from(10, &vec![5, 1]);
    println!("Hello, {:?}!", &poly + &moly);
    println!("Hello, {}!", &moly + &poly);
}
