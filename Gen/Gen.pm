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


package Net::Gen;

require 5.001;

use strict qw(refs subs);

my $myclass='Net::Gen';
my $Version = '0.51-alpha';

sub Version { "$myclass v$Version" }

use Socket;
use Carp;
require Exporter;
require AutoLoader;
require DynaLoader;

@ISA = qw(Exporter AutoLoader DynaLoader);

@EXPORT = ();

@EXPORT_OK = qw(
	pack_sockaddr
	unpack_sockaddr
);

use strict;

if (defined &{"${myclass}::bootstrap"}) {
    bootstrap $myclass;
}
else {
    $myclass->DynaLoader::bootstrap;
}

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

;# This package has the core 'generic' routines for fiddling with
;# sockets.

# initsockopts - set up the socket options of a user of this module
# the structure of a sockopt hash is like this:
# %sockopts = ( 'OPTION' => ['pack_string', $option_number, $option_level,
#				$number_of_elements] ... );
# The option level and number are for calling [gs]etsockopt, and
# the number of elements is for some (weak) consistency checking.
# The pack/unpack template is used by $obj->getsopt and setsopt.
# Only the pack template is set on input to this routine.  On exit,
# it will have deleted any entries which cannot be resolved, and will
# have filled in the ones which can.  It will also have duplicated
# the entries to be indexed by option value as well as by option name.

sub initsockopts		# $class, $level+0, \%sockopts
{
    my ($class,$level,$opts) = @_;
    croak "Invalid arguments to ${myclass}::initsockopts, called"
	if @_ != 3 or ref $opts ne 'HASH';
    $level += 0;		# force numeric
    my($opt,$oval,@oval);
    foreach $opt (keys %$opts) {
	$oval = eval {$class->$opt()} || eval {no strict 'refs';&$opt()};
	delete $$opts{$opt}, next if $@ or !defined($oval) or $oval eq '';
	$oval += 0;		# force numeric
	push(@{$$opts{$opt}}, $oval, $level);
	$$opts{$oval} = $$opts{$opt};
	$oval = $$opts{$opt}[0];
	@oval = unpack($oval, pack($oval, 0));
	$$opts{$opt}[3] = 0+@oval;
    }
}


my %sockopts;

;# The known socket options (from Socket.pm)

%sockopts = (
	     # First, the simple flag options

	     'SO_ACCEPTCONN' => [ 'I' ],
	     'SO_BROADCAST' => [ 'I' ],
	     'SO_DEBUG' => [ 'I' ],
	     'SO_DONTROUTE' => [ 'I' ],
	     'SO_ERROR' => [ 'I' ],
	     'SO_KEEPALIVE' => [ 'I' ],
	     'SO_OOBINLINE' => [ 'I' ],
	     'SO_REUSEADDR' => [ 'I' ],
	     'SO_USELOOPBACK' => [ 'I' ],

	     # Simple integer options

	     'SO_RCVBUF' => [ 'I' ],
	     'SO_SNDBUF' => [ 'I' ],
	     'SO_RCVTIMEO' => [ 'I' ],
	     'SO_SNDTIMEO' => [ 'I' ],
	     'SO_RCVLOWAT' => [ 'I' ],
	     'SO_SNDLOWAT' => [ 'I' ],
	     'SO_TYPE' => [ 'I' ],

	     # Finally, one which is a struct

	     'SO_LINGER' => [ 'II' ],

	     # Out of known socket options
	     );

$myclass->initsockopts( SOL_SOCKET, \%sockopts );

;# These are for creating socket filehandles on the fly.

my $nextfh = "sockFH000000";

sub _genfh
{
    no strict 'refs';		# for this block
    \*{$nextfh++};
}

;# It appears to be impossible (in 5.000) to completely free the
;# core taken by generated glob refs, so we'll keep an LRU cache
;# of them to avoid unbounded core leaks.

my @fhlist = ();

sub _getfh			# (void)
{
    shift(@fhlist) || _genfh;
}

sub _delfh			# (ref to globref)
{
    my $fh = shift;
    return unless ref $fh and ref $$fh eq 'GLOB';
    push(@fhlist, $$fh);
    return;			# guarantee void return
}

my $debug = 0;

my @Keys = qw(PF AF type proto dstaddr dstaddrlist srcaddr srcaddrlist);

sub registerParamKeys		# $self, \@keys
{
    my ($self, $names) = @_;
    print STDERR "${myclass}::registerParamKeys(@_)\n" if $debug > 2;
    croak "Invalid arguments to ${myclass}::registerParamKeys(@_), called"
	if @_ != 2 or ref $names ne 'ARRAY';
    @{$$self{'Keys'}}{@$names} = (); # remember the names
}

sub registerParamHandlers	# $self, \@keys, [\]@handlers
{
    my ($self, $names, @handlers, $handlers) = @_;
    print STDERR "${myclass}::registerParamHandlers(@_)\n" if $debug > 2;
    croak "Invalid parameters to ${myclass}::registerParamHandlers(@_), called"
	if @_ < 3 or ref $names ne 'ARRAY';
    $handlers = \@handlers;	# in case passed as a list
    $handlers = $_[2] if @_ == 3 and ref($_[2]) eq 'ARRAY';
    croak "Invalid handlers in ${myclass}::registerParamHandlers(@_), called"
	if @$handlers != @$names or grep(ref $_ ne 'CODE', @$handlers);
    # finally, all is validated, so set the bloody things
    @{$$self{'Keys'}}{@$names} = @$handlers;
}

sub registerOptions		# $self, $levelname, $level, \%options
{
    my ($self, $levname, $level, $opts) = @_;
    print STDERR "${myclass}::registerOptions(@_)\n" if $debug > 2;
    if (!defined($opts) and ref $level eq 'HASH' and ref $levname eq 'ARRAY') {
	# workaround for parameter-passing bug in 5.000
	$opts = $level;
	$level = $$levname[1];
	$levname = $$levname[0];
    }
    croak "Invalid arguments to ${myclass}::registerOptions(@_), called"
	if ref $opts ne 'HASH';
    $$self{'Sockopts'}{$levname} = $opts;
    $$self{'Sockopts'}{$level+0} = $opts;
}

sub new				# classname [, \%params]
{				# -or- $classname [, @ignored]
    print STDERR "${myclass}::new(@_)\n" if $debug;
    my($pack,$parms) = @_;
    my %parms;
    %parms = ( %$parms ) if $parms and ref $parms eq 'HASH';
    if (@_ > 2 and $parms and ref $parms eq 'HASH') {
	croak "Invalid argument format to ${myclass}::new(@_), called";
    }
    my $self = {};
    bless $self,$pack;
    print STDERR "${myclass}::new(@_), self=$self after bless\n"
	if $debug > 1;
    $$self{'Parms'} = \%parms;
    $self->registerParamKeys(\@Keys); # register our keys
    $self->registerOptions(['SOL_SOCKET', SOL_SOCKET+0], \%sockopts);
    $$self{'fhref'} = _getfh;
    $self = $self->init if $pack eq $myclass;
    print STDERR "${myclass}::new returning self=$self\n" if $debug;
    $self;
}

