#!perl -w

use Test;
use Config ();

BEGIN {
    unless ($Config::Config{i_sysun}) {
	print "1..0\n";
	exit 0;
    }
    plan tests => 15;		# numtests
}

my @endav;
END { for my $endcv (@endav) { $endcv->() } }

use Net::UNIX::Server;
use Net::UNIX;
use Net::Gen;
use Socket 'SOCK_STREAM';

#1 - get a server socket to use
unlink 'srvr';
my $srv = Net::UNIX::Server->new('srvr');
my $srvok = $srv && $srv->isbound;
ok $srvok;
push(@endav, sub { unlink 'srvr'}) if $srvok;

#2 - get a client to talk to it
my $clnt = Net::UNIX->new('srvr');
my $clok = $clnt && $clnt->isconnected;
ok $clok;

exit 1 unless $srvok && $clok;

#3 - send a hello
my $sentmsg = "Wowsers!";
my $sendok = $clnt->send($sentmsg);
ok $sendok;

#4 - check receipt
my $gotmsg = $srv->recv(40);
ok $gotmsg, $sentmsg;

#5 - reply
$sentmsg = "Sorry, chief.";
$sendok = $srv->send($sentmsg);
ok !$sendok;

#6 - check close status
ok $srv->close && $clnt->close;

#7 - get a new server for stream sockets.
unlink 'srvr';
$srv = Net::UNIX::Server->new('srvr',{type => SOCK_STREAM});
$srvok = $srv && $srv->isbound && $srv->didlisten;
ok $srvok;

#8 - get a new client for stream sockets.
$clnt = Net::UNIX->new('srvr',{type => SOCK_STREAM});
$clok = $clnt && $clnt->isconnected;
ok $clok;

exit 1 unless $srvok && $clok;

#9 - accept the client connection (and drop the listener)
my $new = $srv->accept;
ok $new && $srv->close;

#10 - send a greeting
$sentmsg = "Wowsers!\n";	# a full line for checks below
$sendok = $new->send($sentmsg);
ok $sendok;

#11 - check receipt
$gotmsg = $clnt->getline;
ok $gotmsg, $sentmsg;

#12 - reply
$sentmsg = "Gadget!\n";
$sendok = $clnt->send($sentmsg);
ok $sendok;

#13 - check return receipt
$gotmsg = $new->getline;
ok $gotmsg, $sentmsg;

#14 - check close status
ok $new->close && $clnt->close;

#15 - be sure we survive DESTROY
$new = $srv = $clnt = undef;	# force the DESTROY call
ok 1;

exit 0;
