BEFUNGEX
========

Befunge is an esoteric programming language that operates in a 2d space, allowing the instruction pointer (ip) to point in any direction.

Befungex is an Elixir interpreter for the Befunge-93 spec.

## Example

Hello world:

    0"!dlroW ,olleH">:#,_@

Replicator:

    :0g,:93+`#@_1+

## Usage

Just pass a filename to the interpreter:

    $ mix run -e 'BX.run(["examples/hello.bf"])'

    $ mix run -e 'BX.run(["examples/replicator.bf"])'

## References

* [Befunge-93 Wikipedia](http://en.wikipedia.org/wiki/Befunge)
* [Befunge on Esolang](http://esolangs.org/wiki/Befunge)