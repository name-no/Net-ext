# Copyright 1995,1996,1997,1998 Spider Boardman.
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
use 5.004;			# new minimum Perl version for this package

use strict;
#use Carp;
sub carp { require Carp; goto &Carp::carp; }
sub croak { require Carp; goto &Carp::croak; }
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

my $myclass;
BEGIN {
    $myclass = __PACKAGE__;
    $VERSION = '0.81';
}
sub Version () { "$myclass v$VERSION" }

use AutoLoader;
#use Exporter ();	# we inherit what we need here from Net::Gen
use Net::Inet;
use Net::Gen;
use Socket qw(!/^[a-z]/ !SOMAXCONN);

BEGIN {
    @ISA = qw(Net::Inet);

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
	tcpoptions	=> [qw(TCPOPT_EOL TCPOPT_MAXSEG TCPOPT_NOP
			       TCPOPT_WINDOW)],
	protocolvalues	=> [qw(TCP_MAXWIN TCP_MAX_WINSHIFT TCP_MSS
			       TH_ACK TH_FIN TH_PUSH TH_RST TH_SYN TH_URG)],
	ALL		=> [@EXPORT, @EXPORT_OK],
    );

;# sub AUTOLOAD inherited from Net::Gen (via Net::Inet)

;# However, since 5.003_96 will make simple subroutines not inherit AUTOLOAD...
    *AUTOLOAD = $myclass->can('AUTOLOAD');

;# pre-declare some things to keep the prototypes in sync


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

sub _debug			# $this, [$newval] ; returns oldval
{
    my ($this,$newval) = @_;
    return $this->debug($newval) if ref $this;
    my $prev = $debug;
    $debug = 0+$newval if defined $newval;
    $prev;
}

sub new
{
    my $whoami = $_[0]->_trace(\@_,1);
    my($class,@args) = @_;
    my $self = $class->SUPER::new(@args);
    $class = ref $class if ref $class;
    ($self || $class)->_trace(\@_,2,", self" .
			      (defined $self ? "=$self" : " undefined") .
			      " after sub-new");
    if ($self) {
	;# no new keys for TCP?
	# register our socket options
	$self->registerOptions('IPPROTO_TCP', IPPROTO_TCP(), \%sockopts);
	# set our expected parameters
	$self->setparams({IPproto => 'tcp',
			  type => SOCK_STREAM,
			  proto => IPPROTO_TCP},-1);
	if ($class eq $myclass) {
	    unless ($self->init(@args)) {
		local $!;	# protect returned errno value
		undef $self;	# against excess closes in perl core
		undef $self;	# another statement needed for sequencing
	    }
	}
    }
    ($self || $class)->_trace(0,1," returning " .
			      (defined $self ? "self=$self" : "undef"));
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


# backward-contemptibility

require Net::TCP::Server;


1;

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

=over

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
returned if a connect() call was successful (or is still in progress,
if the object is non-blocking).

=back

=head2 Protected Methods

none.

=head2 Known Socket Options

These are the socket options known to the C<Net::TCP> module itself:

=over

=item Z<>

C<TCP_NODELAY> C<TCP_MAXSEG> C<TCP_RPTR2RXT>

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
    $x = "-s\015\012";
    print $y while defined($y = $x);
    untie $x;

This is an expensive re-implementation of F<finger -s> on many
machines.

Each assignment to the tied scalar is really a call to the C<put>
method (via the C<STORE> method), and each read from the tied
scalar is really a call to the C<getline> method (via the
C<FETCH> method).

=head2 Exports

=over

=item default

none

=item exportable

C<TCPOPT_EOL> C<TCPOPT_MAXSEG> C<TCPOPT_NOP> C<TCPOPT_WINDOW>
C<TCP_MAXSEG> C<TCP_MAXWIN> C<TCP_MAX_WINSHIFT> C<TCP_MSS>
C<TCP_NODELAY> C<TCP_RPTR2RXT> C<TH_ACK> C<TH_FIN> C<TH_PUSH> C<TH_RST>
C<TH_SYN> C<TH_URG>

=item tags

The following I<:tags> are available for grouping related exportable
items:

=over

=item :sockopts

C<TCP_NODELAY> C<TCP_MAXSEG> C<TCP_RPTR2RXT>

=item :tcpoptions

C<TCPOPT_EOL> C<TCPOPT_MAXSEG> C<TCPOPT_NOP> C<TCPOPT_WINDOW>

=item :protocolvalues

C<TCP_MAXWIN> C<TCP_MAX_WINSHIFT> C<TCP_MSS> C<TH_ACK> C<TH_FIN>
C<TH_PUSH> C<TH_RST> C<TH_SYN> C<TH_URG>

=item :ALL

All of the above exportable items.

=back

Z<>

=back

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
