# Rust Lessons

## Compiling to pdf
You need the [typst] typesetting system.

To compile a specific lesson:
```shell
make lesson$number
make lesson1
```
To compile all lessons:
```shell
make all -j $(nproc)
```

## Lesson notes
How a specific lesson is planned

### Lesson 1
- 30 minutes installation of the toolchain
- 60 minutes for the basics
If someone does **not** have a working setup after 15 minutes,
instruct them to use the computer in front of them (assuming you are in the computer pools).

End with everyone trying out exercise 1

### Lesson 2
#### Funktionen
Explain what functions look like.
Order independent:
`seven()` is defined after its first use in the file.
Ask: Can anybody see an error?
-> use meaningful variable names

#### statements und expressions
- backtrack to tuple -> empty tuple -> unit type

#### Quiz 3 Fibonacci
-> overflow checks
- End: give many different input parameters without explicitly saying so
-> loop

#### loops
- `loop` `continue`, `break`
- with `if` + `else` we can exit loop

- `while`: condition tied to loop



[typst]: https://github.com/typst/typst