#! perl -w

######################### We start with some black magic to print on failure.

my $num_tests;
my $begin_tests;
my $testnum;
BEGIN {
    $begin_tests = 4;
    $num_tests = $begin_tests + 15; # for now
    $testnum = 0;
    #$Net::Gen::adebug = 1;
    $| = 1;
    print "1..$num_tests\n";
}
END {
    print "not ok $testnum # not reached\n" while $testnum++ < $begin_tests;
}

use Net::Gen;
BEGIN {
    $testnum++;
    print "ok $testnum #", Net::Gen::Version(), "\n";
}

use Net::TCP;
BEGIN {
    $testnum++;
    print "ok $testnum\n";
}
use Net::TCP::Server;
BEGIN {
    $testnum++;
    print "ok $testnum\n";
}
use Net::UDP;
BEGIN {
    $testnum++;
    print "ok $testnum\n";
}

######################### End of black magic.

# Note that all these tests exit if they fail.
# We're testing some rather basic capabilities here, and they should
# all succeed.

# Just get a socket.
$testnum++;
my $u = Net::UDP->new;
print "not " unless $u;
print "ok $testnum\n";
exit 1 unless $u;		# can't proceed if no UDP (no DNS even)

# Now set it up to be bound.
$testnum++;
exit 1 unless $u->setparams({thisport=>0});
print "ok $testnum\n";

# Try to do the bind.
$testnum++;
exit 1 unless $u->bind;
print "ok $testnum\n";

# Make sure we get the bound port back.
$testnum++;
my $port = $u->getparam('lclport');
exit 1 unless $port;
print "ok $testnum\n";

# Get a second socket, so we can try passing messages around.
$testnum++;
my $u2 = Net::UDP->new($port ? (0, $port) : ());
exit 1 unless $u2 && $u2->isconnected;
print "ok $testnum\n";

# If all is OK so far, try exchanging some simple messages.  Send one first.
$testnum++;
exit 1 unless $u2->send("ABCDEF");
print "ok $testnum\n";

# Try to be sure we won't block if we try to receive it.
$testnum++;
my $fhvec = $u->fhvec;
my $recok;
exit 1 unless $recok = select($fhvec, undef, undef, 1);
exit 1 unless $recok = $u->select(1, 0, 0, 1); # also test select method
print "ok $testnum\n";

# Now try to read it.
$testnum++;
my ($msg, $sender);
exit 1 unless
    $recok && ($msg = $u->recv(40, 0, $sender)) && $sender;
print "ok $testnum\n";

# Validate the sender information.
$testnum++;
my (@recaddr, $setport);
@recaddr = $u->_addrinfo($sender);
$setport = $u2->getparam('lclport');
exit 1 unless $setport == $recaddr[3];
print "ok $testnum\n";

# Validate the message.
$testnum++;
exit 1 unless $msg eq "ABCDEF";
print "ok $testnum\n";

# Now send one back, defaulting the reply address.
$testnum++;
exit 1 unless $u->send("GHIJK");
print "ok $testnum\n";

# Validate the receipt.
$testnum++;
exit 1 unless ($msg = $u2->recv(40, 0, $sender)) && $sender;
print "ok $testnum\n";

# Validate the addressing.
$testnum++;
@recaddr = $u2->_addrinfo($sender);
exit 1 unless $recaddr[3] == $port;
print "ok $testnum\n";

# Validate the contents
$testnum++;
exit 1 unless $msg eq "GHIJK";
print "ok $testnum\n";

# Validate the number of tests.
$testnum++;
print "not " unless $testnum == $num_tests;
print "ok $testnum\n";

exit 0;
