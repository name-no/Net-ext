# Copyright 1995,1996 Spider Boardman.
# All rights reserved.
#
# Automatic licensing for this software is available.  This software
# can be copied and used under the terms of the GNU Public License,
# version 1 or (at your option) any later version, or under the
# terms of the Artistic license.  Both of these can be found with
# the Perl distribution, which this software is intended to augment.
#
# THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.


package Net::UNIX;
require 5.003;			# new minimum Perl version for this package

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $AUTOLOAD);

my $myclass = 'Net::UNIX';
$VERSION = '0.72';

sub Version { "$myclass v$VERSION" }

require Exporter;
require DynaLoader;
require AutoLoader;
use Net::Gen;
use Socket qw(!pack_sockaddr_un !unpack_sockaddr_un);

@ISA = qw(Exporter DynaLoader Net::Gen);

# Items to export into callers namespace by default.
# (Move infrequently used names to @EXPORT_OK below.)

@EXPORT = qw(
);

@EXPORT_OK = qw(
	pack_sockaddr_un
	unpack_sockaddr_un
);

%EXPORT_TAGS = (
	routines	=> [qw(pack_sockaddr_un unpack_sockaddr_un)],
);

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    my $val = constant($constname, @_ + 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined Net::UNIX macro $constname, used";
	}
    }
    no strict 'refs';
    *$AUTOLOAD = sub { $val };
;#    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap Net::UNIX $VERSION;

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

;# No additional sockopts for UNIX-domain sockets (?)

sub pack_sockaddr_un		# [$family,] $path
{
    my(@args) = @_;
    unshift(@args,AF_UNIX) if @args == 1;
    _pack_sockaddr_un(@args);
}

sub unpack_sockaddr_un		# $sockaddr_un; returns [$fam,] $path
{
    my $addr = shift;
    my ($fam,$path) = unpack_sockaddr($addr);
    my $nul = index($path, "\0");
    if ($nul >= 0) {
	substr($path, $nul) = '';
    }
    $fam ||= AF_UNIX;
    wantarray ? ($fam, $path) : $path;
}

my $sun_path_len =
    length(Socket::unpack_sockaddr_un(Socket::pack_sockaddr_un('')));

my $debug = 0;

my %keyhandlers = (thispath => \&_setbindpath,
		   destpath => \&_setconnpath,
);
my @handledkeys = keys %keyhandlers;
my @keyhandlers = values %keyhandlers;

my @Keys = qw();

sub new				# $class, [\%params]
{
    print STDERR "${myclass}::new(@_)\n" if $debug;
    my($class,@Args,$self) = @_;
    $self = $class->SUPER::new(@Args);
    print STDERR "${myclass}::new(@_), self=$self after sub-new\n"
	if $debug > 1;
    if ($self) {
	dump if $debug > 1 and
	    ref $self ne $class || "$self" !~ /HASH/;
	# register our keys and their handlers
	$self->registerParamKeys(\@Keys) if @Keys;
	$self->registerParamHandlers(\@handledkeys,\@keyhandlers);
	# register our socket options
	# none for AF_UNIX?
	# set our required parameters
	$self->setparams({PF => PF_UNIX, AF => AF_UNIX});
	$self = $self->init(@Args) if $class eq $myclass;
    }
    print STDERR "${myclass}::new returning self=$self\n" if $debug;
    $self;
}

sub _canonpath			# $path; returns NUL-padded $path for sun_addr
{
    my $path = shift;
    my $ix;
    # extend to proper length
    $ix = index($path, "\0");
    if ($ix >= 0) {
	substr($path,$ix) = "\0" x ($sun_path_len - $ix);
    }
    else {
	$path .= "\0" x ($sun_path_len - length($path));
    }
    $path;
}

sub _setbindpath		# $self, 'thispath', $path
{
    my($self,$what,$path) = @_;
    my $ix;
    if (!defined($path)) {
	# removing, so cooperate
	delete $$self{Parms}{srcaddrlist};
	return '';
    }
    # canonicalize the path to be of the right length, if possible
    $path = _canonpath($path);
    $ix = index($path, "\0");	# check for NUL-termination
    if (!$ix) {			# empty path is not a bind
	delete $$self{Parms}{srcaddrlist};
	$_[2] = undef;
    }
    else {
	$$self{Parms}{srcaddrlist} = [_pack_sockaddr_un(AF_UNIX,$path)];
    }
    '';
}

sub _setconnpath		# $self, 'destpath', $path
{
    my($self,$what,$path) = @_;
    my $ix;
    if (!defined($path)) {
	# removing, so cooperate
	delete $$self{Parms}{dstaddrlist};
	return '';
    }
    # canonicalize the path to be of the right length, if possible
    $path = _canonpath($path);
    $ix = index($path, "\0");	# check for NUL-termination
    if (!$ix) {			# empty path?
	"$what parameter has no path: $path";
    }
    else {			# just try it here
	$$self{Parms}{dstaddrlist} = [_pack_sockaddr_un(AF_UNIX,$path)];
	'';
    }
}


