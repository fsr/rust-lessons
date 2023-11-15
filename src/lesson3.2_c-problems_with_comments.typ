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
  /* wir wollen uns eine Klasse schreiben,
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
    // einen String mit Anfangs-Kapazität erstellen
    String (unsigned int size_request) {
      size = size_request;  // save the capacity/size

  ``` #uncover("2-")[```cpp
        // bei was anderem als printf: SegFault, uninitialized pointer
        // hier: printet '(null)' weil printf data == 0 bemerkt
        // Compiler beschwert sich nicht
  ```] ```cpp
      printf("old data: '%s'\n", data);

  ``` #uncover("3-")[```cpp
        // geforderten Platz auf Heap belegen, sehr gut
  ```] ```cpp
      data = (char*) malloc (size);

  ``` #uncover("4-")[```cpp
        // printed bis zum ersten Null-Byte,
        // also einfach random Speicherinhalt
        // Compiler könnte uns warnen, dass in data irgendwas steht
        // in C++ ist das aber ein Risiko, vor dem uns niemand schützt
  ```] ```cpp
        printf("new data: '%s'\n", data);
      }
  ```
]

#slide(title: "Destruktor: Tod")[
  ```cpp
    ~String () {
  ``` #uncover(2)[```cpp
      // Speicher frei-/zurückgeben, sehr gut
  ```] ```cpp
      free(data);
    }
  ```
]

#slide(title: "String speichern")[
  ```cpp
      // neuen text kopieren und dann data darauf zeigen lassen
      void write (char* text, const int length) {
  ``` #uncover("2-")[```cpp
        // grundsätzlicher Fehler: new_data ist lokal, also auf dem Stack
        // außerdem: Platz für Null-Byte fehlt
  ```] ```cpp
      char new_data[length];

      sprintf(new_data, "%s", text);  // schreibt text in den Puffer new_data

  ``` #uncover("3-")[```cpp
        // data nicht freed :/
        // rest ist an sich ~ok~
  ```] ```cpp
      data = &(new_data[0]);  // data zeigt jetzt auf den Anfang von new_data
      size = length; // update size of data
    }
```
]

#slide(title: "printing itself")[
  ```cpp
    void print () const {
  ``` #uncover("2-")[```cpp
      // printf muss hier nicht viel machen, legt deswegen wenig stack an
      // und überschreibt new_data nicht, weswegen es kein Symptom gibt
  ```] ```cpp
      printf("%s", data);
  ``` #uncover("3-")[```cpp
      // printf("%s\n", data); verwendet tatsächlich stack und schreibt
      // @`J'J'
      // '@@oԽ'
      // und so ähnliches
  ```] ```cpp
    }
  };
  ```
]

#slide(title: "main(), erste Hälfte")[
  ```cpp
  int main(void) {
    // String mit 64 Bytes Platz, aber Länge 0 erstellen
    String my_string (64);

    char* some_data;
    if (my_string.size >= 64) {
  ``` #uncover("2-")[```cpp
      // borrow data from my_string
  ```] ```cpp
      some_data = my_string.data;
    } else {
  ``` #uncover("3-")[```cpp
      // neu allozieren
  ```] ```cpp
    some_data = (char*) malloc (64); 
  }

  printf("Please write your favorite color: ");
  scanf("%s", some_data); // Zeile vom Nutzer in den Puffer einlesen
  printf("Thank you.\n");
```
]

#slide(title: "main(): zweite Hälfte")[
  ```cpp

  // String some_data in my_string hineinschreiben, dazu Länge bestimmen
  my_string.write(some_data, strlen(some_data));
  printf("You said your favorite color was: ");
  my_string.print();
  printf("\n");


  ``` #uncover(2)[ ```cpp
    // ob some_data borrowed oder alloziert ist,
    // müsste man eigentlich extra checken, z.B. mit
    // if (my_string.size < 64)
  ```] ```cpp
    free(some_data); // möglicher 'double free'
  }
  ```
]

#slide(title: "typische Ausführung")[
  ```cpp

  /* Funktioniert nur deswegen halbwegs, weil Speicher
   * mit nullen initialisiert ist und printf bisschen was abfängt.
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
