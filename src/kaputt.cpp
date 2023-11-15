#include <cstdio>
#include <cstdlib>
#include <cstring>

/** wir wollen uns eine Klasse schreiben,
 * die einen Text speichert und seine Länge kennt.
 */
class String {
public:
	char* data;
	unsigned int size;

	// create a new String, with an initial capacity
	String (unsigned int size_request) {
		size = size_request;	// save the capacity/size

		// bei was anderem als printf: SegFault, uninitialized pointer
		// hier: printet '(null)' weil printf data == 0 bemerkt
		printf("old data: '%s'\n", data);

		// Platz belegen, sehr gut
		data = (char*) malloc (size);

		// printed bis zum ersten Null-Byte,
		// also einfach random Speicherinhalt
		printf("new data: '%s'\n", data);
	}
	~String () {
		// Speicher frei-/zurückgeben, sehr gut
		free(data);
	}

	// neuen text kopieren und dann data darauf zeigen lassen
	void write (char* text, const int length) {
		// grundsätzlicher Fehler: new_data ist lokal, also auf dem Stack
		char new_data[length];	// neuer Puffer, Platz für Null-Byte fehlt

		sprintf(new_data, "%s", text);	// schreibt text in den Puffer new_data

		// data nicht freed :/ daher 'free(): invalid size'

		// rest ist an sich ~ok~
		data = &(new_data[0]);	// data zeigt jetzt auf den Anfang von new_data
		size = length; // update size of data
	}

	void print () const {
		// printf muss hier nicht viel machen, legt deswegen wenig stack an
		// und überschreibt new_data nicht, weswegen es kein Symptom gibt
		printf("%s", data);
		// printf("%s\n", data); verwendet tatsächlich stack und schreibt
		// @`J'J'
		// '@@oԽ
		// und so ähnliches
	}
};

int main(void) {
	String my_string (64);	// create String with 64 Bytes Space

	char* some_data;
	if (my_string.size >= 64)
		some_data = my_string.data; // borrow data from my_string
	else
		some_data = (char*) malloc (64); // allocate newly

	printf("Please write your favorite color: ");
	scanf("%s", some_data); // read a line from user into buffer
	printf("Thank you.\n");

	// find length of string and write that into my_string
	my_string.write(some_data, strlen(some_data));
	printf("You said your favorite color was: ");
	my_string.print();
	printf("\n");

	// if (my_string.size < 64) // müsste man extra checken, vor free
	free(some_data); // potential double free
}

/** typische Ausführung. Funktioniert nur deswegen halbwegs, weil Speicher
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
