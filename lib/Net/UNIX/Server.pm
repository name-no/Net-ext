# Copyright 1997,1998 Spider Boardman.
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


package Net::UNIX::Server;
use 5.004_05;

use strict;
#use Carp;
sub carp { require Carp; goto &Carp::carp; }
sub croak { require Carp; goto &Carp::croak; }
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $AUTOLOAD);

my $myclass;
BEGIN {
    $myclass = __PACKAGE__;
    $VERSION = '0.86';
}
sub Version { "$myclass v$VERSION" }

#use AutoLoader;		# someday add back, along with AUTOLOAD, below
#use Exporter ();
#use Net::Gen 0.85 qw(/pack_sockaddr$/);
#use Socket qw(!pack_sockaddr_un !unpack_sockaddr_un);
use Socket '/^SOCK_/';
use Net::UNIX 0.85;

BEGIN {
    @ISA = qw(Net::UNIX);

# Items to export into callers namespace by default.
# (Move infrequently used names to @EXPORT_OK below.)

    @EXPORT = qw(
    );

    @EXPORT_OK = qw(
    );

    %EXPORT_TAGS = (
	ALL		=> [@EXPORT, @EXPORT_OK],
    );
}

# sub AUTOLOAD inherited from Net::Gen

# since 5.003_96 will break simple subroutines with inherited autoload, cheat
#sub AUTOLOAD
#{
#    $Net::Gen::AUTOLOAD = $AUTOLOAD;
#    goto &Net::Gen::AUTOLOAD;
#}


# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

# Can't autoload new & init when Net::Gen has them non-autoloaded.  Feh.

# No additional sockopts for UNIX-domain sockets (?)

sub new
{
    my $whoami = $_[0]->_trace(\@_,1);
    my($class,@Args,$self) = @_;
    $self = $class->SUPER::new(@Args);
    $class = ref $class if ref $class;
    ($self || $class)->_trace(\@_,2," self" .
			      (defined $self ? "=$self" : " undefined") .
			      " after sub-new");
    if ($self) {
	$self->setparams({reuseaddr => 1}, -1);
	if ($class eq __PACKAGE__) {
	    unless ($self->init(@Args)) {
		local $!;	# preserve errno
		undef $self;	# against the side-effects of this
		undef $self;	# another statement needed for unwinding
	    }
	}
    }
    ($self || $class)->_trace(0,1," returning " .
			      (defined $self ? "self=$self" : "undefined"));
    $self;
}

sub init			# $self [, $thispath][, \%params]
{
    my ($self,@args) = @_;
    return undef unless $self->_init('thispath',@args);
    if ($self->isbound) {
	return undef
	    unless $self->getparam('type') == SOCK_DGRAM or
		$self->isconnected or $self->didlisten or $self->listen;
    }
    $self;
}

1;

# autoloaded methods go after the END token (& pod) below

__END__

=head1 NAME

Net::UNIX::Server - UNIX-domain sockets interface module for listeners

=head1 SYNOPSIS

    use Socket;			# optional
    use Net::Gen;		# optional
    use Net::UNIX;		# optional
    use Net::UNIX::Server;

=head1 DESCRIPTION

The C<Net::UNIX::Server> module provides additional
services for UNIX-domain socket
communication.  It is layered atop the C<Net::UNIX> and C<Net::Gen> modules,
which are part of the same distribution.

=head2 Public Methods

The following methods are provided by the C<Net::UNIX::Server> module
itself, rather than just being inherited from C<Net::UNIX> or C<Net::Gen>.

=over

=item new

Usage:

    $obj = new Net::UNIX::Server;
    $obj = new Net::UNIX::Server $pathname;
    $obj = new Net::UNIX::Server $pathname, \%parameters;
    $obj = 'Net::UNIX::Server'->new();
    $obj = 'Net::UNIX::Server'->new($pathname);
    $obj = 'Net::UNIX::Server'->new($pathname, \%parameters);

Returns a newly-initialised object of the given class.  This is
much like the regular C<new> methods of other modules in this
distribution, except that it does a
C<bind> rather than a C<connect>, and it does a C<listen>.  Unless
specified otherwise with a C<type> object parameter, the underlying
socket will be a datagram socket (C<SOCK_DGRAM>).

The examples above show the indirect object syntax which many prefer,
as well as the guaranteed-to-be-safe static method call.  There
are occasional problems with the indirect object syntax, which
tend to be rather obscure when encountered.  See
F<E<lt>URL:http://www.rosat.mpe-garching.mpg.de/mailing-lists/perl-porters/1998-01/msg01674.htmlE<gt>>
for details.

See L<Net::TCP::Server> for an example of running a server.  The
differences are only in the module names and the fact that UNIX-domain
sockets bind to a pathname rather than to a port number.  Of course,
that example is for stream (C<type = SOCK_STREAM>) sockets rather than
for datagrams.  UNIX-domain datagram sockets don't need to do an
accept() (and can't where I've tested this code), and can't answer back
to their clients unless those clients have also bound to a specific path
name.

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

=back

=head2 Protected Methods

[See the description in L<Net::Gen/"Protected Methods"> for my
definition of protected methods in Perl.]

None.

=head2 Known Socket Options

There are no socket options known to the C<Net::UNIX::Server> module itself.

=head2 Known Object Parameters

There are no object parameters registered by the C<Net::UNIX::Server> module
itself.

=head2 Exports

=over

=item default

None.

=item exportable

None.

=item tags

The following I<:tags> are available for grouping exportable items:

=over

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
