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
END

# Current directory structure looks like:
#
# perl6-Project-Name
# perl6-Project-Name/lib
# perl6-Project-Name/lib/Project/Name.pm6
# perl6-Project-Name/t
# perl6-Project-Name/t/00-core.t
# perl6-Project-Name/.gitignore
# perl6-Project-Name/.travis.yml
# perl6-Project-Name/META6.json
# perl6-Project-Name/README.md

my $template-lib-Project-Name = Q:to{END};
use v6;

=begin pod

=head1 {$project-name}

=head2 Synopsis

=end pod

class {$project-name} {
}
END

my $template-t-core = Q:to{END};
use v6;
use Test;
use {$project-name};

plan 1;

ok 1;

# {$editor-line}
END

my $template-dot-gitignore = Q:to{END};
*.swp
*.swo
lib/.precomp
END

my $template-dot-travis = Q:to{END};
language: perl6
sudo: true
perl6:
  - latest
install:
  - rakudbrew build-panda
  - panda installdeps .
  - panda installdeps .
END

# Don't create a META6.json template, just generate data directly.

my $template-README = Q:to{END};
{$project-name}
{$project-name-underline}

Write about {$project-name} here.

Installation
============

* Using zef (a module management tool bundled with Rakudo Star):

```
    zef update && zef install ANTLR4
```

Testing
=======

To run tests:

```
    prove -e'perl6 -Ilib'
```

Author
======
{$git-name}, {$git-url}

License
=======
{$license}
END

class Six::Zilla::Plugins::New {
	also does Six::Zilla;

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


	method CLI-validate( @args ) returns Bool {
		True;
	}

	method CLI-usage {
		Q:to{END}
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
