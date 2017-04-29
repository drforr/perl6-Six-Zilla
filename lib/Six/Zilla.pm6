use v6;

role Six::Zilla {
	has Bool $.verbose; # From CLI, users can assume it is properly set.

	method CLI-validate( @args ) returns Int { !!! }
	method CLI-usage returns Str { !!! }
	method CLI-error-message( @args ) returns Str { !!! }
	method run( @argv ) { !!! }
}

=begin DOCUMENTATION

This role exists only to make sure that plugin authors conform to the (admittedly minimalist) interface.

=item run( @args )

Given: all of the relevant CLI arguments
Returns: Nothing.

Do what you want to do here. You can throw exceptions or simply C<die()>, whatever you do here should get caught by the driver application and passed on almost verbatim. Do file I/O, use any of the helper methods in this role, do what you like.

There's no separation between common and custom arguments, because theoretically they shouldn't conflict. This may change after I look at the prototype for this application, but I'll change it before release should that be a problem.

=item CLI-validate( @args ) returns Bool

Given: all of the relevant CLI arguments (there may be some preprocessing done)
Returns: True if all of the arguments are valid and cause no conflicts.
         False if there are any conflicts.

Now is the time to check whether (for instance) log files that shouldn't exist do, or templates that should exist in your path don't. Basically, anything that you can check before the driver calls your run() method.

=item CLI-usage( ) returns Str

Given: Nothing
Returns: The usage string you want to display to the user for help, or if there's a command-line error you want to point out.

Don't assume that C<CLI-validate()> will be called ahead of time, the driver may simply be responding to the user's adding C<--help> on the CLI, so this may be the only method that gets called.

This should generally look like below, but you of course are free to use whatever text or layout you choose.

    usage: 6zilla [options] setup [custom-options]
        -i, --interactive	Prompt the user for information

The 'usage: 6zilla...' line is generated for you automatically, because this is theoretically common to all plugins. If you want to display a completely custom message, add C<'### no-default'> at the start of your string to suppress this.

=item CLI-error-message( @args )

Return the error condition(s) you want to alert the user to based on arguments they provide. For instance, they may pass C<--quiet> and C<-v> (quiet and verbose) simultaneously, and you'll want to report a conflict rather than continue onwards.

Return C<''> if there's no error condition, otherwise return the text. This should only get called if you returned C<False> from C<CLI-validate> earlier. The error message and the usage string are separated like this only because the driver may want to format these differently later on. And besides, lots of people do their C<usage()> method as C<usage($msg) { say $msg; say Q:to{END}big long usage message\nEND }> anyway, so this just saves you a bit of work.

=end DOCUMENTATION
 
# vim: ft=perl6
