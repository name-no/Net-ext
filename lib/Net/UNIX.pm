# Copyright 1995,1996,1997 Spider Boardman.
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
use 5.00393;			# new minimum Perl version for this package

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

my $myclass = &{+sub {(caller(0))[0]}};
$VERSION = '0.74';

sub Version { "$myclass v$VERSION" }

use AutoLoader;
require Exporter;
use Net::Gen qw(/pack_sockaddr$/);
use Socket qw(!pack_sockaddr_un !unpack_sockaddr_un);

@ISA = qw(Exporter Net::Gen);

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

;# sub AUTOLOAD inherited from Net::Gen

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

;# No additional sockopts for UNIX-domain sockets (?)

my $sun_path_len =
    length(Socket::unpack_sockaddr_un(Socket::pack_sockaddr_un('')));

sub _canonpath ($)		# $path; returns NUL-padded $path for sun_addr
{
    my $path = shift;
    my $ix;
    # extend to proper length
    $ix = index($path, "\0");
    if ($ix >= 0) {
	substr($path,$ix) = "\0" x ($sun_path_len - $ix)
	    if $ix < $sun_path_len;
    }
    else {
	$ix = length($path);
	if ($ix < $sun_path_len) {
	    $path .= "\0" x ($sun_path_len - $ix);
	}
	else {
	    $path .= "\0";
	}
    }
    $path;
}

sub pack_sockaddr_un ($;$)	# [$family,] $path
{
    my(@args) = @_;
    unshift(@args, AF_UNIX) if @args == 1;
    pack_sockaddr($args[0], _canonpath($args[1]));
}

sub unpack_sockaddr_un ($)	# $sockaddr_un; returns [$fam,] $path
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
	$$self{Parms}{srcaddrlist} = [Socket::pack_sockaddr_un($path)];
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
	$$self{Parms}{dstaddrlist} = [Socket::pack_sockaddr_un($path)];
	'';
    }
}

sub _init			# $self, whatpath[, $path][, \%params]
{
    my ($self,$what,@args,$path,$parms) = @_;
    if (@args == 1 or @args == 2) {
	$parms = $args[$#args];
	$parms = undef
	    unless $parms and ref($parms) eq 'HASH';
	$path = $args[0];
	$path = undef
	    if defined($path) and ref($path);
    }
    croak("Invalid call to ${myclass}::init(@_)")
	if @args == 2 and !$parms or @args > 2 or !$what;
    $parms ||= {};
    $$parms{$what} = $path if defined $path;
    return undef unless $self->SUPER::init($parms);
    if ($self->getparams([qw(srcaddr srcaddrlist dstaddr dstaddrlist)],1) >0) {
	$self->setparams({type=>SOCK_DGRAM},-1);
	return undef unless $self->isopen or $self->open;
	$self->setsopt('SO_REUSEADDR',1)
	    if (ref $self) =~ /::Server$/;
	if ($self->getparams([qw(srcaddr srcaddrlist)],1) > 0) {
	    return undef unless $self->isbound or $self->bind;
	}
	if ($self->getparams([qw(dstaddr dstaddrlist)],1) > 0) {
	    return undef unless $self->isconnected or $self->connect;
	}
    }
    $self;
}

sub init			# $self [, $destpath][, \%params]
{
    my ($self,@args) = @_;
    $self->_init('destpath',@args);
}

1;

# these would have been autoloaded, but autoload and inheritance conflict

package Net::UNIX::Server;

my $srvpkg = &{+sub {(caller(0))[0]}};

use vars qw(@ISA);

@ISA = $myclass;

sub new
{
    print STDERR "${srvpkg}::new(@_)\n" if $debug;
    my($class,@Args,$self) = @_;
    $self = $class->SUPER::new(@Args);
    print STDERR "${myclass}::new(@_), self=$self after sub-new\n"
	if $debug > 1;
    if ($self) {
	$self = $self->init(@Args) if $class eq $myclass;
    }
    print STDERR "${myclass}::new returning self=$self\n" if $debug;
    $self;
}

sub init			# $self [, $thispath][, \%params]
{
    my ($self,@args) = @_;
    return undef unless $self->_init('thispath',@args);
    return undef unless
	$self->isconnected or $self->didlisten or $self->listen;
    $self;
}

package Net::UNIX;		# back to original package for Autoloader

sub bind			# $self [, $thispath]
{
    my($self,$path) = @_;
    if (@_ > 2 or @_ == 2 and ref $path) {
	croak("Invalid arguments to ${myclass}::bind(@_), called");
    }
    if (@_ == 2) {
	return undef unless $self->setparams({thispath=>$path});
    }
    $self->SUPER::bind;
}

sub connect			# $self [, $destpath]
{
    my($self,$path) = @_;
    if (@_ > 2 or @_ == 2 and ref $path) {
	croak("Invalid arguments to ${myclass}::connect(@_), called");
    }
    if (@_ == 2) {
	return undef unless $self->setparams({destpath=>$path});
    }
    $self->SUPER::connect;
}

sub format_addr			# ($class|$obj) , $sockaddr
{
    my ($this,$addr) = @_;
    my ($fam,$sdata) = unpack_sockaddr($addr);
    if ($fam == AF_UNIX) {
	$sdata = unpack_sockaddr_un($addr);
    }
    else {
	$sdata = $this->SUPER::format_addr($addr);
    }
    $sdata;
}

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
as assumed to be C<AF_UNIX> if it is missing.  This is otherwise
the same as the pack_sockaddr_un() routine in the C<Socket>
module.

=item unpack_sockaddr_un

Usage:

    ($family, $pathname) = unpack_sockaddr_un($connected_address);
    $pathname = unpack_sockaddr_un($connected_address);

Returns the address family and pathname (if known) from the
supplied packed C<struct sockaddr_un>.  This is the inverse of
pack_sockaddr_un().  It differs from the implementation in the
C<Socket> module in its return of the C<$family> value, and in
that it trims the returned pathname at the first null character.

=back

=head2 Exports

=over 6

=item default

None.

=item exportable

C<pack_sockaddr_un>,
C<unpack_sockaddr_un>

=item tags

	routines	=> [qw(pack_sockaddr_un unpack_sockaddr_un)]

=back

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