sub setparams			# $this, \%newparams [, $newonly [, $check]]
{				# -or- $this, %newparams
    my $self = shift;
    my $errs = 0;
    my $newonly = 0;
    my $check = 0;
    my %newparams;
#    local($^W) = 0;		# shut up warnings about undef values
    if (ref($_[0]) eq 'HASH') {
	%newparams = %{$_[0]};
	$newonly = $_[1] if @_ > 1;
	$check = $_[2] if @_ > 2;
	carp "Excess arguments to ${myclass}::setparams ignored"
	    if @_ > 3;
    }
    elsif ( !(@_ % 2) ) {
	%newparams = @_;
    }
    else {
	croak "Bad arguments to ${myclass}::setparams, called";
    }
    my $parm;
    foreach $parm (keys %newparams) {
	print STDERR "${myclass}::setparams $self $parm $newparams{$parm}\n"
	    if $debug;
	(carp "Unknown parameter type $parm for a " . (ref $self) . " object")
	    , $errs++, next
		unless exists $$self{'Keys'}{$parm};
	next if $newonly < 0 && defined $$self{'Parms'}{$parm};
	if (!$check)
	{
	    # this ungodly construct brought to you by -w
	    next if
		defined($$self{'Parms'}{$parm}) eq defined($newparams{$parm})
		    and
			!defined($newparams{$parm}) ||
			$$self{'Parms'}{$parm} eq $newparams{$parm} ||
			    $$self{'Parms'}{$parm} !~ /\D/ &&
				$newparams{$parm} !~ /\D/ &&
				    $$self{'Parms'}{$parm} == $newparams{$parm}
	    ;
	    # below is how it looked before cleaning up -w complaints
#	    next if $$self{'Parms'}{$parm} eq $newparams{$parm};
#	    next if $$self{'Parms'}{$parm} !~ /\D/ &&
#		$newparams{$parm} !~ /\D/ &&
#		    defined($$self{'Parms'}{$parm}) ==
#			defined($newparams{$parm}) &&
#			    $$self{'Parms'}{$parm} == $newparams{$parm};
	}
	carp("Overwrite of $parm parameter for ".(ref $self)." object ignored")
	    , $errs++, next
		if $newonly > 0 && defined $$self{'Parms'}{$parm};
	if (defined($$self{'Keys'}{$parm}) and
	    (ref($$self{'Keys'}{$parm}) eq 'CODE')) {
	    my $rval = &{$$self{'Keys'}{$parm}}($self,$parm,$newparams{$parm});
	    (carp $rval), $errs++, next if $rval;
	}
	$$self{'Parms'}{$parm} = $newparams{$parm};
    }

    $errs ? undef : 1;
}
    

sub delparams			# $self, [\]@paramnames ; returns bool
{
    my($k,@k,%k,$self,$aref);
    print STDERR "${myclass}::delparams(@_)\n" if $debug;
    $self = shift;
    $aref = \@_;
    $aref = $_[0] if @_ == 1 and ref $_[0] eq 'ARRAY';
    @k = grep(exists $$self{'Parms'}{$_}, @$aref);
    return 1 unless @k;		# if no keys need deleting, succeed vacuously
    @k{@k} = ();		# a hash of undefs for the following
    return undef unless $self->setparams(\%k); # see if undef is allowed
    foreach $k (@k) {		# they don't mind undef for a value, delete
	delete $$self{'Parms'}{$k};
    }
    1;				# return goodness
}

sub delparam;			# (helps with -w)
*delparam = \&delparams;	# fluff for naive callers

sub checkparams			# $self, (void) ; returns bool
{
    print STDERR "${myclass}::checkparams\n" if $debug;
    my $self = shift;
    carp "Excess arguments to ${myclass}::checkparams ignored"
	if @_;
    my $curparms = $$self{'Parms'};
    $curparms = {} unless ref $curparms eq 'HASH';
    # make sure only the valid ones are set when we're done
    $$self{'Parms'} = {};
    my(@valkeys) = grep(exists $$self{'Keys'}{$_}, keys %$curparms);
    # this assignment allows for inter-key dependencies to be evaluated
    @{$$self{'Parms'}}{@valkeys} =
	@{$curparms}{@valkeys};
    # validate all current against the defined keys
    $self->setparams($curparms, 0, 1);
}

sub init			# $self, (void) ; returns updated $self
{
    print STDERR "${myclass}::init(@_)\n" if $debug;
    my($self) = @_;
    $self->checkparams ? $self : undef;
}

sub getparam			# $self, $key [, $default [, $defaultifundef]]
{
    print STDERR "${myclass}::getparam(@_)\n" if $debug > 1;
    my($self,$key,$defval,$noundef) = @_;
    carp "Excess arguments to ${myclass}::getparam($self) ignored"
	if @_ > 4;
    return $defval unless exists($$self{'Parms'}{$key});
    my $value = $$self{'Parms'}{$key};
    $noundef && !defined($value) ? $defval : $value;
}

sub getparams			# $self, \@keys [, $noundef]; returns (%hash)
{				# -or- $self, @keys
    print STDERR "${myclass}::getparams(@_)\n" if $debug > 1;
    my $self=shift;
    my ($aref,$noundef);
    croak "Insufficient arguments to ${myclass}::getparams($self), called"
	if !@_ || !ref $self;
    if (ref $_[0] eq 'ARRAY') {
	$aref = $_[0];
	$noundef = $_[1] if @_ > 1;
	carp "Excess arguments to ${myclass}::getparams($self) ignored"
	    if @_ > 2;
    }
    else {
	$aref = \@_;
    }
# map, alas, is broken in 5.000, so we can't use it here.
#    map {exists($$self{'Parms'}{$_}) &&
#	     (!$noundef || defined($$self{'Parms'}{$_}))
#		 ? ($_, $$self{'Parms'}{$_}) : ();}  @$aref;
    my @ret;
    foreach (@$aref) {
	push(@ret, $_, $$self{'Parms'}{$_})
	    if exists($$self{'Parms'}{$_}) and
		!$noundef || defined($$self{'Parms'}{$_});
    }
    wantarray ? @ret : 0+@ret;
}
    

sub open			# $self [, @ignore] ; returns boolean
{
    print STDERR "${myclass}::open(@_)\n" if $debug > 1;
    my $self = shift;
    $self->stopio if $self->isopen;
    my $fhref = $$self{'fhref'};
    my($pf,$af,$type,$proto) = \@{$$self{'Parms'}}{qw(PF AF type proto)};
    $$pf = PF_UNSPEC unless defined $$pf;
    $$af = AF_UNSPEC unless defined $$af;
    $$type = 0 unless defined $$type;
    $$proto = 0 unless defined $$proto;
    if (($$pf == PF_UNSPEC) && ($$af != AF_UNSPEC)) {
	$$pf = $$af;
    }
    elsif (($$af == AF_UNSPEC) && ($$pf != PF_UNSPEC)) {
	$$af = $$pf;
    }
    if ($$self{'isopen'} = socket($fhref,$$pf,$$type,$$proto)) {
	no strict 'refs';	# pp_select returns a string
	# keep stdio output buffers out of my way
	select((select($fhref),$|=1)[0]);
    }
    $self->isopen;
}

