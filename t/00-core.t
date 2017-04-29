use v6;
use Six::Zilla::Plugins::Setup;
use Test;

plan 2;

my $setup = Six::Zilla::Plugins::Setup.new;

like $setup.CLI-usage, rx/interactive/,
	Q{Setup plugin has --interactive option};

is $setup.CLI-error-message([]), Any,
	Q{Setup plugin doesn't throw error messages};

# vim: ft=perl6
