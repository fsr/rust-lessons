// this program should be called like this:
// minigrep query file.txt
//
// and then prints all lines in the file that contain 'query'.
//
// we can do:
// cargo run -- query file.txt

fn main() {
    let args: Vec<String> = std::env::args().collect();
    // why Vec<String>? could it not be Vec<&str>?
    // how to convert them to a vector?

    let query = if args.len() > 1 { &args[1] } else { ", " };
    let file_path = if args.len() > 2 { &args[2] } else { "poem.txt" };

    println!("Searching for {}", query);
    println!("In file {}", file_path);

    let mut lines = get_file_lines(file_path)
        .take_while(|r| !r.is_err())
        .map(|r| r.unwrap().into_boxed_str());
    /*
    let contents = lines.fold(
        String::new(),
        |mut b, n| {
            b.push_str(&n);
            b.push('\n');
            b
        }
    );
    for line in grep_string(&contents, &query) {
    */

    for line in grep(&mut lines, &query) {
        println!("{}", line);
    }
}

use std::io::BufReader;
use std::io::BufRead;
use std::fs::File;

fn get_file_lines(file_path: &str) -> impl Iterator<Item = std::io::Result<String>> {
    let file = File::open(file_path).unwrap();
    let reader = BufReader::new(file);

    reader.lines()
}
fn grep_string<'a>(
    content: &'a str,
    query: &'a str
) -> impl Iterator<Item = &'a str> {
    content.lines().filter(move |l| l.contains(query))
}
fn grep_ref<'a>(
    lines: &'a mut impl Iterator<Item = &'a str>,
    query: &'a str
) -> impl Iterator<Item = &'a str> + 'a {
    lines.filter(move |l| l.contains(query))
}
fn grep<'a>(
    lines: &'a mut impl Iterator<Item = Box<str>>,
    query: &'a str
) -> impl Iterator<Item = Box<str>> + 'a {
    lines.filter(move |l| l.contains(query))
}

#[test]
fn test_grep() {
    let text = "test123\nnext line\nand more test...\n";
    let mut grepped = grep_string(text, "test");
    assert_eq!(grepped.next(), Some("test123"), "");
    assert_eq!(grepped.next(), Some("and more test..."), "");
    assert_eq!(grepped.next(), None, "");

    let mut lines = text.lines();
    let mut grepped = grep_ref(&mut lines, " ");
    assert_eq!(grepped.next(), Some("next line"), "");
    assert_eq!(grepped.next(), Some("and more test..."), "");
    assert_eq!(grepped.next(), None, "");
}
