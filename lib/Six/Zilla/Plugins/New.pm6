=begin pod

=head1 Six::Zilla::Plugins::New

=head2 Synopsis

Create a new distribution.

=head2 Options

-i or --interactive - Prompt user for distribution settings.

Set up the user's configuration file. If '-i' or '--interactive' is passed, then prompt the user for settings such as email address (not sent anywhere) or GitHub ID (the same.) Default settings read from L<.gitconfig> appear in [square brackets].

=end pod

use v6;

use Six::Zilla;
use Six::Zilla::Templates;

class Six::Zilla::Plugins::New {
	also does Six::Zilla;

	has Str $.project-name;
	has Str $.github-username;

	use YAML;

	method load-configuration {
	}

#`(
	method defaults-from-git {
		my $git-config;
		if %*ENV<HOME> {
			$git-config = "%*ENV<HOME>/.gitconfig";
		}
		elsif %*ENV<USER> {
			$git-config = "/home/%*ENV<USER>/.gitconfig";
		}
		elsif $.verbose {
			$*ERR.say(
				"*** No home directory found, cannot locate .gitconfig"
			);
			return;
		}
		my $in-user-section = False;
		my $fh = open $git-config, :r;
		for $fh.lines {
			when m{ '[user]' } {
				$in-user-section = True;
			}
			when m{ ^ '[' } {
				$in-user-section = False;
			}
			when m{ email '=' (.+) $ } and $in-user-section {
				$.git-email = $0;
			}
			when m{ name '=' (.+) $ } and $in-user-section {
				$.git-name = $0;
			}
		}
		close $fh;
	}
)

#`(
	method prompt-for-settings {
		say "(settings are only written locally)";
		say '';
		my $git-email = prompt(
			"GitHub email [$.git-email]: "
		);
		$.git-email = $git-email if $git-email ~~ /\S/;
		my $git-name = prompt(
			"GitHub name (first last) [$.git-name]: "
		);
		$.git-name = $git-name if $git-name ~~ /\S/;
	}
)

	method CLI-validate( @args ) returns Bool {
		True;
	}

	method CLI-usage {
		Q:to{END}
		usage: 6zilla [options] new project-name
			-i, --interactive	Interactively create project
		END
	}

	# For the moment, no error messages.
	method CLI-error-message( @args ) { Any }

	method run( @args ) {
#		self.defaults-from-git;
#		if grep { / ^ '--' interactive | '-' i / }, @args {
#			self.prompt-for-settings;
#		}
	}
}

# vim: ft=perl6