1;

# these would have been autoloaded, but autoload and inheritance conflict


# autoloaded methods go after the END token (& pod) below

__END__

=head1 NAME

Net::UNIX - UNIX-domain sockets interface module

=head1 SYNOPSIS

    use Socket;			# optional
    use Net::Gen;		# optional
    use Net::UNIX;

=head1 DESCRIPTION

The C<Net::UNIX> module provides services for UNIX-domain socket
communication.  It is layered atop the C<Net::Gen> module, which
is part of the same distribution.

=head2 Public Methods

The following methods are provided by the C<Net::UNIX> module
    itself, rather than just being inherited from C<Net::Gen>.

=over 6

=item new

Usage:

    $obj = new Net::UNIX;
    $obj = new Net::UNIX $pathname;
    $obj = new Net::UNIX \%parameters;
    $obj = new Net::UNIX $pathname, \%parameters;

Returns a newly-initialised object of the given class.  If called
for a derived class, no validation of the supplied parameters
will be performed.  (This is so that the derived class can add
the parameter validation it needs to the object before allowing
the validation.)  Otherwise, it will cause the parameters to be
validated by calling its C<init> method.  In particular, this
means that if a pathname is given, an object will be returned
only if a connect() call was successful.

=item Server::new

Usage:

    $obj = new Net::UNIX::Server $pathname;
    $obj = new Net::UNIX::Server $pathname, \%parameters;

Returns a newly-initialised object of the given class.  This is
much like the regular C<new> method, except that it does a
C<bind> rather than a C<connect>, and it does a C<listen>.

=item init

Usage:

    return undef unless $self = $self->init;
    return undef unless $self = $self->init(\%parameters);
    return undef unless $self = $self->init($pathname);
    return undef unless $self = $self->init($pathname, \%parameters);

Verifies that all previous parameter assignments are valid (via
C<checkparams>).  Returns the incoming object on success, and
C<undef> on failure.  Usually called only via a derived class's
C<init> method or its own C<new> call.

=item bind

Usage:

    $ok = $obj->bind;
    $ok = $obj->bind($pathname);

Sets up the C<srcaddrlist> object parameter with the specified
$pathname argument if supplied, and then returns the value from
the inherited C<bind> method.

Example:

    $ok = $obj->bind('/tmp/.fnord'); # start a service on /tmp/.fnord

=item connect

Usage:

    $ok = $obj->connect;
    $ok = $obj->connect($pathname);

Attempts to establish a connection for the object.  If the
$pathname argument is specified, it will be used to set the
C<dstaddrlist> object parameter.  Then, the result of a call to
the inherited C<connect> method will be returned.

=item format_addr

Usage:

    $string = $obj->format_addr($sockaddr);
    $string = format_addr Module $sockaddr;

Returns a formatted representation of the socket address.  This
is normally just a pathname, or the constant string C<''>.

=item accept

Usage:

    $newobj = $obj->accept;

Returns a new object in the same class as the given object if an
accept() call succeeds, and C<undef> otherwise.

=back

=head2 Protected Methods

[See the note in the C<Net::Gen> documentation about my
definition of protected methods in Perl.]

None.

=head2 Known Socket Options

There are no socket options known to the C<Net::UNIX> module itself.

=head2 Known Object Parameters

There are no object parameters registered by the C<Net::UNIX> module
itself.

=head2 TIESCALAR

Tieing of scalars to a UNIX-domain handle is supported by
inheritance from the C<TIESCALAR> method of C<Net::Gen>.  That
method only succeeds if a call to a C<new> method results in an
object for which the C<isconnected> method returns a true result.
Thus, for C<Net::UNIX>, C<TIESCALAR> will not succeed unless the
C<pathname> argument is given.

Each assignment to the tied scalar is really a call to the C<put>
method (via the C<STORE> method), and each read from the tied
scalar is really a call to the C<getline> method (via the
C<FETCH> method).

=head2 Non-Method Subroutines

=over 6

=item pack_sockaddr_un

Usage:

    $connect_address = pack_sockaddr_un($family, $pathname);
    $connect_address = pack_sockaddr_un($pathname);

Returns the packed C<struct sockaddr_un> corresponding to the
provided $family and $pathname arguments.  The $family argument
as assumed to be C<AF_UNIX> if it is missing.

=item unpack_sockaddr_un

Usage:

    ($family, $pathname) = unpack_sockaddr_un($connected_address);

Returns the address family and pathname (if known) from the
supplied packed C<struct sockaddr_un>.  This is the inverse of
pack_sockaddr_un().

=back

=head2 Exports

=over 6

=item default

None.

=item exportable

C<pack_sockaddr_un>,
C<unpack_sockaddr_un>

=item tags

None.

=back

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
