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


package Net::TCP;
use 5.00393;			# new minimum Perl version for this package

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

my $myclass = &{+sub {(caller(0))[0]}};
$VERSION = '0.74';
sub Version { "$myclass v$VERSION" }

use AutoLoader;
require Exporter;
use Net::Inet;
use Net::Gen;
use Socket qw(!/^[a-z]/);

@ISA = qw(Exporter Net::Inet);

# Items to export into callers namespace by default
# (move infrequently used names to @EXPORT_OK below)
@EXPORT = qw(
);

# Other items we are prepared to export if requested
@EXPORT_OK = qw(
	TCPOPT_EOL
	TCPOPT_MAXSEG
	TCPOPT_NOP
	TCPOPT_WINDOW
	TCP_MAXSEG
	TCP_MAXWIN
	TCP_MAX_WINSHIFT
	TCP_MSS
	TCP_NODELAY
	TCP_RPTR2RXT
	TH_ACK
	TH_FIN
	TH_PUSH
	TH_RST
	TH_SYN
	TH_URG
);

%EXPORT_TAGS = (
	sockopts	=> [qw(TCP_NODELAY TCP_MAXSEG TCP_RPTR2RXT)],
);

;# sub AUTOLOAD inherited from Net::Gen (via Net::Inet)

;# pre-declare some things to keep the prototypes in sync

{
    my $name;
    local ($^W) = 0;		# prevent sub redefined warnings
    no strict 'refs';		# so we can do the defined() checks
    for $name (@EXPORT, @EXPORT_OK) {
	eval "sub $name () ;" unless defined(&$name);
    }
}

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.


my %sockopts;

%sockopts = (
	     # known TCP socket options
	     # simple booleans first

	     'TCP_NODELAY'	=> ['i'],

	     # simple integer options

	     'TCP_MAXSEG'	=> ['i'],
	     'TCP_RPTR2RXT'	=> ['i'],

	     # structured options

	     # out of known TCP options
	     );

$myclass->initsockopts( IPPROTO_TCP, \%sockopts );

my $debug = 0;

sub new
{
    print STDERR "${myclass}::new(@_)\n" if $debug;
    my($class,@args) = @_;
    my $self = $class->SUPER::new(@args);
    print STDERR "${myclass}::new(@_), self=$self after sub-new\n"
	if $debug > 1;
    if ($self) {
	;# no new keys for TCP?
	# register our socket options
	$self->registerOptions(['IPPROTO_TCP', IPPROTO_TCP+0], \%sockopts);
	# set our required parameters
	$self->setparams({type => SOCK_STREAM, proto => IPPROTO_TCP});
	$self = $self->init(@args) if $class eq $myclass;
    }
    print STDERR "${myclass}::new returning self=$self\n" if $debug;
    $self;
}

sub _addrinfo			# $this, $sockaddr, [numeric_only]
{
    my($this,@args,@r) = @_;
    @r = $this->SUPER::_addrinfo(@args);
    unless (!@r or ref($this) or $r[2] ne $r[3]) {
	$this = getservbyport(htons($r[3]), 'tcp');
	$r[2] = $this if defined $this;
    }
    @r;
}

# try to fix the TIESCALAR problem (5.000 and 5.001?)

#eval {new Net::TCP} if $] < 5.002;
#eval "new " . $myclass . "()" if $] < 5.002;

package Net::TCP::Server;	# here to ease creating server sockets

@Net::TCP::Server::ISA = qw(Net::TCP);

my $svclass = 'Net::TCP::Server';

# When autosplit/autoload & inherticance work together (5.002 or 5.003),
# every routine in this (sub-)class should be autoloaded.

sub new				# classname, [[hostspec,] service,] [\%params]
{
    print STDERR "Net::TCP::Server::new(@_)\n" if $debug;
    my ($xclass, @Args) = @_;
    if (@Args == 2 && ref $Args[1] && ref($Args[1]) eq 'HASH' or
	@Args == 1 and not ref $Args[0]) {
	unshift(@Args, undef);	# thishost spec
    }
    my $self = $xclass->SUPER::new(@Args);
    return undef unless $self;
    $self = $self->init(@Args) if $xclass eq $svclass;
    $self;
}

sub init			# $self, [@stuff] ; returns updated $self
{
    my ($self, @Args) = @_;
    if (@Args == 2 && ref $Args[1] && ref $Args[1] eq 'HASH' or
	@Args == 1 and not ref $Args[0]) {
	unshift(@Args, undef);	# thishost spec
    }
    return undef unless $self->_hostport('this',\@Args);
    return undef unless $self->SUPER::init;
    $self->setsopt('SO_REUSEADDR',1);
    if ($self->getparam('srcaddrlist') && !$self->isbound) {
	return undef unless $self->bind;
    }
    if ($self->isbound && !$self->didlisten) {
	return undef unless $self->listen;
    }
    $self;
}

