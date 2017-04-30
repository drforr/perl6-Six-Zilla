=begin pod

=head1 Six::Zilla::Plugins::Setup

=head2 Synopsis

Create $HOME/.6zilla/config.yml - Should be run once when the module is first downloaded, and afterward only as indicated in the README.

=head2 Options

-i or --interactive - Prompt user for default settings.

Set up the user's configuration file. If '-i' or '--interactive' is passed, then prompt the user for settings such as email address (not sent anywhere) or GitHub ID (the same.) Default settings read from L<.gitconfig> appear in [square brackets].

=end pod

use v6;

use Six::Zilla;

my $template-config = Q:to{END};
---
user:
  name: {name}
  email: {email}
rights:
  license: {license}
  copyright_holder: {name}
git:
  source_url: {source_url}
  username: {username}
distribution:
  directory_prefix: perl6
END

class Six::Zilla::Plugins::Setup {
	also does Six::Zilla;

	# From the current META6.json:
	#
	# tags - only useful on a per-module basis.
	# provides - only useful on a per-module basis
	# test-depends - Maybe make 'Test' a default?
	has Str @.test-depends = <Test>;

	# support - github username in 'source' section
	has Str $.github-username;

	# perl - default perl6 version
	has Str $.perl-version = Q{6.c};

	# build-depends - nothing?
	# auth - github username
	# source-url - github username
	# depends - only useful on a per-module basis
	# authors - git name, git email
	has Str $.git-name;
	has Str $.git-email;

	# version - only useful on a per-module basis
	# license
	has Str $.license;

	# description - only useful on a perl-module basis

	# Create .gitignore from template

	# on to .travis.yml
	has Str $.default-installer = 'zef';

	# Author line in README
	# License



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

	method prompt-for-settings {
		say "(settings are only written locally)" if $.verbose;
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


	method CLI-validate( @args ) returns Bool {
		True;
	}

	method CLI-usage {
		Q:to{END}
		usage: 6zilla [options] setup [custom-options]
			-i, --interactive	Interactively generate configuration
		END
	}

	# For the moment, no error messages.
	method CLI-error-message( @args ) { Any }

	method run( @args ) {
		self.defaults-from-git;
		if grep { / ^ '--' interactive | '-' i / }, @args {
			self.prompt-for-settings;
		}
	}
}

# vim: ft=perl6
