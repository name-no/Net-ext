# Copyright 1995 Spider Boardman.
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
use Carp;

use strict qw(refs subs);

my $myclass = 'Net::TCP';
my $Version = '0.51-alpha';
sub Version { "$myclass v$Version" }

require Exporter;
require AutoLoader;
require DynaLoader;
use Net::Inet;
use Net::Gen;
use Socket;

@ISA = qw(Net::Inet Exporter DynaLoader);

*Net::TCP::Inherit::ISA = \@ISA; # delegation hook

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

sub AUTOLOAD
{
    local($constname);
    ($constname = $AUTOLOAD) =~ s/.*:://;
    $val = constant($constname, @_ + 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
	    croak "Your vendor has not defined Net::TCP macro $constname, used";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

use strict;

if (defined &{"${myclass}::bootstrap"}) {
    bootstrap $myclass;
}
else {
    $myclass->DynaLoader::bootstrap;
}

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

my %sockopts;

%sockopts = (
	     # known TCP socket options
	     # simple booleans first

	     'TCP_NODELAY' => ['i'],

	     # simple integer options

	     'TCP_MAXSEG' => ['i'],
	     'TCP_RPTR2RXT' => ['i'],

	     # structured options

	     # out of known TCP options
	     );

$myclass->initsockopts( IPPROTO_TCP, \%sockopts );

my $debug = 0;

sub new
{
    print STDERR "${myclass}::new(@_)\n" if $debug;
    my($class,@args) = @_;
    my $self = $class->Net::TCP::Inherit::new(@args);
    print STDERR "${myclass}::new(@_), self=$self after sub-new\n"
	if $debug > 1;
    if ($self) {
	;# no new keys for TCP?
	# register our socket options
	$self->registerOptions(['IPPROTO_TCP', IPPROTO_TCP+0], \%sockopts);
	# set our required parameters
	$self->setparams({'type' => SOCK_STREAM, 'proto' => IPPROTO_TCP});
	$self = $self->init(@args) if $class eq $myclass;
    }
    print STDERR "${myclass}::new returning self=$self\n" if $debug;
    $self;
}

sub _addrinfo			# $this, $sockaddr, [numeric_only]
{
    my($this,@args,@r) = @_;
    @r = $this->Net::TCP::Inherit::_addrinfo(@args);
    return @r if !@r or ref($this) or $r[2] ne $r[3];
    $this = getservbyport(htons($r[3]), 'tcp');
    $r[2] = $this if defined $this;
    @r;
}

# try to fix the TIESCALAR problem (5.000 and 5.001?)

#eval {new Net::TCP} if $] < 5.002;
#eval "new " . $myclass . "()" if $] < 5.002;

1;

# these would have been autoloaded, but autoload and inheritance conflict

sub accept			# $self ; returns new (ref $self) or undef
{
    my($self) = @_;
    carp "Excess to args to ${myclass}::accept(@_) ignored" if @_ > 1;
    return undef unless $self->didlisten or $self->listen;
    my $xclass = ref $self;
    my $ns = new $xclass;
    return undef unless $ns;
    $ns->close;			# make sure we can use the filehandle
    $ns->setparams($self->getparams([qw(thishost thisservice thisport)],1));
    return undef unless accept($$ns{'fhref'},$$self{'fhref'});
    $$ns{'isopen'} = $$ns{'isbound'} = $$ns{'isconnected'} = 1;
    return undef unless $ns->getsockinfo;
    select((select($$ns{'fhref'}),$|=1)[0]); # keep stdio output unbuffered
    $ns;
}

sub setdebug			# $this, [bool, [norecurse]]
{
    my $prev = $debug;
    shift;
    $debug = @_ ? $_[0] : 1;
    @_ > 1 && $_[1] ? $prev :
	$prev . setdebug Net::TCP::Inherit @_;
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
both a host and a service are given, that an object will only be
returned if a connect() call was successful.

=item accept

Usage:

    $newobj = $obj->accept;

Returns a new object in the same class as the given object if an
accept() call succeeds, and C<undef> otherwise.

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

none, since that version of F<Exporter.pm> is not yet standard.

=back

=head1 AUTHOR

Spider Boardman <F<spider@Orb.Nashua.NH.US>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
