# turingproof

We were given a simple register machine language in a lecture, and I decided to prove it turing complete.

This is a haskell program that translates [collatz functions](https://esolangs.org/wiki/Collatz_function) (which is known to be turing complete) into [brainfuck](https://esolangs.org/wiki/Brainfuck), and then transpiles that to the lecture language.

It is a requirement that the collatz function satisfies `ai > 0, bi ≥ 0`. This does not break turing completeness, as [Fractran](https://esolangs.org/wiki/Fractran) can trivially be converted to a collatz function that always satisfies this rule, and Fractran has also been proved turing complete (in fact, collatz was proven turing complete by reduction from Fractran).

I am going via brainfuck because it seemed trivial to translate into the lecture language, and I am transpiling from Collatz because I can only transpile the brainfuck under certain constraints, which I am guaranteed to get from a Collatz function.

Amazingly this will never use more than 3 bytes of memory.
That's right: you can simulate life, the universe and everything with only 3 bytes of memory.
