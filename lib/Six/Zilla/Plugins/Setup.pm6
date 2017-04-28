=begin pod

=head1 Six::Zilla::Plugins::Setup

Set up the user's configuration file. If '-i' or '--interactive' is passed, then
prompt the user for settings such as email address (not sent anywhere) or 
GitHub ID (the same.)

=head1 Synopsis

=head1 Documentation

For a more detailed description of how these methods are used, please see L<Six::Zilla>.

=begin METHODS

=item run( @args )

Run the main body

=end METHODS

=end pod

use v6;

class Six::Zilla::Plugins::Setup {
	also does Six::Zilla;

	has Str $.github-username is rw;
	has Str $.author-name is rw;
	has Str $.author-email is rw;

	method CLI-validate( @args ) {
	}

	method CLI-usage {
		Q:to{END}
		-i, --interactive	Interactively generate configuration
	END
	}

	# For the moment, no error messages.
	method CLI-error-message( @args ) { '' }

	method _guess {
#		my $git-config = open ".git/config" or return;
#		for $git-config.lines {
#			if / url '=' 
#		}
		my $git-config = open "%*ENV<HOME>/.gitconfig", :r;
		if $git-config {
			for $git-config.lines {
				when /email '=' (\S+)/ {
					$.git-email = $0;
				}
				when /name '=' (.+) $/ {
					$.git-name = $0;
				}
			}
			return;
		}
		$git-config = open ".git/config", :r;
		if $git-config {
			for $git-config.lines {
				when /url '=' 'git@github.com:(<-[:]>+)/ {
					$.git-email = $0;
				}
			}
		}
	}

	method _ask-for-defaults {
		say "Responses are only saved to \$HOME/.6zillarc";
		say;
		$.github-username = prompt(
			"GitHub user-name (to construct ecosystem URLs)[$gh-guess]: "
		);
		$.author-name = prompt(
		);
	}

	method run( @args ) {
		self.guess;
		if @args.grep: '-i' | '--interactive' {
			self._ask-for-defaults;
		}
		else {
		}
	}
}

# vim: ft=perl6
