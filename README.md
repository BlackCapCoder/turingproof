# turingproof

We were given a simple register machine language in a lecture, and I decided to prove it turing complete.

This is a haskell program that converts a [collatz function](https://esolangs.org/wiki/Collatz_function) (which is known to be turing complete) to brainfuck, and then transpiles that to the lecture language.

I am going via brainfuck because it seemed trivial to translate into the lecture language, and I am transpiling from Collatz because I can only transpile the brainfuck under certain constraints, which I am guaranteed to get from a Collatz function.

Amazingly this will never use more than 3 bytes of memory.
That's right: you can simulate life, the universe and everything with only 3 bytes of memory.
