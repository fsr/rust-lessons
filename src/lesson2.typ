#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 2", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("Basics")

#slide(title: "Funktionen")[
  #uncover("2-")[Nutzt aussagekräftige Variablennamen!]
  #only(1)[
  ```rust
  fn spass_mit_funktionen() {
      let right = 17;
      let light = seven();
      println!("adding {left} and {right}: {}", add(left, right));
  }
  fn add(l: u8, r: u8) -> u8 {
      return left + right;
  }
  fn seven() -> u8 {
      7 // implicit return
  }
  ```
  ]
  #only("2-")[
  ```rust
  fn spass_mit_funktionen() {
      let right = 17;
      let left = seven();
      println!("adding {left} and {right}: {}", add(left, right));
  }
  fn add(left: u8, right: u8) -> u8 {
      return left + right;
  }
  fn seven() -> u8 {
      7 // implicit return
  }
  ```
  ]
  #uncover(3)[
  ```rust
  let closure = |param1, param2| { /* function body*/ };
  ```
  ]
]

#slide(title: "Quiz 3: return", theme-variant: "action")[
  Was wird passieren, wenn diese funktionen aufgerufen werden?
  ```rust
  fn add_two_a(a: u32) -> u32 {
      return a + 2;
  }
  fn add_two_b(b: u32) -> u32 {
      b + 2;
  }
  fn add_two_c(c: u32) -> u32 {
      c + 2
  }
  ```
  #uncover(2)[theref #text(red)[compilation error!]]
]

#slide(title: "Comments")[
  ```rust
  // This is a comment.  Multi-line comments
  // generally are written this way.
  
  /* You can use this style of comment too. */
  
  /// This is a doc comment.
  ```
]

#slide(title: "Statements und Expressions")[
  #columns(2)[
  Statements: \
  Instruktionen ohne return Wert
  ```rust
  let a = 2; /*
  ^^^^^^^^^^ statement */
  println!("Hello students!"); /*
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ statement */
  fn goodbye() -> () {
      println!("Goodbye");
  }
  ```
  #uncover("2-")[
  ```rust
  // `-> ()` is implicit
  fn goodbye() /* no return */ {
      println!("Goodbye");
  }
  ```
  ]

  #colbreak()
  #uncover(3)[
  Expressions: \
  evaluieren zu einem Wert
  ```rust
  fn add_one(a: i32) -> i32 {
      a + 1
  //  ^^^^^ expression
  }
  let n = add_one(2);
  /*      ^^^^^^^^^^ expression
  ^^^^^^^^^^^^^^^^^^^ statement
  */
  ```
  ]
  ]
]

#slide(title: "Statements und Expressions")[
  ```rust
  let a = 3;
  let b = {
      let a = a + 1;
      a * 4
  };
  ```
  #uncover(2)[
  ```rust
  let c = if a > 3 { a - 2 } else { a + 4 }; /*
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          |____ expression
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |____ statement */
  ```
  ]
]

#slide(title: "Control flow - branching mit if und else")[
  ```rust
  if students < 10 {
      println!("Kein Rust Kurs :(");
  } else if students > 30 {
      println!("Raum überfüllt!!");
  } else {
      println!("Rust Kurs findet statt :D");
  }
  ```
]

#slide(title: "Übung 2: Fibonacci", theme-variant: "action")[
  Berechne die `n`-te Fibonacci-Zahl mit Hilfe einer rekursiven Funktion. \
  Verwende dabei `u16` und ein implicit `return`. \
  Zusatz: Verwende gar kein `return`.

  Gib deiner Fibonacci-Funktion Zahlen zwischen 0 bis 50. \
  Starte dein Programm mit `cargo run`.
  Was passiert und warum?

  #columns(2, gutter: -20%)[
  #uncover("2-")[
    ```rust
    fn fib(n: u16) -> u16 {
        if n <= 1 {
            return 1;
        }
        fib(n - 1) + fib(n - 2)
    }
    ```
  ]

  #colbreak()
  #uncover(3)[
    ```rust
    fn fib_no_return(n: u16) -> u16 {
        if n <= 1 {
            1
        } else {
            fib_no_return(n - 1) + fib_no_return(n - 2)
        }
    }
    ```
  ]
  ]
]

#slide(title: "Control flow - loops")[
  #columns(2)[
  Endlosschleife
  ```rust
  loop {
      println!("HEYYEYAAEYAAAEYAEYAA");
  }
  ```
  #uncover("2-")[
  ```rust
  let mut counter = 0;
  let n = loop {
      counter += 1;
      if counter % 2 == 1 {
          println!("yes");
      } else if counter % 4 == 3 {
          continue;
      } else if counter > 20 {
          break counter + 2;
      }    
  }
  ```
  ]

  #colbreak()
  #uncover("3-")[
  Konditionalschleife
  ```rust
  let mut counter = 5;
  while counter >= 0 {
      counter -= 1;
      println!("no");
  }
  ```
  Wieviele "no" gibt das aus? \
  ]
  #uncover(4)[
  theref 6
  ]]
]

#slide(title: "Control flow - loops")[
  Über Elemente eines arrays iterieren.
  #columns(2)[
  `while`-Schleife
  ```rust
  let arr = [1, 2, 3, 4, 5];
  let mut idx = 0;
  while idx < arr.len() {
      println!("{}", arr[idx]);
      index += 1;
  }
  ```

  #colbreak()
  #uncover(2)[
  `for`-Schleife
  ```rust
  let arr = [1, 2, 3, 4, 5];
  for element in arr {
      println!("{element}");
  }
  ```
  ]]
]

#slide(title: "Quiz 4: Control flow - labeled loops", theme-variant: "action")[
  #columns(2)[
  Labeled loops
  ```rust
  let mut counter = 0;
  let x = 'outer: loop {
      'inner: loop {
          counter += 2;
          if counter > 2 {
              break 'outer counter * 4;
          } else {
              counter -= 1;
          }
      }
  }
  ```
  #colbreak()
  #uncover("2-")[
  Welchen Wert hat `x` am Ende?
  ]

  #uncover(3)[
  theref 12
  ]]
]

#slide(title: "Control flow - loops")[
  Über eine range von Zahlen iterieren.
  #columns(2)[
  _rechts-offene range_
  ```rust
  for n in 1..4 {
      println!("{n}");
  }
  ```
  `[1,4)` theref 1, 2, 3

  #colbreak()
  #uncover(2)[
  _rechts-geschlossene range_
  ```rust
  for n in 1..=4 {
      println!("{n}");
  }
  ```
  `[1,4]` theref 1, 2, 3, 4
  ]]
]

#slide()[]