/*

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

 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <netinet/in.h>
#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>

#ifndef	INADDR_NONE
#define	INADDR_NONE	0xffffffff
#endif
#ifndef	INADDR_BROADCAST
#define	INADDR_BROADCAST	0xffffffff
#endif
#ifndef	INADDR_LOOPBACK
#define	INADDR_LOOPBACK	0x7f000001
#endif
#ifndef	INADDR_ANY
#define	INADDR_ANY	0x00000000
#endif

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static U32
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    case 'A':
	break;
    case 'B':
	break;
    case 'C':
	break;
    case 'D':
	break;
    case 'E':
	break;
    case 'F':
	break;
    case 'G':
	break;
    case 'H':
	break;
    case 'I':
	if (strEQ(name, "ICMP_ADVLENMIN"))
#ifdef ICMP_ADVLENMIN
	    return ICMP_ADVLENMIN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_ECHO"))
#ifdef ICMP_ECHO
	    return ICMP_ECHO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_ECHOREPLY"))
#ifdef ICMP_ECHOREPLY
	    return ICMP_ECHOREPLY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_IREQ"))
#ifdef ICMP_IREQ
	    return ICMP_IREQ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_IREQREPLY"))
#ifdef ICMP_IREQREPLY
	    return ICMP_IREQREPLY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_MASKLEN"))
#ifdef ICMP_MASKLEN
	    return ICMP_MASKLEN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_MASKREPLY"))
#ifdef ICMP_MASKREPLY
	    return ICMP_MASKREPLY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_MASKREQ"))
#ifdef ICMP_MASKREQ
	    return ICMP_MASKREQ;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_MAXTYPE"))
#ifdef ICMP_MAXTYPE
	    return ICMP_MAXTYPE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_MINLEN"))
#ifdef ICMP_MINLEN
	    return ICMP_MINLEN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_PARAMPROB"))
#ifdef ICMP_PARAMPROB
	    return ICMP_PARAMPROB;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_REDIRECT"))
#ifdef ICMP_REDIRECT
	    return ICMP_REDIRECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_REDIRECT_HOST"))
#ifdef ICMP_REDIRECT_HOST
	    return ICMP_REDIRECT_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_REDIRECT_NET"))
#ifdef ICMP_REDIRECT_NET
	    return ICMP_REDIRECT_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_REDIRECT_TOSHOST"))
#ifdef ICMP_REDIRECT_TOSHOST
	    return ICMP_REDIRECT_TOSHOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_REDIRECT_TOSNET"))
#ifdef ICMP_REDIRECT_TOSNET
	    return ICMP_REDIRECT_TOSNET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_SOURCEQUENCH"))
#ifdef ICMP_SOURCEQUENCH
	    return ICMP_SOURCEQUENCH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TIMXCEED"))
#ifdef ICMP_TIMXCEED
	    return ICMP_TIMXCEED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TIMXCEED_INTRANS"))
#ifdef ICMP_TIMXCEED_INTRANS
	    return ICMP_TIMXCEED_INTRANS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TIMXCEED_REASS"))
#ifdef ICMP_TIMXCEED_REASS
	    return ICMP_TIMXCEED_REASS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TSLEN"))
#ifdef ICMP_TSLEN
	    return ICMP_TSLEN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TSTAMP"))
#ifdef ICMP_TSTAMP
	    return ICMP_TSTAMP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_TSTAMPREPLY"))
#ifdef ICMP_TSTAMPREPLY
	    return ICMP_TSTAMPREPLY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH"))
#ifdef ICMP_UNREACH
	    return ICMP_UNREACH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_HOST"))
#ifdef ICMP_UNREACH_HOST
	    return ICMP_UNREACH_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_NEEDFRAG"))
#ifdef ICMP_UNREACH_NEEDFRAG
	    return ICMP_UNREACH_NEEDFRAG;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_NET"))
#ifdef ICMP_UNREACH_NET
	    return ICMP_UNREACH_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_PORT"))
#ifdef ICMP_UNREACH_PORT
	    return ICMP_UNREACH_PORT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_PROTOCOL"))
#ifdef ICMP_UNREACH_PROTOCOL
	    return ICMP_UNREACH_PROTOCOL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ICMP_UNREACH_SRCFAIL"))
#ifdef ICMP_UNREACH_SRCFAIL
	    return ICMP_UNREACH_SRCFAIL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_ALLHOSTS_GROUP"))
#ifdef INADDR_ALLHOSTS_GROUP
	    return INADDR_ALLHOSTS_GROUP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_ANY"))
#ifdef INADDR_ANY
	    return INADDR_ANY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_BROADCAST"))
#ifdef INADDR_BROADCAST
	    return INADDR_BROADCAST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_LOOPBACK"))
#ifdef INADDR_LOOPBACK
	    return INADDR_LOOPBACK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_MAX_LOCAL_GROUP"))
#ifdef INADDR_MAX_LOCAL_GROUP
	    return INADDR_MAX_LOCAL_GROUP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_NONE"))
#ifdef INADDR_NONE
	    return INADDR_NONE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "INADDR_UNSPEC_GROUP"))
#ifdef INADDR_UNSPEC_GROUP
	    return INADDR_UNSPEC_GROUP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_HOST"))
#ifdef IN_CLASSA_HOST
	    return IN_CLASSA_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_MAX"))
#ifdef IN_CLASSA_MAX
	    return IN_CLASSA_MAX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_NET"))
#ifdef IN_CLASSA_NET
	    return IN_CLASSA_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_NSHIFT"))
#ifdef IN_CLASSA_NSHIFT
	    return IN_CLASSA_NSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_SUBHOST"))
#ifdef IN_CLASSA_SUBHOST
	    return IN_CLASSA_SUBHOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_SUBNET"))
#ifdef IN_CLASSA_SUBNET
	    return IN_CLASSA_SUBNET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSA_SUBNSHIFT"))
#ifdef IN_CLASSA_SUBNSHIFT
	    return IN_CLASSA_SUBNSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_HOST"))
#ifdef IN_CLASSB_HOST
	    return IN_CLASSB_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_MAX"))
#ifdef IN_CLASSB_MAX
	    return IN_CLASSB_MAX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_NET"))
#ifdef IN_CLASSB_NET
	    return IN_CLASSB_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_NSHIFT"))
#ifdef IN_CLASSB_NSHIFT
	    return IN_CLASSB_NSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_SUBHOST"))
#ifdef IN_CLASSB_SUBHOST
	    return IN_CLASSB_SUBHOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_SUBNET"))
#ifdef IN_CLASSB_SUBNET
	    return IN_CLASSB_SUBNET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSB_SUBNSHIFT"))
#ifdef IN_CLASSB_SUBNSHIFT
	    return IN_CLASSB_SUBNSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSC_HOST"))
#ifdef IN_CLASSC_HOST
	    return IN_CLASSC_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSC_MAX"))
#ifdef IN_CLASSC_MAX
	    return IN_CLASSC_MAX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSC_NET"))
#ifdef IN_CLASSC_NET
	    return IN_CLASSC_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSC_NSHIFT"))
#ifdef IN_CLASSC_NSHIFT
	    return IN_CLASSC_NSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSD_HOST"))
#ifdef IN_CLASSD_HOST
	    return IN_CLASSD_HOST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSD_NET"))
#ifdef IN_CLASSD_NET
	    return IN_CLASSD_NET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_CLASSD_NSHIFT"))
#ifdef IN_CLASSD_NSHIFT
	    return IN_CLASSD_NSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IN_LOOPBACKNET"))
#ifdef IN_LOOPBACKNET
	    return IN_LOOPBACKNET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPFRAGTTL"))
#ifdef IPFRAGTTL
	    return IPFRAGTTL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_CONTROL"))
#ifdef IPOPT_CONTROL
	    return IPOPT_CONTROL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_DEBMEAS"))
#ifdef IPOPT_DEBMEAS
	    return IPOPT_DEBMEAS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_EOL"))
#ifdef IPOPT_EOL
	    return IPOPT_EOL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_LSRR"))
#ifdef IPOPT_LSRR
	    return IPOPT_LSRR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_MINOFF"))
#ifdef IPOPT_MINOFF
	    return IPOPT_MINOFF;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_NOP"))
#ifdef IPOPT_NOP
	    return IPOPT_NOP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_OFFSET"))
#ifdef IPOPT_OFFSET
	    return IPOPT_OFFSET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_OLEN"))
#ifdef IPOPT_OLEN
	    return IPOPT_OLEN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_OPTVAL"))
#ifdef IPOPT_OPTVAL
	    return IPOPT_OPTVAL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_RESERVED1"))
#ifdef IPOPT_RESERVED1
	    return IPOPT_RESERVED1;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_RESERVED2"))
#ifdef IPOPT_RESERVED2
	    return IPOPT_RESERVED2;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_RR"))
#ifdef IPOPT_RR
	    return IPOPT_RR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SATID"))
#ifdef IPOPT_SATID
	    return IPOPT_SATID;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECURITY"))
#ifdef IPOPT_SECURITY
	    return IPOPT_SECURITY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_CONFID"))
#ifdef IPOPT_SECUR_CONFID
	    return IPOPT_SECUR_CONFID;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_EFTO"))
#ifdef IPOPT_SECUR_EFTO
	    return IPOPT_SECUR_EFTO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_MMMM"))
#ifdef IPOPT_SECUR_MMMM
	    return IPOPT_SECUR_MMMM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_RESTR"))
#ifdef IPOPT_SECUR_RESTR
	    return IPOPT_SECUR_RESTR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_SECRET"))
#ifdef IPOPT_SECUR_SECRET
	    return IPOPT_SECUR_SECRET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_TOPSECRET"))
#ifdef IPOPT_SECUR_TOPSECRET
	    return IPOPT_SECUR_TOPSECRET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SECUR_UNCLASS"))
#ifdef IPOPT_SECUR_UNCLASS
	    return IPOPT_SECUR_UNCLASS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_SSRR"))
#ifdef IPOPT_SSRR
	    return IPOPT_SSRR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_TS"))
#ifdef IPOPT_TS
	    return IPOPT_TS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_TS_PRESPEC"))
#ifdef IPOPT_TS_PRESPEC
	    return IPOPT_TS_PRESPEC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_TS_TSANDADDR"))
#ifdef IPOPT_TS_TSANDADDR
	    return IPOPT_TS_TSANDADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPOPT_TS_TSONLY"))
#ifdef IPOPT_TS_TSONLY
	    return IPOPT_TS_TSONLY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPORT_RESERVED"))
#ifdef IPPORT_RESERVED
	    return IPPORT_RESERVED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPORT_TIMESERVER"))
#ifdef IPPORT_TIMESERVER
	    return IPPORT_TIMESERVER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPORT_USERRESERVED"))
#ifdef IPPORT_USERRESERVED
	    return IPPORT_USERRESERVED;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_EGP"))
#ifdef IPPROTO_EGP
	    return IPPROTO_EGP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_EON"))
#ifdef IPPROTO_EON
	    return IPPROTO_EON;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_GGP"))
#ifdef IPPROTO_GGP
	    return IPPROTO_GGP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_HELLO"))
#ifdef IPPROTO_HELLO
	    return IPPROTO_HELLO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_ICMP"))
#ifdef IPPROTO_ICMP
	    return IPPROTO_ICMP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_IDP"))
#ifdef IPPROTO_IDP
	    return IPPROTO_IDP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_IGMP"))
#ifdef IPPROTO_IGMP
	    return IPPROTO_IGMP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_IP"))
#ifdef IPPROTO_IP
	    return IPPROTO_IP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_MAX"))
#ifdef IPPROTO_MAX
	    return IPPROTO_MAX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_PUP"))
#ifdef IPPROTO_PUP
	    return IPPROTO_PUP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_RAW"))
#ifdef IPPROTO_RAW
	    return IPPROTO_RAW;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_TCP"))
#ifdef IPPROTO_TCP
	    return IPPROTO_TCP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_TP"))
#ifdef IPPROTO_TP
	    return IPPROTO_TP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPPROTO_UDP"))
#ifdef IPPROTO_UDP
	    return IPPROTO_UDP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_LOWDELAY"))
#ifdef IPTOS_LOWDELAY
	    return IPTOS_LOWDELAY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_CRITIC_ECP"))
#ifdef IPTOS_PREC_CRITIC_ECP
	    return IPTOS_PREC_CRITIC_ECP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_FLASH"))
#ifdef IPTOS_PREC_FLASH
	    return IPTOS_PREC_FLASH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_FLASHOVERRIDE"))
#ifdef IPTOS_PREC_FLASHOVERRIDE
	    return IPTOS_PREC_FLASHOVERRIDE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_IMMEDIATE"))
#ifdef IPTOS_PREC_IMMEDIATE
	    return IPTOS_PREC_IMMEDIATE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_INTERNETCONTROL"))
#ifdef IPTOS_PREC_INTERNETCONTROL
	    return IPTOS_PREC_INTERNETCONTROL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_NETCONTROL"))
#ifdef IPTOS_PREC_NETCONTROL
	    return IPTOS_PREC_NETCONTROL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_PRIORITY"))
#ifdef IPTOS_PREC_PRIORITY
	    return IPTOS_PREC_PRIORITY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_PREC_ROUTINE"))
#ifdef IPTOS_PREC_ROUTINE
	    return IPTOS_PREC_ROUTINE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_RELIABILITY"))
#ifdef IPTOS_RELIABILITY
	    return IPTOS_RELIABILITY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTOS_THROUGHPUT"))
#ifdef IPTOS_THROUGHPUT
	    return IPTOS_THROUGHPUT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPTTLDEC"))
#ifdef IPTTLDEC
	    return IPTTLDEC;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IPVERSION"))
#ifdef IPVERSION
	    return IPVERSION;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_ADD_MEMBERSHIP"))
#ifdef IP_ADD_MEMBERSHIP
	    return IP_ADD_MEMBERSHIP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_DEFAULT_MULTICAST_LOOP"))
#ifdef IP_DEFAULT_MULTICAST_LOOP
	    return IP_DEFAULT_MULTICAST_LOOP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_DEFAULT_MULTICAST_TTL"))
#ifdef IP_DEFAULT_MULTICAST_TTL
	    return IP_DEFAULT_MULTICAST_TTL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_DF"))
#ifdef IP_DF
	    return IP_DF;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_DROP_MEMBERSHIP"))
#ifdef IP_DROP_MEMBERSHIP
	    return IP_DROP_MEMBERSHIP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_HDRINCL"))
#ifdef IP_HDRINCL
	    return IP_HDRINCL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MAXPACKET"))
#ifdef IP_MAXPACKET
	    return IP_MAXPACKET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MAX_MEMBERSHIPS"))
#ifdef IP_MAX_MEMBERSHIPS
	    return IP_MAX_MEMBERSHIPS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MF"))
#ifdef IP_MF
	    return IP_MF;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MSS"))
#ifdef IP_MSS
	    return IP_MSS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MULTICAST_IF"))
#ifdef IP_MULTICAST_IF
	    return IP_MULTICAST_IF;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MULTICAST_LOOP"))
#ifdef IP_MULTICAST_LOOP
	    return IP_MULTICAST_LOOP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_MULTICAST_TTL"))
#ifdef IP_MULTICAST_TTL
	    return IP_MULTICAST_TTL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_OPTIONS"))
#ifdef IP_OPTIONS
	    return IP_OPTIONS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_RECVDSTADDR"))
#ifdef IP_RECVDSTADDR
	    return IP_RECVDSTADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_RECVOPTS"))
#ifdef IP_RECVOPTS
	    return IP_RECVOPTS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_RECVRETOPTS"))
#ifdef IP_RECVRETOPTS
	    return IP_RECVRETOPTS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_RETOPTS"))
#ifdef IP_RETOPTS
	    return IP_RETOPTS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_TOS"))
#ifdef IP_TOS
	    return IP_TOS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "IP_TTL"))
#ifdef IP_TTL
	    return IP_TTL;
#else
	    goto not_there;
#endif
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
	break;
    case 'M':
	if (strEQ(name, "MAXTTL"))
#ifdef MAXTTL
	    return MAXTTL;
#else
	    goto not_there;
#endif
	break;
    case 'N':
	break;
    case 'O':
	break;
    case 'P':
	break;
    case 'Q':
	break;
    case 'R':
	break;
    case 'S':
	if (strEQ(name, "SUBNETSHIFT"))
#ifdef SUBNETSHIFT
	    return SUBNETSHIFT;
#else
	    goto not_there;
#endif
	break;
    case 'T':
	break;
    case 'U':
	break;
    case 'V':
	break;
    case 'W':
	break;
    case 'X':
	break;
    case 'Y':
	break;
    case 'Z':
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


MODULE = Net::Inet		PACKAGE = Net::Inet

U32
constant(name,arg)
	char *		name
	int		arg

void
_pack_sockaddr_in(family,port,ip_address)
	unsigned short	family
	unsigned short	port
	SV *		ip_address
	CODE:
	{
	    struct sockaddr_in sin;
	    char * s;
	    STRLEN len;
	    register STRLEN siz;

	    Zero(&sin, sizeof sin, char);
	    sin.sin_family = family;
	    sin.sin_port = htons(port);
	    s = SvPV(ip_address, len);
	    siz = (len < sizeof(sin.sin_addr)) ? len : sizeof(sin.sin_addr);
	    Copy(s, &sin.sin_addr, siz, char);
	    ST(0) = sv_2mortal(newSVpv((char*)&sin, sizeof sin));
	}

void
unpack_sockaddr_in(sin)
	SV *	sin
	PPCODE:
	{
	    struct sockaddr_in addr;
	    unsigned short family;
	    unsigned short port;
	    struct in_addr ip_address;
	    char * s;
	    STRLEN len;
	    register STRLEN siz;

	    Zero(&addr, sizeof addr, char);
	    s = SvPV(sin, len);
	    siz = (len < sizeof addr) ? len : sizeof addr;
	    Copy(s, &addr, siz, char);
	    family = addr.sin_family;
	    port = ntohs(addr.sin_port);
	    ip_address = addr.sin_addr;

	    EXTEND(sp, 3);
	    PUSHs(sv_2mortal(newSViv(family)));
	    PUSHs(sv_2mortal(newSViv(port)));
	    PUSHs(sv_2mortal(newSVpv((char*)&ip_address, sizeof ip_address)));
	}

