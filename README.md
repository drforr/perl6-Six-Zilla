Six::Zilla
=======

Provides a plugin-based distribution creator and updater.

This idea is stolen almost directly from Perl 5's Dist::Zilla, down to the name. They say imitation is the highest form of flattery, let's see if that's true.

Mostly it started because I'm not a great fan of JSON and keep forgetting rules on where commas should go.

Usage
=====

```
    $ 6zilla setup
    $ 6zilla mint

Installation
============

* Using zef (a module management tool bundled with Rakudo Star):

```
    zef update && zef install ANTLR4
```

## Testing

To run tests:

```
    prove -e perl6
```

## Author

Jeffrey Goff, DrFOrr on #perl6, https://github.com/drforr/

## License

Artistic License 2.0
