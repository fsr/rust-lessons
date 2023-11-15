#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 1", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Vorgeplänkel")

#slide(title: "Hört ihr Prog?")[
  - Zielgruppe: 2tes Semester
  - wir setzen Basics voraus

  - sind wir zu schnell?
  - oder ist euch langweilig?
  theref redet mit uns
]

#slide(title: "Voraussetzungen")[
  - WSL / Linux / Dual Boot

  - `rustup`: Verwaltet Rust-Compiler, -Packaging usw.
    - #link("https://rustup.rs/")
  - `rustc` *der* Rust-Compiler
  - `cargo` build system und package manager
]

#slide(title: "Initiales toolchain setup mit rustup")[
  #one-by-one[
  ```shell
  curl -sSf https://sh.rustup.rs -o rustup.sh
  sha256sum rustup.sh
  # Ausgabe sollte sein (Stand 2023-04-20):
  # 41262c98ae4effc2a752340608542d9fe411da73aca5fbe947fe45f61b7bd5cf
  ```
  ][
  ```shell
  less rustup.sh # ansehen, was das Skript ausführt
  sh rustup.sh # starte Installation
  ```
  ][
  ```shell
  rustup default stable # set default toolchain
  rustc --version
  ```
  ]
]

#slide(title: "Editoren mit Rust-Support")[
  == GUI
  - #link("https://www.jetbrains.com/clion/")[CLion + Rust plugin]
  - vscode / vscodium (+ rust_analyzer plugin)

  #uncover(2)[
  == TUI
  - #link("https://helix-editor.com/")[helix]
  - vim / neovim
  - emacs
  ]
]

#slide(title: "Start a new project with cargo")[
  - `cargo new lesson1` erstellt ein neues Rust Projekt im Ordner `lesson1`
  - `cd lesson1`
  - `cargo check` prüft Kompilerbarkeit
  - `cargo build` kompiliert
  - `cargo run` führt aus
]

#slide(title: "Projektstruktur")[
  #columns(2)[
  Ordnerstruktur eines Rust Projektes:
  ```
  ├── Cargo.lock
  ├── Cargo.toml
  ├── src
  │   └── main.rs
  └── target
      ├── ...
  ```

  #colbreak()
  entry point eines Rust Programms ist die `main` Funktion in der `src/main.rs` Datei:
  ```rust
  // src/main.rs
  fn main() {
      // your code goes here
  }
  ```
  ]
]

#slide(title: "Rust Tooling Overview")[
  - `rustfmt` formatter
  - `clippy` Linter (Annotiert euren Code beim Schreiben)
  - `rustdoc` documentation builder
  - `rust_analyzer` language server (für IDEs)
]

#slide(title: "Helpful resources")[
  - #link("https://doc.rust-lang.org/stable/book/")[the Rust book]
  - #link("https://github.com/rust-lang/rustlings")[rustlings excercises]
  - #link("https://doc.rust-lang.org/rust-by-example/")[Rust by Example]
  - #link("https://play.rust-lang.org/")[Rust Playground]
]

#slide(title: "rustc error messages")[
  #set text(size: 2em)
  Der compiler ist dein Freund. \
  Er hilft dir. \
  Lies die error messages.
]

#new-section("Basics")

#slide(title: "Skalare Typen")[

  #table(
    columns: (1fr, 2.3fr, auto),
    inset: 7pt,
    //align: right,
    [*Rust*], [*C*], [*Beispiel*],
    `u8`,     `char`,               `b'A', 0b01000001`,
    `i8`,     `signed char`,        `-127`,
    `u128`,   `long long unsigned`, `0xCOFFEE, 1_234_567_890`,
    `usize`,  `unsigned`,           `0usize`,
    `isize`,  `int, ssize_t`,       `12, -2`,
    `f32`,    `float`,              `let pi = 3.1415927f32;`,
    `f64`,    `double`,             `let pi: f64 = 3.141592653589793;`,
    `char`,   `wchar`,              `'A', 'ß'`,
    `bool`,   `int, bool`,          `true, false`
  )
]

#slide(title: "Quiz 1: Typen", theme-variant: "action")[
  #let rr = raw.with(lang: "rust")
  Maximaler Wert von #rr("i32")? \
  #uncover("2-")[theref #rr("4_294_967_295")]
  \ \

  Kompiliert das?
  ```rust
   let pi = 3.1415f32;
   let pi: f64 = 3.1415;
  ```
  #uncover("3-")[theref Ja]
]

#slide(title: "Compound Typen")[
  #one-by-one[
  ```rust
  let tuple: (i16, char, f32) = (-1_001, 'Σ', 21.593);
  let empty_tuple: () = (); // is called a "unit"
  ```
  ][
  ```rust
  let array_a: [u64; 3] = [45, 101, 14_834_920];
  println!("element on index 1 is: {}", array_a[1]);
  ```
  ][
  ```rust
  let array_b = [12u8; 4];
  let array_c: [u8; 4] = [12, 12, 12, 12];
  assert_eq!(array_b, array_c);
  ```
  ]
]