# maybe someday add some fork+accept handling here

package Net::TCP;		# back to starting package for autosplit

1;

# these would have been autoloaded, but autoload and inheritance conflict

sub setdebug			# $this, [bool, [norecurse]]
{
    my $prev = $debug;
    my $this = shift;
    $debug = @_ ? $_[0] : 1;
    @_ > 1 && $_[1] ? $prev :
	$prev . $this->SUPER::setdebug(@_);
}

# autoloaded methods go after the END token (& pod) below

__END__

=head1 NAME

Net::TCP - TCP sockets interface module

=head1 SYNOPSIS

    use Socket;			# optional
    use Net::Gen;		# optional
    use Net::Inet;		# optional
    use Net::TCP;

=head1 DESCRIPTION

The C<Net::TCP> module provides services for TCP communications
over sockets.  It is layered atop the C<Net::Inet> and C<Net::Gen>
modules, which are part of the same distribution.

=head2 Public Methods

The following methods are provided by the C<Net::TCP> module
itself, rather than just being inherited from C<Net::Inet> or
C<Net::Gen>.

=over 6

=item new

Usage:

    $obj = new Net::TCP;
    $obj = new Net::TCP $host, $service;
    $obj = new Net::TCP \%parameters;
    $obj = new Net::TCP $host, $service, \%parameters;

Returns a newly-initialised object of the given class.  If called
for a derived class, no validation of the supplied parameters
will be performed.  (This is so that the derived class can add
the parameter validation it needs to the object before allowing
the validation.)  Otherwise, it will cause the parameters to be
validated by calling its C<init> method, which C<Net::TCP>
inherits from C<Net::Inet>.  In particular, this means that if
both a host and a service are given, then an object will only be
returned if a connect() call was successful.

=item Server::new

Usage:

    $obj = new Net::TCP::Server $service;
    $obj = new Net::TCP::Server $service, \%parameters;
    $obj = new Net::TCP::Server $lcladdr, $service, \%parameters;

Returns a newly-initialised object of the given class.  This is
much like the regular C<new> method, except that it makes it easier
to specify just a service name or port number, and it automatically
does a setsockopt() call to set C<SO_REUSEADDR> to make the bind() more
likely to succeed.

Simple example for server setup:

    $lh = new Net::TCP::Server 7788 or die;
    while ($sh = $lh->accept) {
	defined($pid=fork) or die "fork: $!\n";
	if ($pid) {		# parent doesn't need client fh
	    $sh->stopio;
	    next;
	}
	# child doesn't need listener fh
	$lh->stopio;
	# do per-connection stuff here
	exit;
    }

Note that signal-handling for the child processes is not included in this
example.  A sample server will be included in the final kit which will show how
to manage the subprocesses.

=back

=head2 Protected Methods

none.

=head2 Known Socket Options

These are the socket options known to the C<Net::TCP> module itself:

=over 6

=item Z<>

TCP_NODELAY,
TCP_MAXSEG,
TCP_RPTR2RXT

=back

=head2 Known Object Parameters

There are no object parameters registered by the C<Net::TCP> module itself.

=head2 TIESCALAR

Tieing of scalars to a TCP handle is supported by inheritance
from the C<TIESCALAR> method of C<Net::Gen>.  That method only
succeeds if a call to a C<new> method results in an object for
which the C<isconnected> method returns true, which is why it is
mentioned in connection with this module.

Example:

    tie $x,Net::TCP,0,'finger' or die;
    $x = "-s\n";
    print $y while defined($y = $x);
    untie $x;

This is an expensive re-implementation of C<finger -s> on many
machines.

Each assignment to the tied scalar is really a call to the C<put>
method (via the C<STORE> method), and each read from the tied
scalar is really a call to the C<getline> method (via the
C<FETCH> method).

=head2 Exports

=over 6

=item default

none

=item exportable

C<TCPOPT_EOL>,
C<TCPOPT_MAXSEG>,
C<TCPOPT_NOP>,
C<TCPOPT_WINDOW>,
C<TCP_MAXSEG>,
C<TCP_MAXWIN>,
C<TCP_MAX_WINSHIFT>,
C<TCP_MSS>,
C<TCP_NODELAY>,
C<TCP_RPTR2RXT>,
C<TH_ACK>,
C<TH_FIN>,
C<TH_PUSH>,
C<TH_RST>,
C<TH_SYN>,
C<TH_URG>

=item tags

=over 6

=item C<:sockopts>

This tag gets you the known socket options, C<TCP_MAXSEG>,
C<TCP_NODELAY>, and C<TCP_RPTR2RXT>.

=back

Z<>

=back

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
