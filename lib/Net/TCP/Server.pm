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


package Net::TCP::Server;
use 5.004;

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
#use Net::Inet;
#use Net::Gen;
use Net::TCP;


BEGIN {
    @ISA = qw(Net::TCP);

# Items to export into callers namespace by default
# (move infrequently used names to @EXPORT_OK below)
    @EXPORT = qw(
    );

# Other items we are prepared to export if requested
    @EXPORT_OK = qw(
    );

# Tags:
    %EXPORT_TAGS = (
    ALL		=> [@EXPORT, @EXPORT_OK],
);

# sub AUTOLOAD inherited from Net::Gen (via Net::TCP)

# However, since 5.003_96 will make simple subroutines not inherit AUTOLOAD...
    *AUTOLOAD = $myclass->can('AUTOLOAD');

}

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.


# maybe someday add some fork+accept handling here?

1;

# autoloaded methods go after the END token (& pod) below

__END__

=head1 NAME

Net::TCP::Server - TCP sockets interface module for listeners and servers

=head1 SYNOPSIS

    use Socket;			# optional
    use Net::Gen;		# optional
    use Net::Inet;		# optional
    use Net::TCP;		# optional
    use Net::TCP::Server;

=head1 DESCRIPTION

The C<Net::TCP::Server> module provides services for TCP communications
over sockets.  It is layered atop the C<Net::TCP>, C<Net::Inet>,
and C<Net::Gen>
modules, which are part of the same distribution.

=head2 Public Methods

The following methods are provided by the C<Net::TCP::Server> module
itself, rather than just being inherited from C<Net::TCP>,
C<Net::Inet>, or
C<Net::Gen>.

=over

=item new

Usage:

    $obj = new Net::TCP::Server;
    $obj = new Net::TCP::Server $service;
    $obj = new Net::TCP::Server $service, \%parameters;
    $obj = new Net::TCP::Server $lcladdr, $service, \%parameters;

Returns a newly-initialised object of the given class.  This is
much like the regular C<new> method of the other modules
in this distribution, except that it makes it easier
to specify just a service name or port number, and it automatically
does a setsockopt() call to set C<SO_REUSEADDR> to make the bind() more
likely to succeed.  The C<SO_REUSEADDR> is really done in a base class,
but it's enabled by defaulting the C<reuseaddr> object parameter to 1 in
this constructor.

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

There are no socket options specific to the C<Net::TCP::Server> module.

=head2 Known Object Parameters

There are no object parameters registered by the C<Net::TCP::Server>
module itself.

=head2 Exports

=over

=item default

none

=item exportable

none

=item tags

none

=back

=head1 AUTHOR

Spider Boardman F<E<lt>spider@Orb.Nashua.NH.USE<gt>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line

sub new				# classname, [[hostspec,] service,] [\%params]
{
    $_[0]->_trace(\@_,1);
    my ($xclass, @Args) = @_;
    if (@Args == 2 && ref $Args[1] && ref($Args[1]) eq 'HASH' or
	@Args == 1 and not ref $Args[0]) {
	unshift(@Args, undef);	# thishost spec
    }
    my $self = $xclass->SUPER::new(@Args);
    return undef unless $self;
    $self->setparams({reuseaddr => 1}, -1);
    $xclass = ref $xclass if ref $xclass;
    if ($xclass eq $myclass) {
	unless ($self->init(@Args)) {
	    local $!;		# protect returned errno value
	    undef $self;	# against excess closes in perl core
	    undef $self;	# another statement needed for sequencing
	}
    }
    $self;
}

sub init			# $self, [@stuff] ; returns updated $self
{
    my ($self, @Args) = @_;
    if (@Args == 2 && ref $Args[1] && ref $Args[1] eq 'HASH' or
	@Args == 1 and not ref $Args[0]) {
	unshift(@Args, undef);	# thishost spec
    }
    return unless $self->_hostport('this',\@Args);
    return unless $self->SUPER::init;
    if ($self->getparam('srcaddrlist') && !$self->isbound) {
	return unless $self->bind;
    }
    if ($self->isbound && !$self->didlisten) {
	return unless $self->listen;
    }
    $self;
}
