#! perl -w
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

my $loaded;
BEGIN { $| = 1; print "1..3\n"; $Net::Gen::adebug = 1; $loaded=0;}
END {
    print "not ok 1\n" unless $loaded;
    print "not ok 2\n" unless $loaded > 1;
    print "not ok 3\n" unless $loaded > 2;
}
use Net::TCP;
BEGIN {
$loaded = 1;
print "ok 1\n";
}
use Net::UDP;
BEGIN {
$loaded = 2;
print "ok 2\n";
}
use Net::UNIX;
BEGIN {
$loaded = 3;
print "ok 3\n";
}

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