# Establish a value for SOMAXCONN

eval '&SOMAXCONN()' or eval 'sub SOMAXCONN {5}'; # old bsd default if undefined

# sub listen - autoloaded

sub connect			# $self, [@ignored] ; returns boolean
{
    print STDERR "${myclass}::connect(@_)\n" if $debug > 1;
    my $self = shift;
    $self->close if $$self{'wasconnected'} || $$self{'isconnected'};
    $$self{'wasconnected'} = 0;
    return undef unless $self->isopen or $self->open;
    if ($self->getparam('srcaddr') || $self->getparam('srcaddrlist')
	and !$self->isbound) {
	return undef unless $self->bind;
    }
    my $rval;
    if (defined($$self{'Parms'}{'dstaddrlist'}) and
	ref($$self{'Parms'}{'dstaddrlist'}) eq 'ARRAY') {
	my $tryaddr;
	foreach $tryaddr (@{$$self{'Parms'}{'dstaddrlist'}}) {
	    next unless $rval = connect($$self{'fhref'}, $tryaddr);
	    $$self{'Parms'}{'dstaddr'} = $tryaddr;
	    last;
	}
    }
    else {
	$rval = connect($$self{'fhref'}, $$self{'Parms'}{'dstaddr'});
    }
    $$self{'isconnected'} = $rval;
    return $rval unless $rval;
    $self->getsockinfo;
    $self->isconnected;
}

sub getsockinfo			# $self, [@ignored] ; returns ?dest sockaddr?
{
    print STDERR "${myclass}::getsockinfo(@_)\n" if $debug > 3;
    my $self = shift;
    my $fh = $$self{'fhref'};
    my ($sad,$dad);

    $self->setparams({'dstaddr' => $dad}) if $dad = getpeername($fh);
    $self->setparams({'srcaddr' => $sad}) if $sad = getsockname($fh);
    $sad && $dad;
}

sub shutdown			# $self [, $how=2] ; returns boolean
{
    print STDERR "${myclass}::shutdown(@_)\n" if $debug > 2;
    my $self = shift;
    return 1 unless $self->isconnected;
    my $how = shift;
    $how = 2 unless defined $how && grep($how == $_, 0, 1, 2);
    my $was = ($$self{'wasconnected'} |= $how+1);
    my $fhref = $$self{'fhref'};
    my $rval = shutdown($fhref,$how);
    $$self{'isconnected'} = 0 if $was == 3 or
	(!defined(getpeername($fhref)) && ($$self{'wasconnected'} = 3));
    $rval;
}


my @CloseVars = qw(isopen isbound didlisten);
my @CloseKeys = qw(srcaddr dstaddr);

sub close			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::close(@_)\n" if $debug > 2;
    my $self = shift;
    return 1 unless $self->isopen;
    $self->shutdown;
    @$self{@CloseVars} = ();	# these flags no longer true
    $self->delparams(\@CloseKeys); # connection values now invalid
    close($$self{'fhref'});
}

sub stopio			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::stopio(@_)\n" if $debug > 3;
    my $self = shift;
    $$self{'isconnected'} = 0;	# lie to avoid shutdown call
    $self->close;
}

# I/O enries

# Warning!  No intercepting of SIGPIPE is done, so the output routines
# can abort the program.

sub send			# $self, $buf, [$flags] ; returns boolean
{
    print STDERR "${myclass}::send(@_)\n" if $debug > 2;
    my($self,$buf,$flags,$fh) = @_;
    croak "Invalid args to ${myclass}::send, called"
	if @_ < 2 or !ref $self or !($fh = $$self{'fhref'});
    $flags = 0 unless defined $flags;
    carp "Excess arguments to ${myclass}::send ignored" if @_ > 3;
    $self->connect unless $self->isconnected; # send(2) requires connect(2)
    return getsockopt($fh,SOL_SOCKET,SO_TYPE) unless
	$self->isopen;		# generate EBADF return if not open
    send($fh, $buf, $flags);
}

sub sendto			# $self, $buf, $where, [$flags] ; returns bool
{
    print STDERR "${myclass}::sendto(@_)\n" if $debug > 2;
    my($self,$buf,$where,$flags,$fh) = @_;
    croak "Invalid args to ${myclass}::sendto, called"
	if @_ < 3 or !ref $self or !($fh = $$self{'fhref'});
    $flags = 0 unless defined $flags;
    carp "Excess arguments to ${myclass}::sendto ignored" if @_ > 4;
    $self->open unless $self->isopen;
    return getsockopt($fh,SOL_SOCKET,SO_TYPE) unless
	$self->isopen;		# generate EBADF return if not open
    send($fh, $buf, $flags, $where);
}

sub put				# $self, @stuff ; returns boolean
{
    print STDERR "${myclass}::put(@_)\n" if $debug > 2;
    my($self,@args) = @_;
    print {$$self{'fhref'}} @args;
}

sub recv			# $self, [$maxlen, [$flags, [$from]]] ;
{				# returns $buf or undef
    print STDERR "${myclass}::recv(@_)\n" if $debug > 2;
    my($self,$maxlen,$flags) = @_;
    my($buf,$from,$fh,$xfrom) = '';
    croak "Invalid args to ${myclass}::recv, called"
	if !@_ or !ref $self or !($fh = $$self{'fhref'});
    carp "Excess arguments to ${myclass}::recv ignored"
	if @_ > 4;
    return getsockopt($fh,SOL_SOCKET,SO_TYPE) unless
	$self->isopen or $self->open; # generate EBADF return if not open
    $maxlen = unpack('I',getsockopt($fh,SOL_SOCKET,SO_RCVBUF)) ||
	(stat $fh)[11] || 8192
	    unless $maxlen;
    $flags = 0 unless defined $flags;
    if (defined($$self{'sockLineBuf'}) && !$flags) {
	$buf = $$self{'sockLineBuf'};
	$$self{'sockLineBuf'} = undef;
	$_[3] = $$self{'lastFrom'} if @_ > 3;
	return $buf;
    }
    $$self{'lastFrom'} = $xfrom = $from = recv($fh,$buf,$maxlen,$flags);
    $_[3] = $from if @_ > 3;
    return undef if !defined $from;
    $$self{'lastFrom'} = $xfrom = getpeername($fh) if ! length $from;
    $_[3] = $xfrom if @_ > 3 and $from eq '' and $xfrom ne '';
    return $buf if length $buf or length $from;
    # At this point, we have $from defined and eq '', and $buf the same.
    # This only reliably indicates EOF on SOCK_STREAM connections, though.
    return $buf unless
	unpack('I',getsockopt($fh,SOL_SOCKET,SO_TYPE)) == SOCK_STREAM;
    $self->shutdown(0);		# make sure I know about this EOF
    $! = 0;			# no error for EOF
    undef;			# no buffer, either, though
}

sub get;			# (helps with -w)
*get = \&recv;			# a name that works for indirect references

