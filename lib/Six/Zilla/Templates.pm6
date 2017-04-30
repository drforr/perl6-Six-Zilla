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

class Six::Zilla::Templates {
	does Six::Zilla::Utils;

	has Str $.project-name;

	# Pipe this through JSON
	#
	method template-meta6 {
		my $ds = {
			meta6 => '0',
			tags => [ ],
			provides => [
				self.to-module-name( $.project-name ) => 
					self.to-filename( $.project-name )
			],
			test-depends => [
				'Test'
			],
			support => {
				source => self.to-github-URL(
					$.project-name
				)
			},
			perl => '6.c',
			build-depends => [
			],
			auth => qq{github:$.github-username},
			source-url => to-github-URL( $.project-name ) ~ '.git',
			depends => [
			],
			name => self.to-module-name( $.project-name ),
			authors => [
				qq{$.name $.email}
			],
			version => '0.0.1',
			license => $.license,
			description => "Default description"
		};
		return to-json( $ds );
	}

	# Just for ease of interpolation.
	#method template-config {
	#	my $template-config = Q:to{END};
	#	---
	#	user:
	#	  name: {name}
	#	  email: {email}
	#	rights:
	#	  license: {license}
	#	  copyright_holder: {name}
	#	git:
	#	  source_url: {source_url}
	#	  username: {username}
	#	END
	#	$template-config;
	#}

	method template-lib-Project-Name {
		my $template-lib-Project-Name = Q:to{END};
		use v6;

		=begin pod

		=head1 {$.project-name}

		=head2 Synopsis

		=end pod

		class {self.to-module-name( $.project-name )} {
		}
		END
		$template-lib-Project-Name;
	}

	method template-t-core {
		my $template-t-core = Q:to{END};
		use v6;
		use Test;
		use {self.to-module-name( $.project-name )};

		plan 1;

		ok 1;

		# {$.editor-line}
		END
		$template-t-core;
	}

	method template-dot-gitignore {
		my $template-dot-gitignore = Q:to{END};
		*.swp
		*.swo
		lib/.precomp
		END
		$template-dot-gitignore;
	}

	method template-dot-travis {
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
		$template-dot-travis;
	}

# Don't create a META6.json template, just generate data directly.

	method template-README {
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
		$template-README
	}
}
