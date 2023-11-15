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

		printf("old data: '%s'\n", data);

		data = (char*) malloc (size);

		printf("new data: '%s'\n", data);
	}
	~String () {
		free(data);
	}

	// neuen text kopieren und dann data darauf zeigen lassen
	void write (char* text, const int length) {
		char new_data[length];

		sprintf(new_data, "%s", text);	// schreibt text in den Puffer new_data

		data = &(new_data[0]);	// data zeigt jetzt auf den Anfang von new_data
		size = length; // update size of data
	}

	void print () const {
		printf("%s", data);
		// oder (warum verhält sich das unterschiedlich?)
		printf("%s\n", data);
	}
};

int main(int argc, const char* argv[]) {
	String my_string (64);	// create String with 64 Bytes Space

	char* some_data;
	if (argc >= 2)
		some_data = my_string.data;
	else
		some_data = (char*) malloc (64);

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
