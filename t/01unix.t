#!perl -w

use Test;
use Config ();
use strict;

# Special-case the constants we need later
use Socket 'SOCK_STREAM';

# Pre-declarations a la `sub SOCK_STREAM' would also have done.


# Start defining the tests as subroutines, and using BEGIN blocks to
# populate the test vector.  This way, we can call plan() in a BEGIN block
# near the end of the file, and get the count of tests in an automated
# fashion.  I hate having to try to keep a count in sync with the tests
# themselves.  Note that this still depends on leaving the `use' statements
# for the modules to be tested to the bitter end, as well, so that the
# plan() call will spit out the expected number of tests *before* we run
# the risk of unsuccessful DynaLoader calls.

my @testvec;			# list of code refs to call
my %testvals;			# hash (indexed by stringified code ref)
				# of test results so far -- used if test_bar()
				# should be skipped if test_foo() failed
				# e.g.:  skip(!$testvals{\&test_foo}, ....);

my @endav;			# list of coderefs to call in an END block,
				# since some versions of perl won't let us
				# have more than one END in a given package

my %todos;			# hash (indexed by stringified code ref)
				# with keys indicating routines which
				# are expected to fail -- used to build
				# the `todo' parameter to plan()

END { for my $endcv (@endav) { $endcv->() } }

# I'm ass-u-ming (for the nonce) that ok() and skip() return their
# `ok-ness' (as they do in 1.08), so that the test routines can just
# propagate that return back out to the actual test driver, which will
# `remember' it in %testvals.  If JPRIT agrees that this should be part
# of the interface, I win.  If not, I'll have to re-think the calling
# sequence.

sub tdriver ()			# run the code refs in @testvec
{
    for my $cv (@testvec) {
	my $ok = $cv->();
	$testvals{"$cv"} = $ok;
    }
}


# start of test routines


# Rather than do lots of little BEGIN {push @testvec, \&t_...} blocks,
# wrap the whole test region in a single BEGIN.  It doesn't change
# how most of the subs are compiled, and it's (slightly) more efficient.

BEGIN {

# Can't #define here (reliably, anyway), so abuse some `static my' values.

my $sockname = 'srvr';

my $srvr;			# server socket we're using
my $clnt;			# client socket we're using
my $acpt;			# secondary (accept()ing) server socket

# get a server socket to use
sub t_open_srvr_dgram {
    unlink $sockname;
    $srvr = 'Net::UNIX::Server'->new($sockname);
    my $srvok = $srvr && $srvr->isbound;
    push(@endav, sub { unlink $sockname}) if $srvok;
    ok $srvok;
}
push @testvec, \&t_open_srvr_dgram;

# get a client to talk to the server
sub t_open_clnt_dgram {
    $clnt = 'Net::UNIX'->new($sockname);
    ok $clnt && $clnt->isconnected;
}
push @testvec, \&t_open_clnt_dgram;

# not worth trying to proceed if can't open the sockets
sub t_dgram_both_open {
    exit 1	unless $testvals{\&t_open_clnt_dgram}
		       && $testvals{\&t_open_srvr_dgram};
    ok 1;
}
push @testvec, \&t_dgram_both_open;

# send a hello
my $sentmsg;
sub t_send_hello_dgram {
    $sentmsg = "Wowsers!";
    my $sendok = $clnt->send($sentmsg);
    ok $sendok;
}
push @testvec, \&t_send_hello_dgram;

# check receipt
sub t_chk_hello_dgram {
    my $gotmsg = $srvr->recv(40);
    ok $gotmsg, $sentmsg;
}
push @testvec, \&t_chk_hello_dgram;

# fail to reply
sub t_chk_noreply_dgram {
    $sentmsg = "Sorry, chief.";
    my $sendok = $srvr->send($sentmsg);
    ok !$sendok;
}
push @testvec, \&t_chk_noreply_dgram;

# check close status
sub t_chk_closes_dgram {
    ok $srvr->close && $clnt->close;
}
push @testvec, \&t_chk_closes_dgram;

# get a new server for stream sockets
sub t_open_srvr_strm {
    unlink $sockname;
    $srvr = 'Net::UNIX::Server'->new($sockname, {type => SOCK_STREAM});
    ok $srvr && $srvr->isbound && $srvr->didlisten;
}
push @testvec, \&t_open_srvr_strm;

# get a new client for stream sockets
sub t_open_clnt_strm {
    $clnt = 'Net::UNIX'->new($sockname, {type => SOCK_STREAM});
    ok $clnt && $clnt->isconnected;
}
push @testvec, \&t_open_clnt_strm;

# bug out if can't open stream sockets
sub t_stream_both_open {
    exit 1 unless $testvals{\&t_open_srvr_strm}
		  && $testvals{\&t_open_clnt_strm};
    ok 1;
}
push @testvec, \&t_stream_both_open;

# accept the client connection (and drop the listener)
sub t_srvr_accept_strm {
    $acpt = $srvr->accept;
    ok $acpt && $srvr->close;
}
push @testvec, \&t_srvr_accept_strm;

# send a greeting
sub t_srvr_greet_strm {
    $sentmsg = "Wowsers!\n";	# a full line for checks below
    ok $acpt->send($sentmsg);
}
push @testvec, \&t_srvr_greet_strm;

# check receipt
sub t_clnt_greeted_strm {
    my $gotmsg = $clnt->getline;
    ok $gotmsg, $sentmsg;
}
push @testvec, \&t_clnt_greeted_strm;

# reply
sub t_clnt_reply_strm {
    $sentmsg = "Gadget!\n";
    ok $clnt->send($sentmsg);
}
push @testvec, \&t_clnt_reply_strm;

# check return receipt
sub t_srvr_greeted_strm {
    my $gotmsg = $acpt->getline;
    ok $gotmsg, $sentmsg;
}
push @testvec, \&t_srvr_greeted_strm;

# check close statuses
sub t_close_both_strm {
    ok $acpt->close && $clnt->close;
}
push @testvec, \&t_close_both_strm;

# be sure we survive DESTROY
sub t_destroy_ok {
    $acpt = $srvr = $clnt = undef; # force the DESTROY call
    ok 1;
}
push @testvec, \&t_destroy_ok;

}	# end of BEGIN block for the test routines


# last test routine above this point


BEGIN {
    $| = 1;
# optional %Config::Config test here to skip the module
    unless ($Config::Config{i_sysun}) {
	print "1..0\n";
	exit 0;
    }
# Here's the boilerplate for calling plan().
    my (@todos, $i);
    for ($i = 0;  $i < @testvec;  $i++) {
	push @todos, $i		if exists $todos{$testvec[$i]};
    }
    plan tests => scalar @testvec, todo => \@todos;
}

# Any required `use' statements for the modules under test go here.

use Net::UNIX::Server;
use Net::UNIX;
use Net::Gen;

# Finally, run the driver.

tdriver;

exit 0;