#slide(title: "Hilfreiche Macros")[
  #one-by-one[
  ```rust
  print!("write to stdout");
  println!("write to stdout with newline");
  ```
  ][
  ```rust
  println!("show me the value of my variable: {}", my_var);
  println!("show me the value of my variable with debug formatting: {:?}", my_var);
  println!("pretty print me the debug formatting of my variable: {:#?}", my_var);
  ```
  ][
  ```rust
  eprint!("write to stderr");
  eprintln!("write to stderr with newline");
  ```
  ][
  ```rust
  dbg!("write file name, line number, variable names and contents to stderr");
  ```
  ]
]

#slide(title: "Hilfreiche Macros")[
  ```rust
  let a = 3;
  let b = 4;

  assert!(a == 3);
  assert_eq!(a + 1, b); // eq => equal
  assert_ne!(a,b); // ne => not equal
  ```
]

#slide(title: "Variablen und Konstanten")[
  - Variablen werden mit `let` erstellt \
    `snake_case`
  - Konstanten werden mit `const` erstellt \
    `SCREAMING_SNAKE_CASE`

  ```rust
  let tutor_count: u32;    // Deklaration
  tutor_count = 4;         // Initialisierung
  let student_count = 30;  // Deklaration & Initialisierung
  const FIVE_MINUTES_IN_SECONDS: u32 = 5 * 60;
  ```
]

#slide(title: "Variablen und Mutability")[
  - Variablen sind immutable *by default* \
    theref Wert *kann nicht* verändert werden

  ```rust
  let x = 5;
  println!("The value of x is: {x}");
  x = 6; // compile error
  println!("The value of x is: {x}");
  ```
]

#slide(title: "Variablen und Mutability")[
  #one-by-one[
  - mit *`mut`* keyword als mutable/veränderbar deklarieren \
    theref Wert *kann* verändert werden

  ```rust
  let mut x = 5;
  println!("The value of x is: {x}");
  ```
  ][
  ```rust
  x = 6; // this works now
  println!("The value of x is: {x}");
  ```
  *theref explizite, optionale Veränderlichkeit*
  ]
]

#slide(title: "Scope und Shadowing")[
  #columns(2)[
  - Scope = Gültigkeitsbereich für Variablen
  - ein Scope beginnt mit `{` und endet mit `}`

  ```rust
  // x is not valid here
  fn main() { // start scope main function
      let x = 5; // x is now a valid variable
      println!("x is: {}", x); // theref 5
  ```

  #uncover(2)[
  ```rust
      let x = x + 1; // shadowing x
      println!("x is: {}", x); // theref 6
  ```
  ]

  ```rust
  } // end scope main function
  // x is not valid here
  ```

  #colbreak()
  #uncover(2)[
  - Shadowing = Überschreiben einer Variable bis zum Ende des scopes \
    theref ausschließlich mit immutable Variablen arbeiten
  ]]
]

#slide(title: "Quiz 2: Scope und Shadowing", theme-variant: "action")[
  Was gibt das Programm aus?
  ```rust
  let x = 5;
  let x = x + 1;
  {
      let x = x * 2;
      println!("value of x in inner scope: {x}");
  }
  println!("value of x: {x}");
  ```

  #show raw: it => block(
    fill: luma(230),
    inset: 8pt,
    radius: 4pt,
    it.text
  )
  #uncover(2)[
    ```
    value of x in inner scope: 12
    value of x: 6
    ```
  ]
]

#slide(title: "Mutability vs Shadowing")[
  #one-by-one[
  - Typ einer mutable Variable kann *nicht* verändert werden
  - `mut` bezieht sich nur auf enthaltenen Wert
  ```rust
  let mut spaces = "   ";
  spaces = spaces.len(); // compile error
  ```
  \
  ][
  - Shadowing mit `let` deklariert neue Variable mit neuem Typen \
    theref gleichen Name wiederverwenden
  ```rust
  let spaces = "   ";
  let spaces = spaces.len(); // creates new variable
  ```
  ]
]

#slide(title: "Exercise 1: Elementares Wissen über arrays", theme-variant: "action")[
  Erstelle ein Array mit mindestens 4 Elementen.
  Lies einen Index ein und gib das Element des Arrays an diesem Index aus.
  Nutze den folgenden Code, um den Index einzulesen.

  Zusatz: Ersetze `usize` durch einen anderen Integer-Typen. Was passiert?

  Gib verschiedene Indize ein und versuche vorherzusagen, was passiert.
  ```rust
  let mut index = String::new();       //erstellt leeren String
  std::io::stdin()                     //Standard-Input lesen: Termimal
      .read_line(&mut index)           //schreibt in den String index
      .expect("Failed to read line");  //Text für Fehler

  let index: usize = index
      .trim()                          //Leerzeichen etc. weg
      .parse()                         //daraus usize machen
      .expect("Index entered was not a number");  //Text für Fehler
  ```
]
