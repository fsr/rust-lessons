use std::fmt;

#[derive(Debug)]
enum TrainType {
    Regional,
    ICE,
}
#[derive(Debug)]
enum Transport {
    Tram(i32),
    Bus(i32),
    Train(TrainType, i32),
}
#[derive(Debug)]
struct Time(u8, u8);
impl fmt::Display for Time {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:02}:{:02}", self.0, self.1)
    }
}

#[derive(Debug)]
struct StopAndTime {
    transport: Transport,
    time: Time,
}
#[derive(Debug)]
struct Stop {
    name: &'static str,
    stops: Vec<StopAndTime>,
}
impl Stop {
    fn empty(name: &'static str) -> Stop {
        Stop {
            name,
            stops: Vec::<StopAndTime>::new()
        }
    }
    fn new(name: &'static str, stops: Vec<StopAndTime>) -> Stop {
        Stop {
            name,
            stops,
        }
    }
    fn list_stops(&self) {
        for stop in self.stops.iter() {
            println!("  {} – {:?}", stop.time, stop.transport);
        }
    }
}
impl fmt::Display for Stop {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Stop '{}':", self.name)
    }
}

fn main() {
    let stops = vec!(
        StopAndTime { transport: Transport::Tram(10), time: Time(12, 15) },
        StopAndTime { transport: Transport::Tram(3),  time: Time(12, 18) },
    );
    let stop = Stop::new("Münchner Platz", stops);
    println!("{}", stop);
    stop.list_stops();
}
