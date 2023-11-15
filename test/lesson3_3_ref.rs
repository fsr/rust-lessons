fn main() {
    let mut s = String::from("hello");
    let ref1 = &s;  // why is this not allowed?
    append_world(&mut s);
    // println!("|{}|", ref1); // slide: Scope of References
    let len = get_length(&s);
    println!("|{}| == {}", s, len);
}

fn get_length(some_string: &String) -> usize {
    println!("{}", some_string);
    some_string.len()
}

fn append_world(some_string: &mut String) {
    some_string.push_str(", world!");
}
