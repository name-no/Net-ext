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


package Net::UDP;
use 5.004;			# new minimum Perl version for this package

use strict;
#use Carp;
sub carp { require Carp; goto &Carp::carp; }
sub croak { require Carp; goto &Carp::croak; }
use vars qw($VERSION @ISA);

my $myclass;
BEGIN {
    $myclass = __PACKAGE__;
    $VERSION = '0.81';
}
sub Version () { "$myclass v$VERSION" }

use AutoLoader;

use Net::Inet;
use Net::Gen;
use Socket qw(!/^[a-z]/ !SOMAXCONN);

BEGIN {
    @ISA = qw(Net::Inet);
    *AUTOLOAD = $myclass->can('AUTOLOAD');
}

# Preloaded methods go here.  Autoload methods go after
# __END__, and are processed by the autosplit program.

# No new socket options for UDP

# Module-specific object options

my @Keys = qw(unbuffered_input unbuffered_output);
my %CodeKeys = (unbuffered_IO => \&_setbuf_unbuf);

sub new
{
    my($class,@args) = @_;
    my $self = $class->SUPER::new(@args);
    $class = ref $class if ref $class;
    if ($self) {
	$self->register_param_keys(\@Keys);
	$self->register_param_handlers(\%CodeKeys);
	# no new sockopts for UDP?
	# set our required parameters
	$self->setparams({type => SOCK_DGRAM,
			  proto => IPPROTO_UDP,
			  IPproto => 'udp',
			  unbuffered_output => 0,
			  unbuffered_input => 0}, -1);
	if ($class eq $myclass) {
	    unless ($self->init(@args)) {
		local $!;	# protect returned errno value
		undef $self;	# against excess closes in perl core
		undef $self;	# another statement needed for sequencing
	    }
	}
    }
    $self;
}

sub _addrinfo			# $this, $sockaddr, [numeric_only]
{
    my($this,@args,@r) = @_;
    @r = $this->SUPER::_addrinfo(@args);
    unless(!@r or ref($this) or $r[2] ne $r[3]) {
	$this = getservbyport(htons($r[3]), 'udp');
	$r[2] = $this if defined $this;
    }
    @r;
}

# autoloaded methods go after the END token (& pod) below

1;
__END__

=head1 NAME

Net::UDP - UDP sockets interface module

=head1 SYNOPSIS

    use Socket;			# optional
    use Net::Gen;		# optional
    use Net::Inet;		# optional
    use Net::UDP;

=head1 DESCRIPTION

The C<Net::UDP> module provides services for UDP communications
over sockets.  It is layered atop the C<Net::Inet> and C<Net::Gen>
modules, which are part of the same distribution.

=head2 Public Methods

The following methods are provided by the C<Net::UDP> module
itself, rather than just being inherited from C<Net::Inet> or
C<Net::Gen>.

=over 6

=item new

Usage:

    $obj = new Net::UDP;
    $obj = new Net::UDP $host, $service;
    $obj = new Net::UDP \%parameters;
    $obj = new Net::UDP $host, $service, \%parameters;

Returns a newly-initialised object of the given class.  If called
for a derived class, no validation of the supplied parameters
will be performed.  (This is so that the derived class can add
the parameter validation it needs to the object before allowing
the validation.)  Otherwise, it will cause the parameters to be
validated by calling its C<init> method, which C<Net::UDP>
inherits from C<Net::Inet>.  In particular, this means that if
both a host and a service are given, that an object will only be
returned if a connect() call was successful.

=item PRINT

Usage:

    $ok = $obj->PRINT(@args);
    $ok = print $tied_fh @args;

This method, intended to be used with tied filehandles, behaves like one
of two inherited methods from the C<Net::Gen> class, depending on the
setting of the object parameter C<unbuffered_output>.  If that parameter
is false (the default), then the normal print() builtin is used.
If that parameter is true, then each print() operation will actually result
in a call to the C<send> method, requiring that the object be connected
or that its message is in response to its last normal recv() (with a C<flags>
parameter of C<0>).  The value of the $\ variable is ignored in that case, but
the $, variable is still used if the C<@args> array has multiple elements.