sub getline			# $self ; returns like scalar(<$fhandle>)
{
    print STDERR "${myclass}::getline(@_)\n" if $debug > 3;
    carp "Excess arguments to ${myclass}::getline ignored"
	if @_ > 1;
    my ($self) = @_;
    my $fh;
    croak "Invalid arguments to ${myclass}::getline, called"
	if !@_ or !ref($self) or !($fh = $$self{'fhref'});
    my ($rval, $buf, $tbuf);
    $buf = $$self{'sockLineBuf'};
    $$self{'sockLineBuf'} = undef; # keep get from returning this again
    if (!defined($/)) {
	$rval = <$fh>;		# return all of the input
	$self->shutdown(0);	# keep track of EOF
	return $buf . $rval if defined($buf) or defined($rval);
	return undef;
    }
    my $sep = $/;		# get the current separator
    $sep = "\n\n" if $sep eq ''; # account for paragraph mode
    while (!defined($buf) or $buf !~ /\Q$sep/) {
	$rval = $self->get;
	last unless defined $rval;
	$buf .= $rval;
    }
    if (defined($buf) and ($tbuf = index($buf, $sep)) >= 0) {
	$rval = substr($buf, 0, $tbuf + length($sep));
	$tbuf = substr($buf, length($rval));
	$$self{'sockLineBuf'} = $tbuf if length($tbuf);
	return $rval;
    }
    else {
	return $buf;
    }
}


sub DESTROY
{
    local($!);			# preserve errno since asynchronous call
    local($^W) = 0;		# ignore undef values if incomplete object
    print STDERR "${myclass}::DESTROY(@_)\n" if $debug;
    my $self = shift;
    $self->stopio;
    _delfh \$$self{'fhref'};
}

sub isopen			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::isopen(@_) - " if $debug > 3;
    my $self = shift;
    print STDERR ($$self{'isopen'} ? "yes\n" : "no\n")
	if $debug > 3;
    $$self{'isopen'};
}

sub isconnected			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::isconnected(@_) - " if $debug > 3;
    my $self = shift;
    print STDERR ($$self{'isconnected'} ? "yes\n" : "no\n")
	if $debug > 3;
    $$self{'isconnected'};
}

sub isbound			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::isbound(@_) - " if $debug > 3;
    my $self = shift;
    print STDERR ($$self{'isbound'} ? "yes\n" : "no\n")
	if $debug > 3;
    $$self{'isbound'};
}

1;

# these would have been autoloaded, but autoload and inheritance conflict

sub setdebug			# $this, [bool, [norecurse]] ; returns previous
{
    my $prev = $debug;
    shift;
    $debug = @_ ? $_[0] : 1;
    $prev;
}

# fluff routine to make things easy
sub setparam			# $self, $name, $value, [newonly, [docheck]] ;
{				# returns boolean
    print STDERR "${myclass}::setparam(@_)\n" if $debug;
    my($self,$key,$val,$newonly,$docheck) = @_;
    carp "Excess arguments to ${myclass}::setparam ignored"
	if @_ > 5;
    croak "Invalid arguments to ${myclass}::setparam, called"
	if @_ < 3 or not ref $self or not exists $$self{'Keys'}{$key};
    $self->setparams({$key => $val}, $newonly, $docheck);
}

sub bind			# $self [, @ignored] ; returns boolean
{
    print STDERR "${myclass}::bind(@_)\n" if $debug > 1;
    my $self = shift;
    $self->close if
	$$self{'wasconnected'} || $self->isconnected || $self->isbound;
    return $$self{'isbound'} = undef unless $self->isopen or $self->open;
    my $rval;
    if (defined($$self{'Parms'}{'srcaddrlist'}) and
	ref($$self{'Parms'}{'srcaddrlist'}) eq 'ARRAY') {
	my $tryaddr;
	foreach $tryaddr (@{$$self{'Parms'}{'srcaddrlist'}}) {
	    next unless $rval = bind($$self{'fhref'}, $tryaddr);
	    $$self{'Parms'}{'srcaddr'} = $tryaddr;
	    last;
	}
    }
    elsif (defined($$self{'Parms'}{'srcaddr'}) and
	   length $$self{'Parms'}{'srcaddr'}) {
	$rval = bind($$self{'fhref'}, $$self{'Parms'}{'srcaddr'});
    }
    else {
	$rval = bind($$self{'fhref'}, pack('S@16',$$self{'Parms'}{'AF'}));
    }
    $$self{'isbound'} = $rval;
    return undef unless $rval;
    $self->getsockinfo;
    $self->isbound;
}

sub unbind			# $self [, @ignored] ; return not useful
{
    print STDERR "${myclass}::unbind(@_)\n" if $debug > 1;
    my($self) = @_;
    $self->close unless $self->isconnected;
    $self->delparams('srcaddrlist');
}

sub listen			# $self [, $maxq=SOMAXCONN] ; returns boolean
{
    print STDERR "${myclass}::listen(@_)\n" if $debug > 1;
    my ($self,$maxq) = @_;
    $maxq = SOMAXCONN if !defined($maxq);
    croak "Invalid args for ${myclass}::listen(@_), called" if
	$maxq =~ /\D/ or !ref $self or !$$self{'fhref'};
    carp "Excess args for ${myclass}::listen(@_) ignored" if @_ > 2;
    return undef unless $self->isbound or $self->bind;
    $$self{'didlisten'} = $maxq;
    listen($$self{'fhref'},$maxq) or undef $$self{'didlisten'};
}

sub didlisten			# $self [, @ignored] ; returns boolean
{
    my($self) = @_;
    print STDERR "${myclass}::didlisten(@_) - ",
	($$self{'didlisten'} ? "yes" : "no"), "\n"
	    if $debug > 3;
    $$self{'didlisten'};
}

sub TIESCALAR
{
    print STDERR "${myclass}::TIESCALAR(@_)\n" if $debug > 1;
    my $class = shift;
    my $self = $class->new(@_);
    $self && $self->isconnected && $self;
}

sub FETCH
{
    print STDERR "${myclass}::FETCH(@_)\n" if $debug > 1;
    my $self = shift;
    getline $self;
}

sub STORE
{
    print STDERR "${myclass}::STORE(@_)\n" if $debug > 1;
    my $self = shift;
    $self->put(@_);
}

# socket-option routines

sub _findxopt			# $self, $realp, @args ;
{				# returns ($aref,@subargs)
    my($self,$realp,@args) = @_;
    my($aref,$level,$what);
    $level = shift @args;	# try input arg as level first
    if ($level =~ /^(0x[\da-f]+|0[0-7]*|[1-9]\d*)$/si) {
	# if numeric, it had better be the level
	$level = ((substr($level, 0, 1) eq '0') ? oct($level) : $level+0);
    }
    $aref = $$self{'Sockopts'}{$level};
    if (!$aref) {
	# here, we have to search for the ruddy thing by keyword
	# if level was numeric, punt by trying to force EINVAL
	until ($level =~ /\D/) {
	    # numeric level, check for realp and numeric what
	    last unless $realp;
	    $what = shift @args;
	    last unless $what =~ /^(0x[\da-f]+|0[0-7]*|[1-9]\d*)$/si;
	    $what = ((substr($what, 0, 1) eq '0') ? oct($what) : $what+0);
	    $aref = ['h*', $what, $level, 0+@args];
	    unshift(@args, $aref);
	    return @args;
	}
	return getsockopt($$self{'fhref'},-1,-1) unless $level =~ /\D/;
	$what = $level;
	foreach $level (keys %{$$self{'Sockopts'}}) {
	    next unless ref($$self{'Sockopts'}{$level}) eq 'HASH';
	    last if $aref = $$self{'Sockopts'}{$level}{$what};
	}
	$$self{'Sockopts'}{$what} = $aref if ref $aref eq 'ARRAY';
    }
    elsif (ref $aref eq 'HASH') {
	$what = shift @args;
	if ($what =~ /^(0x[\da-f]+|0[0-7]*|[1-9]\d*)$/si) {
	    $what = ((substr($what, 0, 1) eq '0') ? oct($what) : $what+0);
	}
	$aref = $$aref{$what};
    }
    # force EINVAL (I hope) if unrecognized value
    return getsockopt($$self{'fhref'},-1,-1) unless ref $aref eq 'ARRAY';
    ($aref,@args);
}

