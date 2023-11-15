#import "slides.typ": *

#show: slides.with(
    authors: ("Hendrik Wolff", "Anton Obersteiner"), short-authors: "H&A",
    title: "Wer rastet, der rostet", short-title: "Rust-Kurs Lesson 3", subtitle: "Ein Rust-Kurs für Anfänger",
    date: "Sommersemester 2023",
)

#show "theref": $arrow.double$
#show link: underline


#new-section("C/++-Probleme")

#slide(title: "basic memory layout")[
  #table(
    columns: (1fr, 2.3fr, auto),
    inset: 7pt,
    //align: right,
    [*Bsp.-Start-Adresse*], [*name*], [*Wofür*],
    `0`,      ``,                   "bleibt frei",
    `2000`,   "Text/Code",          "Maschinencode des Programms",
    `6000`,   "Data",               "Globale Variablen",
    `9000`,   "Heap",               "Dynamische Variablen: `malloc`",
    `999000`, "Stack",              "Funktions-Lokale Variablen",
  )
  #uncover(2)[
  ```cpp
  int global = 0;
  int text (char local) {
    Object local_object; // stirbt mit Ende der Funktion
    Object* on_heap = malloc(sizeof(Object)); // existiert weiter
  }
  ```
  ]
]

#slide(title: "simple String-Klasse")[
  ```cpp
  /** wir wollen uns eine Klasse schreiben,
   * die einen String speichert und seine maximale Länge kennt.
   */
  class String {
  public:
    char* data;
    unsigned int size;
  ```
]

#slide(title: "Konstruktor: Geburt")[
  ```cpp
    // create space for a new String, with an initial capacity
    String (unsigned int size_request) {
      size = size_request;  // save the capacity/size

      printf("old data: '%s'\n", data);

      data = (char*) malloc (size);

      printf("new data: '%s'\n", data);
    }
  ```
]

#slide(title: "Destruktor: Tod")[
  ```cpp
    ~String () {
      free(data);
    }
  ```
]

#slide(title: "String speichern")[
  ```cpp
    // neuen text kopieren und dann data darauf zeigen lassen
    void write (char* text, const int length) {
      char new_data[length];  

      sprintf(new_data, "%s", text);  // schreibt text in den Puffer new_data

      data = &(new_data[0]);  // data zeigt jetzt auf den Anfang von new_data
      size = length; // update size of data
    }
```
]

#slide(title: "printing itself")[
  ```cpp
    void print () const {
      printf("%s", data);
      // oder (warum verhält sich das unterschiedlich?)
      printf("%s\n", data);
    }
  };
  ```
]

#slide(title: "main(), erste Hälfte")[
  ```cpp
  int main(int argc, const char* argv[]) {
    String my_string (64);  // create String with 64 Bytes Space
  
    char* some_data;
    if (argc > 2) { // just any condition
      some_data = my_string.data; 
    } else {
      some_data = (char*) malloc (64); 
    }

    printf("Please write your favorite color: ");
    scanf("%s", some_data); // read a line from user into buffer
    printf("Thank you.\n");
```
]

#slide(title: "main(): zweite Hälfte")[
  ```cpp

    // find length of string and write that into my_string
    my_string.write(some_data, strlen(some_data));
    printf("You said your favorite color was: ");
    my_string.print();
    printf("\n");

    free(some_data); // potential double free
  }
  ```
]

#slide(title: "typische Ausführung")[
  ```cpp

  /** Funktioniert nur deswegen halbwegs, weil Speicher
   * null-initialisiert ist und printf bisschen was abfängt.
  $ g++ kaputt.cpp -o kaputt && ./kaputt
  old data: '(null)'
  new data: ''
  Please write your favorite color: null_ptr
  Thank you.
  You said your favorite color was: 'null_ptr'
  free(): invalid size
  Aborted (core dumped)
   */
  ```
]
