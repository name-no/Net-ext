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


package Net::UDP;
use Carp;

use strict qw(refs subs);

my $myclass = 'Net::UDP';
my $Version = '0.51-alpha';
sub Version { "$myclass v$Version" }

use Net::Inet;
use Net::Gen;
use Socket;
require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Net::Inet Exporter AutoLoader DynaLoader);

*Net::UDP::Inherit::ISA = \@ISA; # delegation hook

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
);

@EXPORT_OK = qw(
);

use strict;

#if (defined &{"${myclass}::bootstrap"}) {
#    bootstrap $myclass;
#}
#else {
#    $myclass->DynaLoader::bootstrap;
#}

# Preloaded methods go here.  Autoload methods go after
# __END__, and are processed by the autosplit program.

# No new socket options for UDP

sub new
{
    my($class,@args) = @_;
    my $self = $class->Net::UDP::Inherit::new(@args);
    if ($self) {
	# no new keys for UDP?
	# no new sockopts for UDP?
	# set our required parameters
	$self->setparams({type => SOCK_DGRAM, proto => IPPROTO_UDP}, -1);
	$self = $self->init(@args) if $class eq $myclass;
    }
    $self;
}

sub _addrinfo			# $this, $sockaddr, [numeric_only]
{
    my($this,@args,@r) = @_;
    @r = $this->Net::UDP::Inherit::_addrinfo(@args);
    return @r if !@r or ref($this) or $r[2] ne $r[3];
    $this = getservbyport(htons($r[3]), 'udp');
    $r[2] = $this if defined $this;
    @r;
}

# autoload-wannabe's go here

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

=back

=head2 Protected Methods

none.

=head2 Known Socket Options

There are no object parameters registered by the C<Net::UDP> module itself.

=head2 Known Object Parameters

There are no object parameters registered by the C<Net::UDP> module itself.

=head2 TIESCALAR

Tieing of scalars to a UDP handle is supported by inheritance
from the C<TIESCALAR> method of C<Net::Gen>.  That method only
succeeds if a call to a C<new> method results in an object for
which the C<isconnected> method returns true, which is why it is
mentioned in connection with this module.

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

=head2 Exports

none

=head1 AUTHOR

Spider Boardman <F<spider@Orb.Nashua.NH.US>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