sub _getxopt			# $this, $realp, [$level,] $what
{
    my($self,$realp,@args) = @_;
    my($aref,$level,$what,$rval,$format);
    @args = $self->_findxopt($realp, @args); # get the array ref
    return undef unless $aref = shift @args;
    carp "Excess args to getsockopt ignored" if @args;
    $what = $$aref[1];
    $level = $$aref[2];
    $format = $$aref[0];
    $rval = getsockopt($$self{'fhref'},$level+0,$what+0);
    if ($debug > 3) {
	@args = unpack($format,$rval);
	print STDERR " - getsockopt $self,$level,$what => ";
	print STDERR (defined $rval ? "@args\n" : "(undef)\n");
    }
    return $rval if $realp;
    return () unless defined $rval;
    unpack($format,$rval);
}

sub getsopt			# $this, [$level,] $what
{
    my($self,@args) = @_;
    $self->_getxopt(0,@args);
}

sub getropt			# $this, [$level,] $what
{
    my($self,@args) = @_;
    $self->_getxopt(1,@args);
}

sub _setxopt			# $this, $realp, [$level,] $what, @vals
{
    my($self,$realp,@args) = @_;
    my($aref,$level,$what,$rval,$format);
    @args = $self->_findxopt($realp, @args); # get the array ref and real args
    return undef unless $aref = shift @args;
    $what = $$aref[1];
    $level = $$aref[2];
    $format = $$aref[0];
    if ($realp) {
	$rval = shift @args;
    }
    else {
	$rval = pack($format, @args);
	carp "Excess args to ${myclass}::setsopt ignored"
	    if @args > $$aref[3];
    }
    print STDERR " - setsockopt $self,$level,$what,",
	join($",unpack($format,$rval)),"\n"
	    if $debug > 3;
    setsockopt($$self{'fhref'},$level+0,$what+0,$rval);
}

sub setsopt			# $this, [$level,] $what, @vals
{
    print STDERR "${myclass}::setsopt(@_)\n" if $debug > 1;
    my($self,@args) = @_;
    $self->_setxopt(0,@args);
}

sub setropt			# $this, [$level,] $what, $realvalue
{
    print STDERR "${myclass}::setropt(@_)\n" if $debug > 1;
    my($self,@args) = @_;
    $self->_setxopt(1,@args);
}

#sub fileno			# $this
#{
#    print STDERR "${myclass}::fileno(@_)\n" if $debug > 3;
#    my($self) = @_;
#    fileno($$self{'fhref'});
#}

sub fhvec			# $this
{
    print STDERR "${myclass}::fhvec(@_)\n" if $debug > 3;
    my($self) = @_;
    return getsockopt($$self{'fhref'},SOL_SOCKET,SO_TYPE) unless
	$self->isopen or
	    fileno($$self{'fhref'}); # generate EBADF return if not open
    my $vec = '';
    vec($vec, fileno($$self{'fhref'}), 1) = 1;
    $vec;
}

sub select			# $this [[, $read, $write, $xcept, $timeout]]
{
    print STDERR "${myclass}::select(@_)\n" if $debug > 3;
    my($self,$doread,$dowrite,$doxcept,$timer) = @_;
    my($fhvec,$rvec,$wvec,$xvec,$nfound,$timeleft) = $self->fhvec;
    return () unless $fhvec;
    $rvec = $doread ? $fhvec : undef;
    $wvec = $dowrite ? $fhvec : undef;
    $xvec = $doxcept ? $fhvec : undef;
    ($nfound, $timeleft) = select($rvec, $wvec, $xvec, $timer)
	or return ();
    my @ret = ($nfound, $timeleft,
	       $doread && $rvec eq $fhvec,
	       $dowrite && $wvec eq $fhvec,
	       $doxcept && $xvec eq $fhvec);
    @ret;
}

sub ioctl			# $this, @args
{
    print STDERR "${myclass}::ioctl(@_)\n" if $debug > 3;
    croak "Insufficient arguments to ${myclass}::ioctl(@_), found"
	if @_ < 3;
    carp "Excess arguments to ${myclass}::ioctl ignored"
	if @_ > 3;
    ioctl($_[0]->{'fhref'}, $_[1], $_[2]);
}

sub fcntl			# $this, @args
{
    print STDERR "${myclass}::fcntl(@_)\n" if $debug > 3;
    croak "Insufficient arguments to ${myclass}::fcntl(@_), found"
	if @_ < 3;
    carp "Excess arguments to ${myclass}::fcntl ignored"
	if @_ > 3;
    fcntl($_[0]->{'fhref'}, $_[1], $_[2]);
}

sub format_addr			# $thunk, $sockaddr
{
    return undef unless defined $_[1];
    my($rval,$fam,$addr);
    ($fam,$addr) = unpack_sockaddr($_[1]) or return undef;
    $rval = "[${fam}]:";
    if (defined($addr) and length($addr)) {
	$rval .= "0x" . unpack('h*', $addr);
    }
    else {
	$rval .= "(null)";
    }
    $rval;
}

sub format_local_addr		# $this, [@args]
{
    my($self,@args) = @_;
    $self->format_addr($self->getparam('srcaddr'),@args);
}

sub format_remote_addr		# $this, [@args]
{
    my($self,@args) = @_;
    $self->format_addr($self->getparam('dstaddr'),@args);
}

# autoloaded methods go after the END clause (& pod) below

__END__

=head1 NAME

Net::Gen - generic sockets interface handling

=head1 SYNOPSIS

    use Net::Gen;

=head1 DESCRIPTION

The C<Net::Gen> module provides basic services for handling
socket-based communications.  It supports no particular protocol
family directly, however, so it is of direct use primarily to
implementors of other modules.  To this end, several housekeeping
functions are provided for the use of derived classes, as well as
several inheritable methods.

Also provided in this distribution are C<Net::Inet> and C<Net::TCP>,
which are layered atop C<Net::Gen>.

=head2 Public Methods

=over 6

=item new

Usage:

    $obj = Net::Gen::new $classname;
    $obj = Net::Gen::new $classname, \%parameters;

Returns a newly-initialised object of the given class.  If called
for a class other than C<Net::Gen>, no validation of the supplied
parameters will be performed.  (This is so that the derived class
can add the parameter validation it needs to the object before
allowing validation.)

=item init

Usage:

    return undef unless $self = $self->init;

Verifies that all previous parameter assignments are valid (via
C<checkparams>).  Returns the incoming object on success, and
C<undef> on failure.

=item checkparams

Usage:

    $ok = $obj->checkparams;

Verifies that all previous parameter assignments are valid.
(Normally called only via the C<init> method, rather than
directly.)

=item setparams

Usage:

    $ok = $obj->setparams(\%newparams, $newonly, $checkup);
    $ok = $obj->setparams(\%newparams, $newonly);
    $ok = $obj->setparams(\%newparams);

Sets new parameters from the given hashref, with validation.
This is done in a loop over the key, value pairs from the
C<newparams> parameter.  The precise nature of the validation
depends on the C<$newonly> and C<$checkup> parameters (which are
optional), but in all cases the keys to be set are checked
against those registered with the object.  If the C<$newonly>
parameter is negative, the value from the hashref will only be
set if there is not already a defined value associated with that
key, but skipping the setting of the value is silent.  If the
C<$newonly> parameter is not negative or if there is no existing
defined value, if the C<$checkup> parameter is false then the
setting of the new value is skipped if the new value is identical
to the old value.  If those checks don't cause the setting of a
new value to be skipped, then if the C<$newonly> parameter is
positive and there is already a defined value for the specified
key, a warning will be issued and the new value will not be set.

If none of the above checks cause the setting of a new value to
be skipped, but if the specified key has a validation routine,
that routine will be called with the given object, the current
key, and the proposed new value as parameters.  It is allowed for
the validation routine to alter the new-value argument to change
what will be set.  (This is useful when changing a hostname to be
in canonical form, for example.)  If the validation routine
returns a non-null string, that will be used to issue a warning,
and the new value will not be set.  If the validation routine
returns a null string (or if there is no validation routine), the
new value will (finally) get set for the given key.

The C<setparams> method returns 1 if all parameters were
successfully set, and C<undef> otherwise.

=item setparam

Usage:

    $ok = $obj->setparam($key, $value, $newonly, $checkup);
    $ok = $obj->setparam($key, $value, $newonly);
    $ok = $obj->setparam($key, $value);

Sets a single new parameter.  Uses the C<setparams> method, and
has the same rules for the handling of the C<$newonly> and
C<$checkup> parameters.  Returns 1 if the set was successful, and
C<undef> otherwise.

=item delparams

Usage:

    $ok = $obj->delparams(\@keynames);

Removes the settings for the specified parameters.  Uses the
C<setparams> method (with C<undef> for the values) to validate
that the removal is allowed by the owning object.  If the
invocation of C<setparams> is successful, then the parameters in
question are removed.  Returns 1 if all the removals were
successful, and C<undef> otherwise.

=item delparam

Usage:

    $ok = $obj->delparam($keyname);

Sugar-coated call to the C<delparams> method.  Functions just like it.

=item getparams

Usage:

    %hash = $obj->getparams(\@keynames, $noundefs);
    %hash = $obj->getparams(\@keynames);

Returns a hash (I<not> a reference) consisting of the key-value
pairs corresponding to the specified keyname list.  Only those
keys which exist in the current parameter list of the object will
be returned.  If the C<$noundefs> parameter is present and true,
then existing keys with undefined values will be suppressed like
non-existent keys.

=item getparam

Usage:

    $value = $obj->getparam($key, $defval, $def_if_undef);
    $value = $obj->getparam($key, $defval);
    $value = $obj->getparam($key);

Returns the current setting for the named parameter (in the
current object), or the specified default value if the parameter
is not in the object's current parameter list.  If the optional
C<$def_if_undef> parameter is true, then undefined values will be
treated the same as non-existent keys, and thus will return the
supplied default value.

=item open

Usage:

    $ok = $obj->open;

Makes a call to the socket() builtin, using the current object
parameters to determine the desired protocol family, socket type,
and protocol number.  If the object was already open, its
C<stopio> method will be called before socket() is called again.
The object parameters consulted (and possibly updated) are C<PF>,
C<AF>, C<proto>, and C<type>.  Returns true if the socket() call
results in an open filehandle, C<undef> otherwise.

=item listen

Usage:

    $ok = $obj->listen($maxqueue);
    $ok = $obj->listen;

Makes a call to the listen() builtin on the filehandle associated
with the object.  Propagates the return value from listen().  If
the C<$maxqueue> parameter is missing, it defaults to
C<SOMAXCONN>.  If the C<SOMAXCONN> constant is not available in
your configuration, the default value used for the C<listen>
method is 5.  This method will fail if the object is not bound
and cannot be made bound by a simple call to its C<bind> method.

=item bind

Usage:

    $ok = $obj->bind;

Makes a call to the bind() builtin on the filehandle associated
with the object.  The arguments to bind() are determined from the
current parameters of the object.  First, if the filehandle has
previously been bound or connected, it is closed.  Then, if it is
not currently open, a call to the C<open> method is made.  If all
that works (which may be a no-op), then the following list of
possible values is tried for the bind() builtin: First, the
C<srcaddrlist> object parameter, if its value is an array
reference.  The elements of the array are tried in order until a
bind() succeeds or the list is exhausted.  Second, if the
C<srcaddrlist> parameter is not set to an array reference, if the
C<srcaddr> parameter is a non-null string, it will be used.
Finally, if neither C<srcaddrlist> nor C<srcaddr> is suitably
set, the C<AF> parameter will be used to construct a C<sockaddr>
struct which will be mostly zeroed, and the bind() will be
attempted with that.  If the bind() fails, C<undef> will be
returned at this point.  Otherwise, a call to the C<getsockinfo>
method will be made, and then the value from a call to the
C<isbound> method will be returned.

If all that seems too confusing, don't worry.  Most clients will
never need to do an explicit C<bind> call, anyway.  If you're
writing a server or a privileged client which does need to bind
to a particular local port or address, and you didn't understand
the foregoing discussion, you may be in trouble.  Don't panic
until you've checked the discussion of binding in the derived
class you're using, however.

=item unbind

Usage:

    $obj->unbind;

Removes any saved binding for the object.  Unless the object is
currently connected, this will result in a call to its C<close>
method, in order to ensure that any previous binding is removed.
Even if the object is connected, the C<srcaddrlist> object
parameter is removed (via the object's C<delparams> method).  The
return value from this method is indeterminate, but will almost
always be the value 1.

=item connect

Usage:

    $ok = $obj->connect;

Attempts to establish a connection for the object.  First, if the
object is currently connected or has been connected since the
last time it was opened, its C<close> method is called.  Then, if
the object is not currently open, its C<open> method is called.
If it's not open after that, C<undef> is returned.  If it is
open, and if either of its C<srcaddrlist> or C<srcaddr>
parameters are set to indicate that a bind() is desired, and it
is not currently bound, its C<bind> method is called.  If the
C<bind> method is called and fails, C<undef> is returned.  (Most
of the foregoing is a no-op for simple clients, so don't panic.)

Next, if the C<dstaddrlist> object parameter is set to an array
reference, a call to connect() is made for each element of the
list until it succeeds or the list is exhausted.  If the
C<dstaddrlist> parameter is not an array reference, a single
attempt is made to call connect() with the C<dstaddr> object
parameter.  If no connect() call succeeded, C<undef> is returned.
Finally, a call is made to the object's C<getsockinfo> method,
and then the value from a call to its C<isconnected> method is
returned.

Note that the derived classes tend to provide additional
capabilities which make the C<connect> method easier to use than
the above description would indicate.

=item getsockinfo

Usage:

    $peersockaddr = $obj->getsockinfo;

Attempts to determine connection parameters associated with the
object.  If a getsockname() call on the associated filehandle
succeeds, the C<srcaddr> object parameter is set to that returned
sockaddr.  If a getpeername() call on the associated filehandle
succeeds, the C<dstaddr> parameter is set to that returned
sockaddr.  If both socket addresses were found, the getpeername()
value is returned, otherwise C<undef> is returned.

Derived classes normally replace this method with one which
provides friendlier return information appropriate to the derived
class, and which establishes more of the object parameters.

=item shutdown

Usage:

    $ok = $obj->shutdown($how);
    $ok = $obj->shutdown;

Calls the shutdown() builtin on the filehandle associated with
the object.  This method is a no-op, returning 1, if the
filehandle is not connected.  The C<$how> parameter is as per the
shutdown() builtin, which in turn should be as described in the
shutdown(2) manpage.

Returns 1 if nothing to do, otherwise propagates the return from
the shutdown() builtin.

=item stopio

Usage:

    $ok = $obj->stopio;

Calls the close() builtin on the filehandle associated with the
object, unless that filehandle is already closed.  Returns 1 or
the return value from the close() builtin.  This method is
primarily for the use of server modules which need to avoid
C<shutdown> calls at inappropriate times.  This method calls the
C<delparams> method for the keys of C<srcaddr> and C<dstaddr>.

=item close

Usage:

    $ok = $obj->close;

The C<close> method is like a call to the C<shutdown> method
followed by a call to the C<stopio> method.  It is the standard
way to close down an object.

=item send

Usage:

    $ok = $obj->send($buffer, $flags);
    $ok = $obj->send($buffer);

This method calls the send() builtin (three-argument form).  The
C<$flags> parameter is defaulted to 0 if not supplied.  The
return value from the send() builtin is returned.  This method
makes no attempt to trap C<SIGPIPE>.

=item sendto

Usage:

    $ok = $obj->sendto($buffer, $destsockaddr, $flags);
    $ok = $obj->sendto($buffer, $destsockaddr);

This method calls the send() builtin (four-argument form).  The
C<$flags> parameter is defaulted to 0 if not supplied.  The
return value from the send() builtin is returned.  This method
makes no attempt to trap C<SIGPIPE>.

=item put

Usage:

    $ok = $obj->put(@whatever);
    $ok = put $obj @whatever;

This method uses the print() builtin to send the @whatever
arguments to the filehandle associated with the object.  That
filehandle is always marked for autoflushing by the C<open>
method, so the method is in effect equivalent to this:

    $ok = $obj->send(join($, , @whatever) . $\ , 0);

However, since multiple fwrite() calls are involved in the actual
use of print(), this method can be more efficient than the above
code sample for large strings in the argument list.  It's a bad
idea except on stream sockets (C<SOCK_STREAM>), though, since the
record boundaries are unpredictable through stdio.  This method
makes no attempt to trap C<SIGPIPE>.

=item recv

Usage:

    $record = $obj->recv($maxlen, $flags, $whence);
    $record = $obj->recv($maxlen, $flags);
    $record = $obj->recv($maxlen);
    $record = $obj->recv;

This method calls the recv() builtin, and returns a buffer (if
one is received) or C<undef> on eof or error.  If an eof on a
stream socket is seen, C<$!> will be C<undef> as well as the
return value.  If the C<$whence> argument is supplied, it will be
filled in with the sending socket address if possible.  If the
C<$flags> argument is not supplied, it defaults to 0.  If the
C<$maxlen> argument is not supplied, it is defaulted to the
receive buffer size of the associated filehandle (if known), or
the preferred blocksize of the associated filehandle (if known,
which it usually won't be), or 8192.

=item get

This is identical to the C<recv> method, except that its name is
not (yet) known to perl, so indirect calls work, as well as
object-style calls.

=item getline

This is a simulation of C<E<lt>$filehandleE<gt>> that doesn't let
stdio confuse the C<get>/C<recv> method.

=item isopen

Usage:

    $ok = $obj->isopen;

Returns true if the object currently has a socket attached to its
associated filehandle, and false otherwise.  If this method has
not been overridden by a derived class, the value is the saved
return value of the call to the socket() builtin (if it was
called).

=item isconnected

Usage:

    $ok = $obj->isconnected;

Returns true if the object's C<connect> method has been used
successfully to establish a "session", and that session is still
connected.  If this method has not been overridden by a derived
class, the value is the saved return value of the call to the
connect() builtin (if it was called).

=item isbound

Usage:

    $ok = $obj->isbound;

Returns true if the object's C<bind> method has been used
successfully, and the binding is still in effect.  If this method
has not been overridden by a derived class, the value is the
saved return value of the call to the bind() builtin (if it was
called).

=item didlisten

Usage:

    $ok = $obj->didlisten;

Returns true if the object's C<listen> method has been used
successfully, and the object is still bound.  If this method has
not been overridden by a derived class, the value is C<undef> on
failure and the C<$maxqueue> value used for the listen() builtin
on success.

=item getsopt

Usage:

    @optvals = $obj->getsopt($level, $option);
    @optvals = $obj->getsopt($optname);

Returns the unpacked values from a call to the getsockopt()
builtin.  In order to do the unpacking, the socket option must
have been registered with the object.  See the discussion below
in socket options.

Since registered socket options are known by name as well as by
their level and option values, it is possible to make calls using
only option name.  If the name is not registered with the object,
the return value is the same as that for C<getsopt $obj -1,-1>,
which is an empty return array and $! set appropriately (should
be C<EINVAL>).

Examples:

    ($sotype) = $obj->getsopt('SO_TYPE');
    @malinger = $obj->getsopt(SOL_SOCKET, SO_LINGER);
    ($sodebug) = $obj->getsopt('SOL_SOCKET', 'SO_DEBUG');

=item getropt

Usage:

    $optsetting = $obj->getropt($level, $option);
    $optsetting = $obj->getropt($optname);

Returns the raw value from a call to the getsockopt() builtin.
If both the C<$level> and C<$option> arguments are given as
numbers, the getsockopt() call will be made even if the given
socket option is not registered with the object.  Otherwise, the
return value for unregistered objects will be undef with the
value of $! set as described above for the C<getsopt> method.

=item setsopt

Usage:

    $ok = $obj->setsopt($level, $option, @optvalues);
    $ok = $obj->setsopt($optname, @optvalues);

Returns the result from a call to the setsockopt() builtin.  In
order to be able to pack the C<@optvalues>, the option must be
registered with the object, just as for the C<getsopt> method,
above.

=item setropt

Usage:

    $ok = $obj->setsopt($level, $option, $rawvalue);
    $ok = $obj->setsopt($optname, $rawvalue);

Returns the result from a call to the setsockopt() builtin.  If
the $level and $option arguments are both given as numbers, the
setsockopt() call will be made even if the option is not
registered with the object.  Otherwise, unregistered options will
fail as for the C<setsopt> method, above.

=item fhvec

Usage:

    $vecstring = $obj->fhvec;

Returns a vector suitable as an argument to the 4-argument select()
call.  For use in doing selects with multiple I/O streams.

=item select

Usage:

    ($nfound, $timeleft, $rbool, $wbool, $xbool) =
	$obj->select($doread, $dowrite, $doxcept, $timeout);

Issues a 4-argument select() call for the associated I/O stream.
All arguments are optional.  The $timeout argument is the same as
the fourth argument to select().  The first three are booleans, used
to determine whether the select() should include the object's I/O stream
in the corresponding parameter to the select() call.  The return is
the standard two values from select(), follwed by booleans indicating
whether the actual select() call found reading, writing, or exception
to be true.

=item ioctl

Usage:

    $rval = $obj->ioctl($func, $value);

Returns the result of an ioctl() call on the associated I/O stream.

=item fcntl

Usage:

    $rval = $obj->fcntl($func, $value);

Returns the result of an fcntl() call on the associated I/O stream.

=item format_addr

Usage:

    $string = $obj->format_addr($sockaddr);
    $string = format_addr Module $sockaddr;

Returns a formatted representation of the address.  This is a
method so that it can be overridden by derived classes.  It is
used to implement ``pretty-printing'' methods for source and
destination addresses.

=item format_local_addr

Usage:

    $string = $obj->format_local_addr;

Returns a formatted representation of the local socket address
associated with the object.

=item format_remote_addr

Usage:

    $string = $obj->format_remote_addr;

Returns a formatted representation of the remote socket address
associated with the object.

=back

=head2 Protected Methods

Yes, I know that Perl doesn't really have protected methods as
such.  However, these are the methods which are only useful for
implementing derived classes, and not for the general user.

=over 6

=item initsockopts

Usage:

    $classname->initsockopts($level, \%optiondesc);

Given a prototype optiondesc hash ref, updates it to include all
the data needed for the values it can find, and deletes the ones
it can't.  For example, here's a single entry from such a
prototype optiondesc:

    'SO_LINGER' => ['II'],

Given that, and the $level of C<SOL_SOCKET>, and the incoming
class name of C<Net::Gen>, C<initsockopts> will attempt to
evaluate C<SO_LINGER> in package C<Net::Gen>, and if it succeeds
it will fill out the rest of the information in the associated
array ref, and add another key to the hash ref for the value of
C<SO_LINGER> (which is 128 on my system).  If it can't evaluate
that psuedo-constant, it will simply delete that entry from the
referenced hash.  Assuming a successful evaluation of this entry,
the resulting entries would look like this:

    'SO_LINGER' => ['II', SO_LINGER+0, SOL_SOCKET+0, 2],
    SO_LINGER+0 => ['II', SO_LINGER+0, SOL_SOCKET+0, 2],

(All right, so the expressions would be known values, but maybe
you get the idea.)

A completed optiondesc hash is a set of key-value pairs where the
value is an array ref with the following elements:

    [pack template, option value, option level, pack array len]

Such a completed optiondesc is one of the required arguments to
the C<registerOptions> method (see below).

=item registerOptions

Usage:

    $obj->registerOptions($levelname, $level, \%optiondesc);

This method attaches the socket options specified by the given
option descriptions hash ref and the given level (as text and as
a number) to the object.  The registered set of socket options is
in fact a hashref of hashrefs, where the keys are the level names
and level numbers, and the values are the optiondesc hash refs
which get registered.

Example:

    $self->registerOptions('SOL_SOCKET', SOL_SOCKET+0, \%sockopts);

=item registerParamKeys

Usage:

    $obj->registerParamKeys(\@keynames);

This method registers the referenced keynames as valid parameters
for C<setparams> and the like for this object.  The C<new>
methods can store arbitrary parameter values, but the C<init>
method will later ensure that all those keys eventually got
registered.  This out-of-order setup is allowed because of
possible cross-dependencies between the various parameters, so
they have to be set before they can be validated (in some cases).

=item registerParamHandlers

Usage:

    $obj->registerParamHandlers(\@keynames, \@keyhandlers);

This method registers the referenced keynames (if they haven't
already been registered), and establishes the referenced
keyhandlers as validation routines for those keynames.  Each
element of the keyhandlers array must be a code reference.  When
the C<setparams> method invokes the handler, it will be called
with three arguments: the target object, the keyname in question,
and the proposed new value (which may be C<undef>, especially if
being called from the C<delparams> method).  See the other
discussion of validation routines in the C<setparams> method
description, above.

=back

=head2 Known Socket Options

These are the socket options known to the C<Net::Gen> module
itself:

=over 6

=item Z<>

C<SO_ACCEPTCONN>,
C<SO_BROADCAST>,
C<SO_DEBUG>,
C<SO_DONTROUTE>,
C<SO_ERROR>,
C<SO_KEEPALIVE>,
C<SO_OOBINLINE>,
C<SO_REUSEADDR>,
C<SO_USELOOPBACK>,
C<SO_RCVBUF>,
C<SO_SNDBUF>,
C<SO_RCVTIMEO>,
C<SO_SNDTIMEO>,
C<SO_RCVLOWAT>,
C<SO_SNDLOWAT>,
C<SO_TYPE>,
C<SO_LINGER>

=back

=head2 Known Object Parameters

These are the object parameters registered by the C<Net::Gen>
module itself:

=over 6

=item PF

Protocol family for this object

=item AF

Address family (will default from PF, and vice versa)

=item type

The socket type to create (C<SOCK_STREAM>, C<SOCK_DGRAM>, etc.)

=item proto

The protocol to pass to the socket() call (often defaulted to 0)

=item dstaddr

The result of getpeername(), or an ephemeral proposed connect() address

=item dstaddrlist

A reference to an array of socket addresses to try for connect()

=item srcaddr

The result of getsockname(), or an ephemeral proposed bind() address

=item srcaddrlist

A reference to an array of socket addresses to try for bind()

=back

=head2 Non-Method Subroutines

=over 6

=item pack_sockaddr

Usage:

    $connect_address = pack_sockaddr($family, $fam_addr);

Returns a packed C<struct sockaddr> corresponding to the provided
$family (which must be a number) and the address-family-specific
$fam_addr (pre-packed).

=item unpack_sockaddr

Usage:

    ($family, $fam_addr) = unpack_sockaddr($packed_address);

The inverse of pack_sockaddr().

=back

=head2 Exports

=over 6

=item default

None.

=item exportable

C<pack_sockaddr>,
C<unpack_sockaddr>

=item tags

None, since that version of F<Exporter.pm> is not yet standard.
Wait for Perl version 5.002.

=back

=head1 AUTHOR

Spider Boardman <F<spider@Orb.Nashua.NH.US>>

=cut

#other sections should be added, sigh.

#any real autoloaded methods go after this line
