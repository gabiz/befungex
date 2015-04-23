BEFUNGEX
========

Befunge is an esoteric programming language that operates in a 2d space, allowing the instruction pointer (ip) to point in any direction.

Befungex is an Elixir interpreter for the Befunge-93 spec.

## Example

Hello world:

    0"!dlroW ,olleH">:#,_@

Count:

    v                                        @
    > & 00p 0 10p ;; 0. ;; " ", ;; > 00g 10g w @
    v                                        <
    > 10g 1+ 10p ;; 10g. ;; " ",   ^

## Usage

Just pass a filename to the interpreter:

    $ mix run -e 'BX.run(["examples/hello.bf"])'

## References

* [BeFunge-93 Wikipedia](http://en.wikipedia.org/wiki/Befunge)
* [Befunge on Esolang](http://esolangs.org/wiki/Befunge)