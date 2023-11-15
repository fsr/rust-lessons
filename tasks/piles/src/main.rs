const N: usize = 20;
const WIDTH: i32 = 60; // max width of the bar plots

fn get_max_pile (piles: &[i32; N]) -> i32 {
    let mut max_pile = -1;
    for p in 0..N {
        if piles[p] > max_pile {
            max_pile = piles[p];
        }
    }
    return max_pile;
}

fn print_piles (piles: [i32; N]) {
    let max_pile = get_max_pile(&piles);
    for p in 0..N {
        let pile = piles[p];
        let scaled = if max_pile > WIDTH {
            WIDTH * pile / max_pile
        } else {
            pile
        };

        for _ in 0..scaled {
            print!("#");
        }
        println!(" {}", pile);
    }
}

fn distribution (p: usize) -> f32 {
    let area = (N * N) as f32;
    return (p as f32) / (area / 2f32);
}

fn cumulated (p: usize) -> f32 {
    let mut sum = 0f32;
    for i in 0..p {
        sum += distribution(i);
    }
    return sum;
}

fn add_to_piles (piles: &mut [i32; N]) {
    let r = rand::random::<f32>() % 1.0f32;
    for p in 0..N {
        if r <= cumulated(p) {
            piles[p] += 1;
            break;
        }
    }
}

fn main() {
    let mut piles = [0i32; N];
    for i in 0..10 {
        for _j in 0..1000 {
            add_to_piles(&mut piles);
        }
        println!("round {}", i*10);
        print_piles(piles);
    }
}