=item READLINE

Usage:

    $line_or_datagram = $obj->READLINE;
    $line_or_datagram = <TIED_FH>;
    $line_or_datagram = readline(TIED_FH);
    @lines_or_datagrams = $obj->READLINE;
    @lines_or_datagrams = <TIED_FH>;
    @lines_or_datagrams = readline(TIED_FH);

This method, intended to be used with tied filehandles, behaves like one of
two inherited methods from the C<Net::Gen> class, depending on the setting
of the object parameter C<unbuffered_input>.  If that parameter is false
(the default), then this method does line-buffering of its input as defined
by the current setting of the $/ variable.  If that parameter is true, then
the input records will be exact recv() datagrams, disregarding the setting
of the $/ variable.

=back

=head2 Protected Methods

none.

=head2 Known Socket Options

There are no object parameters registered by the C<Net::UDP> module itself.

=head2 Known Object Parameters

The following object parameters are registered by the C<Net::UDP> module
(as distinct from being inherited from C<Net::Gen> or C<Net::Inet>):

=over 4

=item unbuffered_input

If true, the C<READLINE> operation on tied filehandles will return each recv()
buffer as though it were a single separate line, independently of the setting
of the $/ variable.  The default is false, which causes the C<READLINE>
interface to return lines split at boundaries as appropriate for $/.
(The C<READLINE> method for tied filehandles is the C<E<lt>FHE<gt>>
operation.)

=item unbuffered_output

If true, the C<PRINT> operation on tied filehandles will result in calls to
the send() builtin rather than the print() builtin, as described in L</PRINT>
above.  The default is false, which causes the C<PRINT> method to use the
print() builtin.

=item unbuffered_IO

This object parameter's value is unreliable on C<getparam> or C<getparams>
method calls.  It is provided as a handy way to set both the
C<unbuffered_output> and C<unbuffered_input> object parameters to the same
value at the same time during C<new> calls.

=back

=head2 TIESCALAR support

Tieing of scalars to a UDP handle is supported by inheritance
from the C<TIESCALAR> method of C<Net::Gen>.  That method only
succeeds if a call to a C<new> method results in an object for
which the C<isconnected> method returns true, which is why it is
mentioned in regard to this module.

Example:

    tie $x,Net::UDP,0,'daytime' or die;
    $x = "\n"; $x = "\n";
    print $y if defined($y = $x);
    untie $x;

This is an expensive re-implementation of C<date> on many
machines.

Each assignment to the tied scalar is really a call to the C<put>
method (via the C<STORE> method), and each read from the tied
scalar is really a call to the C<getline> method (via the
C<FETCH> method).

=head2 TIEHANDLE support

As inherited from C<Net::Inet> and C<Net::Gen>, with the additions of
unbuffered I/O options for the C<READLINE> and C<PRINT> methods.

=head2 Exports

none

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line

sub _setbuf_unbuf		# $self, $param, $newvalue;
{				# returns '' or carp string
    my ($self,$what,$newval) = @_;
    $self->setparams({unbuffered_input => $newval,
		      unbuffered_output => $newval});
    '';
}

sub PRINT			# $self, @args; returns boolean OKness
{
    my $self = shift;
    if ($self->getparam('unbuffered_output')) {
	$self->send(join $, , @_);
    }
    else {
	print {$self} @_;
    }
}

sub READLINE			# $self; returns buffer or array of buffers
{				# barfs if called unbuffered in array context
    my $whoami = $_[0]->_trace(\@_,5);
    carp "Excess arguments to ${whoami}, ignored" if @_ > 1;
    my $self = shift;
    if ($self->getparam('unbuffered_input')) {
	if (wantarray) {
	    my ($line,@lines)
	    push @lines, $line while defined($line = $self->recv);
	    @lines;
	}
	else {
	    $self->recv;
	}
    }
    else {
	$self->SUPER::READLINE;
    }
}
