/*

# Copyright 1995,1996,1997 Spider Boardman.
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

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef I_FCNTL
#include <fcntl.h>
#endif
#ifdef I_SYS_FILE
#include <sys/file.h>
#endif

#ifndef VMS
# ifdef I_SYS_TYPES
#  include <sys/types.h>
# endif
#include <sys/socket.h>
#ifdef I_SYS_UN
#include <sys/un.h>
#endif
# ifdef I_NETINET_IN
#  include <netinet/in.h>
# endif
#include <netdb.h>
#else
#include "sockadapt.h"
#endif

#include <netinet/in_systm.h>
#include <netinet/ip.h>
#include <netinet/ip_icmp.h>
#include <netinet/ip_var.h>

#include <netinet/tcp.h>
#include <netinet/tcpip.h>

#ifdef __cplusplus
}
#endif

#ifndef	INADDR_UNSPEC_GROUP
#define	INADDR_UNSPEC_GROUP	(U32)0xe0000000	/* 224.0.0.0	*/
#endif
#ifndef	INADDR_ALLHOSTS_GROUP
#define	INADDR_ALLHOSTS_GROUP	(U32)0xe0000001	/* 224.0.0.1	*/
#endif
#ifndef	INADDR_MAX_LOCAL_GROUP
#define	INADDR_MAX_LOCAL_GROUP	(U32)0xe00000ff	/* 224.0.0.255	*/
#endif

static U32
constant(name)
char *name;
{
    errno = 0;
    switch (*name) {
    case 'I':
#ifndef ICMP_ADVLENMIN
	if (strEQ(name, "ICMP_ADVLENMIN"))
	    goto not_there;
#endif
#ifndef ICMP_ECHO
	if (strEQ(name, "ICMP_ECHO"))
	    goto not_there;
#endif
#ifndef ICMP_ECHOREPLY
	if (strEQ(name, "ICMP_ECHOREPLY"))
	    goto not_there;
#endif
#ifndef ICMP_IREQ
	if (strEQ(name, "ICMP_IREQ"))
	    goto not_there;
#endif
#ifndef ICMP_IREQREPLY
	if (strEQ(name, "ICMP_IREQREPLY"))
	    goto not_there;
#endif
#ifndef ICMP_MASKLEN
	if (strEQ(name, "ICMP_MASKLEN"))
	    goto not_there;
#endif
#ifndef ICMP_MASKREPLY
	if (strEQ(name, "ICMP_MASKREPLY"))
	    goto not_there;
#endif
#ifndef ICMP_MASKREQ
	if (strEQ(name, "ICMP_MASKREQ"))
	    goto not_there;
#endif
#ifndef ICMP_MAXTYPE
	if (strEQ(name, "ICMP_MAXTYPE"))
	    goto not_there;
#endif
#ifndef ICMP_MINLEN
	if (strEQ(name, "ICMP_MINLEN"))
	    goto not_there;
#endif
#ifndef ICMP_PARAMPROB
	if (strEQ(name, "ICMP_PARAMPROB"))
	    goto not_there;
#endif
#ifndef ICMP_REDIRECT
	if (strEQ(name, "ICMP_REDIRECT"))
	    goto not_there;
#endif
#ifndef ICMP_REDIRECT_HOST
	if (strEQ(name, "ICMP_REDIRECT_HOST"))
	    goto not_there;
#endif
#ifndef ICMP_REDIRECT_NET
	if (strEQ(name, "ICMP_REDIRECT_NET"))
	    goto not_there;
#endif
#ifndef ICMP_REDIRECT_TOSHOST
	if (strEQ(name, "ICMP_REDIRECT_TOSHOST"))
	    goto not_there;
#endif
#ifndef ICMP_REDIRECT_TOSNET
	if (strEQ(name, "ICMP_REDIRECT_TOSNET"))
	    goto not_there;
#endif
#ifndef ICMP_SOURCEQUENCH
	if (strEQ(name, "ICMP_SOURCEQUENCH"))
	    goto not_there;
#endif
#ifndef ICMP_TIMXCEED
	if (strEQ(name, "ICMP_TIMXCEED"))
	    goto not_there;
#endif
#ifndef ICMP_TIMXCEED_INTRANS
	if (strEQ(name, "ICMP_TIMXCEED_INTRANS"))
	    goto not_there;
#endif
#ifndef ICMP_TIMXCEED_REASS
	if (strEQ(name, "ICMP_TIMXCEED_REASS"))
	    goto not_there;
#endif
#ifndef ICMP_TSLEN
	if (strEQ(name, "ICMP_TSLEN"))
	    goto not_there;
#endif
#ifndef ICMP_TSTAMP
	if (strEQ(name, "ICMP_TSTAMP"))
	    goto not_there;
#endif
#ifndef ICMP_TSTAMPREPLY
	if (strEQ(name, "ICMP_TSTAMPREPLY"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH
	if (strEQ(name, "ICMP_UNREACH"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_HOST
	if (strEQ(name, "ICMP_UNREACH_HOST"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_NEEDFRAG
	if (strEQ(name, "ICMP_UNREACH_NEEDFRAG"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_NET
	if (strEQ(name, "ICMP_UNREACH_NET"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_PORT
	if (strEQ(name, "ICMP_UNREACH_PORT"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_PROTOCOL
	if (strEQ(name, "ICMP_UNREACH_PROTOCOL"))
	    goto not_there;
#endif
#ifndef ICMP_UNREACH_SRCFAIL
	if (strEQ(name, "ICMP_UNREACH_SRCFAIL"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_HOST
	if (strEQ(name, "IN_CLASSA_HOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_MAX
	if (strEQ(name, "IN_CLASSA_MAX"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_NET
	if (strEQ(name, "IN_CLASSA_NET"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_NSHIFT
	if (strEQ(name, "IN_CLASSA_NSHIFT"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_SUBHOST
	if (strEQ(name, "IN_CLASSA_SUBHOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_SUBNET
	if (strEQ(name, "IN_CLASSA_SUBNET"))
	    goto not_there;
#endif
#ifndef IN_CLASSA_SUBNSHIFT
	if (strEQ(name, "IN_CLASSA_SUBNSHIFT"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_HOST
	if (strEQ(name, "IN_CLASSB_HOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_MAX
	if (strEQ(name, "IN_CLASSB_MAX"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_NET
	if (strEQ(name, "IN_CLASSB_NET"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_NSHIFT
	if (strEQ(name, "IN_CLASSB_NSHIFT"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_SUBHOST
	if (strEQ(name, "IN_CLASSB_SUBHOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_SUBNET
	if (strEQ(name, "IN_CLASSB_SUBNET"))
	    goto not_there;
#endif
#ifndef IN_CLASSB_SUBNSHIFT
	if (strEQ(name, "IN_CLASSB_SUBNSHIFT"))
	    goto not_there;
#endif
#ifndef IN_CLASSC_HOST
	if (strEQ(name, "IN_CLASSC_HOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSC_MAX
	if (strEQ(name, "IN_CLASSC_MAX"))
	    goto not_there;
#endif
#ifndef IN_CLASSC_NET
	if (strEQ(name, "IN_CLASSC_NET"))
	    goto not_there;
#endif
#ifndef IN_CLASSC_NSHIFT
	if (strEQ(name, "IN_CLASSC_NSHIFT"))
	    goto not_there;
#endif
#ifndef IN_CLASSD_HOST
	if (strEQ(name, "IN_CLASSD_HOST"))
	    goto not_there;
#endif
#ifndef IN_CLASSD_NET
	if (strEQ(name, "IN_CLASSD_NET"))
	    goto not_there;
#endif
#ifndef IN_CLASSD_NSHIFT
	if (strEQ(name, "IN_CLASSD_NSHIFT"))
	    goto not_there;
#endif
#ifndef IN_LOOPBACKNET
	if (strEQ(name, "IN_LOOPBACKNET"))
	    goto not_there;
#endif
#ifndef IPFRAGTTL
	if (strEQ(name, "IPFRAGTTL"))
	    goto not_there;
#endif
#ifndef IPOPT_CONTROL
	if (strEQ(name, "IPOPT_CONTROL"))
	    goto not_there;
#endif
#ifndef IPOPT_DEBMEAS
	if (strEQ(name, "IPOPT_DEBMEAS"))
	    goto not_there;
#endif
#ifndef IPOPT_EOL
	if (strEQ(name, "IPOPT_EOL"))
	    goto not_there;
#endif
#ifndef IPOPT_LSRR
	if (strEQ(name, "IPOPT_LSRR"))
	    goto not_there;
#endif
#ifndef IPOPT_MINOFF
	if (strEQ(name, "IPOPT_MINOFF"))
	    goto not_there;
#endif
#ifndef IPOPT_NOP
	if (strEQ(name, "IPOPT_NOP"))
	    goto not_there;
#endif
#ifndef IPOPT_OFFSET
	if (strEQ(name, "IPOPT_OFFSET"))
	    goto not_there;
#endif
#ifndef IPOPT_OLEN
	if (strEQ(name, "IPOPT_OLEN"))
	    goto not_there;
#endif
#ifndef IPOPT_OPTVAL
	if (strEQ(name, "IPOPT_OPTVAL"))
	    goto not_there;
#endif
#ifndef IPOPT_RESERVED1
	if (strEQ(name, "IPOPT_RESERVED1"))
	    goto not_there;
#endif
#ifndef IPOPT_RESERVED2
	if (strEQ(name, "IPOPT_RESERVED2"))
	    goto not_there;
#endif
#ifndef IPOPT_RR
	if (strEQ(name, "IPOPT_RR"))
	    goto not_there;
#endif
#ifndef IPOPT_SATID
	if (strEQ(name, "IPOPT_SATID"))
	    goto not_there;
#endif
#ifndef IPOPT_SECURITY
	if (strEQ(name, "IPOPT_SECURITY"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_CONFID
	if (strEQ(name, "IPOPT_SECUR_CONFID"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_EFTO
	if (strEQ(name, "IPOPT_SECUR_EFTO"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_MMMM
	if (strEQ(name, "IPOPT_SECUR_MMMM"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_RESTR
	if (strEQ(name, "IPOPT_SECUR_RESTR"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_SECRET
	if (strEQ(name, "IPOPT_SECUR_SECRET"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_TOPSECRET
	if (strEQ(name, "IPOPT_SECUR_TOPSECRET"))
	    goto not_there;
#endif
#ifndef IPOPT_SECUR_UNCLASS
	if (strEQ(name, "IPOPT_SECUR_UNCLASS"))
	    goto not_there;
#endif
#ifndef IPOPT_SSRR
	if (strEQ(name, "IPOPT_SSRR"))
	    goto not_there;
#endif
#ifndef IPOPT_TS
	if (strEQ(name, "IPOPT_TS"))
	    goto not_there;
#endif
#ifndef IPOPT_TS_PRESPEC
	if (strEQ(name, "IPOPT_TS_PRESPEC"))
	    goto not_there;
#endif
#ifndef IPOPT_TS_TSANDADDR
	if (strEQ(name, "IPOPT_TS_TSANDADDR"))
	    goto not_there;
#endif
#ifndef IPOPT_TS_TSONLY
	if (strEQ(name, "IPOPT_TS_TSONLY"))
	    goto not_there;
#endif
#ifndef IPPORT_RESERVED
	if (strEQ(name, "IPPORT_RESERVED"))
	    goto not_there;
#endif
#ifndef IPPORT_TIMESERVER
	if (strEQ(name, "IPPORT_TIMESERVER"))
	    goto not_there;
#endif
#ifndef IPPORT_USERRESERVED
	if (strEQ(name, "IPPORT_USERRESERVED"))
	    goto not_there;
#endif
#ifndef IPPROTO_EGP
	if (strEQ(name, "IPPROTO_EGP"))
	    goto not_there;
#endif
#ifndef IPPROTO_EON
	if (strEQ(name, "IPPROTO_EON"))
	    goto not_there;
#endif
#ifndef IPPROTO_GGP
	if (strEQ(name, "IPPROTO_GGP"))
	    goto not_there;
#endif
#ifndef IPPROTO_HELLO
	if (strEQ(name, "IPPROTO_HELLO"))
	    goto not_there;
#endif
#ifndef IPPROTO_ICMP
	if (strEQ(name, "IPPROTO_ICMP"))
	    goto not_there;
#endif
#ifndef IPPROTO_IDP
	if (strEQ(name, "IPPROTO_IDP"))
	    goto not_there;
#endif
#ifndef IPPROTO_IGMP
	if (strEQ(name, "IPPROTO_IGMP"))
	    goto not_there;
#endif
#ifndef IPPROTO_IP
	if (strEQ(name, "IPPROTO_IP"))
	    goto not_there;
#endif
#ifndef IPPROTO_MAX
	if (strEQ(name, "IPPROTO_MAX"))
	    goto not_there;
#endif
#ifndef IPPROTO_PUP
	if (strEQ(name, "IPPROTO_PUP"))
	    goto not_there;
#endif
#ifndef IPPROTO_RAW
	if (strEQ(name, "IPPROTO_RAW"))
	    goto not_there;
#endif
#ifndef IPPROTO_TCP
	if (strEQ(name, "IPPROTO_TCP"))
	    goto not_there;
#endif
#ifndef IPPROTO_TP
	if (strEQ(name, "IPPROTO_TP"))
	    goto not_there;
#endif
#ifndef IPPROTO_UDP
	if (strEQ(name, "IPPROTO_UDP"))
	    goto not_there;
#endif
#ifndef IPTOS_LOWDELAY
	if (strEQ(name, "IPTOS_LOWDELAY"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_CRITIC_ECP
	if (strEQ(name, "IPTOS_PREC_CRITIC_ECP"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_FLASH
	if (strEQ(name, "IPTOS_PREC_FLASH"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_FLASHOVERRIDE
	if (strEQ(name, "IPTOS_PREC_FLASHOVERRIDE"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_IMMEDIATE
	if (strEQ(name, "IPTOS_PREC_IMMEDIATE"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_INTERNETCONTROL
	if (strEQ(name, "IPTOS_PREC_INTERNETCONTROL"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_NETCONTROL
	if (strEQ(name, "IPTOS_PREC_NETCONTROL"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_PRIORITY
	if (strEQ(name, "IPTOS_PREC_PRIORITY"))
	    goto not_there;
#endif
#ifndef IPTOS_PREC_ROUTINE
	if (strEQ(name, "IPTOS_PREC_ROUTINE"))
	    goto not_there;
#endif
#ifndef IPTOS_RELIABILITY
	if (strEQ(name, "IPTOS_RELIABILITY"))
	    goto not_there;
#endif
#ifndef IPTOS_THROUGHPUT
	if (strEQ(name, "IPTOS_THROUGHPUT"))
	    goto not_there;
#endif
#ifndef IPTTLDEC
	if (strEQ(name, "IPTTLDEC"))
	    goto not_there;
#endif
#ifndef IPVERSION
	if (strEQ(name, "IPVERSION"))
	    goto not_there;
#endif
#ifndef IP_ADD_MEMBERSHIP
	if (strEQ(name, "IP_ADD_MEMBERSHIP"))
	    goto not_there;
#endif
#ifndef IP_DEFAULT_MULTICAST_LOOP
	if (strEQ(name, "IP_DEFAULT_MULTICAST_LOOP"))
	    goto not_there;
#endif
#ifndef IP_DEFAULT_MULTICAST_TTL
	if (strEQ(name, "IP_DEFAULT_MULTICAST_TTL"))
	    goto not_there;
#endif
#ifndef IP_DF
	if (strEQ(name, "IP_DF"))
	    goto not_there;
#endif
#ifndef IP_DROP_MEMBERSHIP
	if (strEQ(name, "IP_DROP_MEMBERSHIP"))
	    goto not_there;
#endif
#ifndef IP_HDRINCL
	if (strEQ(name, "IP_HDRINCL"))
	    goto not_there;
#endif
#ifndef IP_MAXPACKET
	if (strEQ(name, "IP_MAXPACKET"))
	    goto not_there;
#endif
#ifndef IP_MAX_MEMBERSHIPS
	if (strEQ(name, "IP_MAX_MEMBERSHIPS"))
	    goto not_there;
#endif
#ifndef IP_MF
	if (strEQ(name, "IP_MF"))
	    goto not_there;
#endif
#ifndef IP_MSS
	if (strEQ(name, "IP_MSS"))
	    goto not_there;
#endif
#ifndef IP_MULTICAST_IF
	if (strEQ(name, "IP_MULTICAST_IF"))
	    goto not_there;
#endif
#ifndef IP_MULTICAST_LOOP
	if (strEQ(name, "IP_MULTICAST_LOOP"))
	    goto not_there;
#endif
#ifndef IP_MULTICAST_TTL
	if (strEQ(name, "IP_MULTICAST_TTL"))
	    goto not_there;
#endif
#ifndef IP_OPTIONS
	if (strEQ(name, "IP_OPTIONS"))
	    goto not_there;
#endif
#ifndef IP_RECVDSTADDR
	if (strEQ(name, "IP_RECVDSTADDR"))
	    goto not_there;
#endif
#ifndef IP_RECVOPTS
	if (strEQ(name, "IP_RECVOPTS"))
	    goto not_there;
#endif
#ifndef IP_RECVRETOPTS
	if (strEQ(name, "IP_RECVRETOPTS"))
	    goto not_there;
#endif
#ifndef IP_RETOPTS
	if (strEQ(name, "IP_RETOPTS"))
	    goto not_there;
#endif
#ifndef IP_TOS
	if (strEQ(name, "IP_TOS"))
	    goto not_there;
#endif
#ifndef IP_TTL
	if (strEQ(name, "IP_TTL"))
	    goto not_there;
#endif
	break;
    case 'M':
#ifndef MAXTTL
	if (strEQ(name, "MAXTTL"))
	    goto not_there;
#endif
	break;
    case 'R':
#ifndef RD_NODATA
	if (strEQ(name, "RD_NODATA"))
	    goto not_there;
#endif
	break;
    case 'S':
#ifndef SUBNETSHIFT
	if (strEQ(name, "SUBNETSHIFT"))
	    goto not_there;
#endif
	break;
    case 'T':
#ifndef TCPOPT_EOL
	if (strEQ(name, "TCPOPT_EOL"))
	    goto not_there;
#endif
#ifndef TCPOPT_MAXSEG
	if (strEQ(name, "TCPOPT_MAXSEG"))
	    goto not_there;
#endif
#ifndef TCPOPT_NOP
	if (strEQ(name, "TCPOPT_NOP"))
	    goto not_there;
#endif
#ifndef TCPOPT_WINDOW
	if (strEQ(name, "TCPOPT_WINDOW"))
	    goto not_there;
#endif
#ifndef TCP_MAXSEG
	if (strEQ(name, "TCP_MAXSEG"))
	    goto not_there;
#endif
#ifndef TCP_MAXWIN
	if (strEQ(name, "TCP_MAXWIN"))
	    goto not_there;
#endif
#ifndef TCP_MAX_WINSHIFT
	if (strEQ(name, "TCP_MAX_WINSHIFT"))
	    goto not_there;
#endif
#ifndef TCP_MSS
	if (strEQ(name, "TCP_MSS"))
	    goto not_there;
#endif
#ifndef TCP_NODELAY
	if (strEQ(name, "TCP_NODELAY"))
	    goto not_there;
#endif
#ifndef TCP_RPTR2RXT
	if (strEQ(name, "TCP_RPTR2RXT"))
	    goto not_there;
#endif
#ifndef TH_ACK
	if (strEQ(name, "TH_ACK"))
	    goto not_there;
#endif
#ifndef TH_FIN
	if (strEQ(name, "TH_FIN"))
	    goto not_there;
#endif
#ifndef TH_PUSH
	if (strEQ(name, "TH_PUSH"))
	    goto not_there;
#endif
#ifndef TH_RST
	if (strEQ(name, "TH_RST"))
	    goto not_there;
#endif
#ifndef TH_SYN
	if (strEQ(name, "TH_SYN"))
	    goto not_there;
#endif
#ifndef TH_URG
	if (strEQ(name, "TH_URG"))
	    goto not_there;
#endif
	break;
    case 'V':
#ifndef VAL_O_NONBLOCK
	if (strEQ(name, "VAL_O_NONBLOCK"))
	    goto not_there;
#endif
#ifndef VAL_EAGAIN
	if (strEQ(name, "VAL_EAGAIN"))
	    goto not_there;
#endif
	break;
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

MODULE = Net::Gen		PACKAGE = Net::TCP	PREFIX = f_ic_

PROTOTYPES: ENABLE

#ifdef TCPOPT_EOL
#define	f_ic_TCPOPT_EOL()	TCPOPT_EOL
U32
f_ic_TCPOPT_EOL()

#endif

#ifdef TCPOPT_MAXSEG
#define	f_ic_TCPOPT_MAXSEG()	TCPOPT_MAXSEG
U32
f_ic_TCPOPT_MAXSEG()

#endif

#ifdef TCPOPT_NOP
#define	f_ic_TCPOPT_NOP()	TCPOPT_NOP
U32
f_ic_TCPOPT_NOP()

#endif

#ifdef TCPOPT_WINDOW
#define	f_ic_TCPOPT_WINDOW()	TCPOPT_WINDOW
U32
f_ic_TCPOPT_WINDOW()

#endif

#ifdef TCP_MAXSEG
#define	f_ic_TCP_MAXSEG()	TCP_MAXSEG
U32
f_ic_TCP_MAXSEG()

#endif

#ifdef TCP_MAXWIN
#define	f_ic_TCP_MAXWIN()	TCP_MAXWIN
U32
f_ic_TCP_MAXWIN()

#endif

#ifdef TCP_MAX_WINSHIFT
#define	f_ic_TCP_MAX_WINSHIFT()	TCP_MAX_WINSHIFT
U32
f_ic_TCP_MAX_WINSHIFT()

#endif

#ifdef TCP_MSS
#define	f_ic_TCP_MSS()	TCP_MSS
U32
f_ic_TCP_MSS()

#endif

#ifdef TCP_NODELAY
#define	f_ic_TCP_NODELAY()	TCP_NODELAY
U32
f_ic_TCP_NODELAY()

#endif

#ifdef TCP_RPTR2RXT
#define	f_ic_TCP_RPTR2RXT()	TCP_RPTR2RXT
U32
f_ic_TCP_RPTR2RXT()

#endif

#ifdef TH_ACK
#define	f_ic_TH_ACK()	TH_ACK
U32
f_ic_TH_ACK()

#endif

#ifdef TH_FIN
#define	f_ic_TH_FIN()	TH_FIN
U32
f_ic_TH_FIN()

#endif

#ifdef TH_PUSH
#define	f_ic_TH_PUSH()	TH_PUSH
U32
f_ic_TH_PUSH()

#endif

#ifdef TH_RST
#define	f_ic_TH_RST()	TH_RST
U32
f_ic_TH_RST()

#endif

#ifdef TH_SYN
#define	f_ic_TH_SYN()	TH_SYN
U32
f_ic_TH_SYN()

#endif

#ifdef TH_URG
#define	f_ic_TH_URG()	TH_URG
U32
f_ic_TH_URG()

#endif


MODULE = Net::Gen		PACKAGE = Net::Inet	PREFIX = f_ic_

#ifdef ICMP_ADVLENMIN
#define	f_ic_ICMP_ADVLENMIN()	ICMP_ADVLENMIN
U32
f_ic_ICMP_ADVLENMIN()

#endif

#ifdef ICMP_ECHO
#define	f_ic_ICMP_ECHO()	ICMP_ECHO
U32
f_ic_ICMP_ECHO()

#endif

#ifdef ICMP_ECHOREPLY
#define	f_ic_ICMP_ECHOREPLY()	ICMP_ECHOREPLY
U32
f_ic_ICMP_ECHOREPLY()

#endif

#ifdef ICMP_IREQ
#define	f_ic_ICMP_IREQ()	ICMP_IREQ
U32
f_ic_ICMP_IREQ()

#endif

#ifdef ICMP_IREQREPLY
#define	f_ic_ICMP_IREQREPLY()	ICMP_IREQREPLY
U32
f_ic_ICMP_IREQREPLY()

#endif

#ifdef ICMP_MASKLEN
#define	f_ic_ICMP_MASKLEN()	ICMP_MASKLEN
U32
f_ic_ICMP_MASKLEN()

#endif

#ifdef ICMP_MASKREPLY
#define	f_ic_ICMP_MASKREPLY()	ICMP_MASKREPLY
U32
f_ic_ICMP_MASKREPLY()

#endif

#ifdef ICMP_MASKREQ
#define	f_ic_ICMP_MASKREQ()	ICMP_MASKREQ
U32
f_ic_ICMP_MASKREQ()

#endif

#ifdef ICMP_MAXTYPE
#define	f_ic_ICMP_MAXTYPE()	ICMP_MAXTYPE
U32
f_ic_ICMP_MAXTYPE()

#endif

#ifdef ICMP_MINLEN
#define	f_ic_ICMP_MINLEN()	ICMP_MINLEN
U32
f_ic_ICMP_MINLEN()

#endif

#ifdef ICMP_PARAMPROB
#define	f_ic_ICMP_PARAMPROB()	ICMP_PARAMPROB
U32
f_ic_ICMP_PARAMPROB()

#endif

#ifdef ICMP_REDIRECT
#define	f_ic_ICMP_REDIRECT()	ICMP_REDIRECT
U32
f_ic_ICMP_REDIRECT()

#endif

#ifdef ICMP_REDIRECT_HOST
#define	f_ic_ICMP_REDIRECT_HOST()	ICMP_REDIRECT_HOST
U32
f_ic_ICMP_REDIRECT_HOST()

#endif

#ifdef ICMP_REDIRECT_NET
#define	f_ic_ICMP_REDIRECT_NET()	ICMP_REDIRECT_NET
U32
f_ic_ICMP_REDIRECT_NET()

#endif

#ifdef ICMP_REDIRECT_TOSHOST
#define	f_ic_ICMP_REDIRECT_TOSHOST()	ICMP_REDIRECT_TOSHOST
U32
f_ic_ICMP_REDIRECT_TOSHOST()

#endif

#ifdef ICMP_REDIRECT_TOSNET
#define	f_ic_ICMP_REDIRECT_TOSNET()	ICMP_REDIRECT_TOSNET
U32
f_ic_ICMP_REDIRECT_TOSNET()

#endif

#ifdef ICMP_SOURCEQUENCH
#define	f_ic_ICMP_SOURCEQUENCH()	ICMP_SOURCEQUENCH
U32
f_ic_ICMP_SOURCEQUENCH()

#endif

#ifdef ICMP_TIMXCEED
#define	f_ic_ICMP_TIMXCEED()	ICMP_TIMXCEED
U32
f_ic_ICMP_TIMXCEED()

#endif

#ifdef ICMP_TIMXCEED_INTRANS
#define	f_ic_ICMP_TIMXCEED_INTRANS()	ICMP_TIMXCEED_INTRANS
U32
f_ic_ICMP_TIMXCEED_INTRANS()

#endif

#ifdef ICMP_TIMXCEED_REASS
#define	f_ic_ICMP_TIMXCEED_REASS()	ICMP_TIMXCEED_REASS
U32
f_ic_ICMP_TIMXCEED_REASS()

#endif

#ifdef ICMP_TSLEN
#define	f_ic_ICMP_TSLEN()	ICMP_TSLEN
U32
f_ic_ICMP_TSLEN()

#endif

#ifdef ICMP_TSTAMP
#define	f_ic_ICMP_TSTAMP()	ICMP_TSTAMP
U32
f_ic_ICMP_TSTAMP()

#endif

#ifdef ICMP_TSTAMPREPLY
#define	f_ic_ICMP_TSTAMPREPLY()	ICMP_TSTAMPREPLY
U32
f_ic_ICMP_TSTAMPREPLY()

#endif

#ifdef ICMP_UNREACH
#define	f_ic_ICMP_UNREACH()	ICMP_UNREACH
U32
f_ic_ICMP_UNREACH()

#endif

#ifdef ICMP_UNREACH_HOST
#define	f_ic_ICMP_UNREACH_HOST()	ICMP_UNREACH_HOST
U32
f_ic_ICMP_UNREACH_HOST()

#endif

#ifdef ICMP_UNREACH_NEEDFRAG
#define	f_ic_ICMP_UNREACH_NEEDFRAG()	ICMP_UNREACH_NEEDFRAG
U32
f_ic_ICMP_UNREACH_NEEDFRAG()

#endif

#ifdef ICMP_UNREACH_NET
#define	f_ic_ICMP_UNREACH_NET()	ICMP_UNREACH_NET
U32
f_ic_ICMP_UNREACH_NET()

#endif

#ifdef ICMP_UNREACH_PORT
#define	f_ic_ICMP_UNREACH_PORT()	ICMP_UNREACH_PORT
U32
f_ic_ICMP_UNREACH_PORT()

#endif

#ifdef ICMP_UNREACH_PROTOCOL
#define	f_ic_ICMP_UNREACH_PROTOCOL()	ICMP_UNREACH_PROTOCOL
U32
f_ic_ICMP_UNREACH_PROTOCOL()

#endif

#ifdef ICMP_UNREACH_SRCFAIL
#define	f_ic_ICMP_UNREACH_SRCFAIL()	ICMP_UNREACH_SRCFAIL
U32
f_ic_ICMP_UNREACH_SRCFAIL()

#endif

#ifdef IN_CLASSA_HOST
#define	f_ic_IN_CLASSA_HOST()	IN_CLASSA_HOST
U32
f_ic_IN_CLASSA_HOST()

#endif

#ifdef IN_CLASSA_MAX
#define	f_ic_IN_CLASSA_MAX()	IN_CLASSA_MAX
U32
f_ic_IN_CLASSA_MAX()

#endif

#ifdef IN_CLASSA_NET
#define	f_ic_IN_CLASSA_NET()	IN_CLASSA_NET
U32
f_ic_IN_CLASSA_NET()

#endif

#ifdef IN_CLASSA_NSHIFT
#define	f_ic_IN_CLASSA_NSHIFT()	IN_CLASSA_NSHIFT
U32
f_ic_IN_CLASSA_NSHIFT()

#endif

#ifdef IN_CLASSA_SUBHOST
#define	f_ic_IN_CLASSA_SUBHOST()	IN_CLASSA_SUBHOST
U32
f_ic_IN_CLASSA_SUBHOST()

#endif

#ifdef IN_CLASSA_SUBNET
#define	f_ic_IN_CLASSA_SUBNET()	IN_CLASSA_SUBNET
U32
f_ic_IN_CLASSA_SUBNET()

#endif

#ifdef IN_CLASSA_SUBNSHIFT
#define	f_ic_IN_CLASSA_SUBNSHIFT()	IN_CLASSA_SUBNSHIFT
U32
f_ic_IN_CLASSA_SUBNSHIFT()

#endif

#ifdef IN_CLASSB_HOST
#define	f_ic_IN_CLASSB_HOST()	IN_CLASSB_HOST
U32
f_ic_IN_CLASSB_HOST()

#endif

#ifdef IN_CLASSB_MAX
#define	f_ic_IN_CLASSB_MAX()	IN_CLASSB_MAX
U32
f_ic_IN_CLASSB_MAX()

#endif

#ifdef IN_CLASSB_NET
#define	f_ic_IN_CLASSB_NET()	IN_CLASSB_NET
U32
f_ic_IN_CLASSB_NET()

#endif

#ifdef IN_CLASSB_NSHIFT
#define	f_ic_IN_CLASSB_NSHIFT()	IN_CLASSB_NSHIFT
U32
f_ic_IN_CLASSB_NSHIFT()

#endif

#ifdef IN_CLASSB_SUBHOST
#define	f_ic_IN_CLASSB_SUBHOST()	IN_CLASSB_SUBHOST
U32
f_ic_IN_CLASSB_SUBHOST()

#endif

#ifdef IN_CLASSB_SUBNET
#define	f_ic_IN_CLASSB_SUBNET()	IN_CLASSB_SUBNET
U32
f_ic_IN_CLASSB_SUBNET()

#endif

#ifdef IN_CLASSB_SUBNSHIFT
#define	f_ic_IN_CLASSB_SUBNSHIFT()	IN_CLASSB_SUBNSHIFT
U32
f_ic_IN_CLASSB_SUBNSHIFT()

#endif

#ifdef IN_CLASSC_HOST
#define	f_ic_IN_CLASSC_HOST()	IN_CLASSC_HOST
U32
f_ic_IN_CLASSC_HOST()

#endif

#ifdef IN_CLASSC_MAX
#define	f_ic_IN_CLASSC_MAX()	IN_CLASSC_MAX
U32
f_ic_IN_CLASSC_MAX()

#endif

#ifdef IN_CLASSC_NET
#define	f_ic_IN_CLASSC_NET()	IN_CLASSC_NET
U32
f_ic_IN_CLASSC_NET()

#endif

#ifdef IN_CLASSC_NSHIFT
#define	f_ic_IN_CLASSC_NSHIFT()	IN_CLASSC_NSHIFT
U32
f_ic_IN_CLASSC_NSHIFT()

#endif

#ifdef IN_CLASSD_HOST
#define	f_ic_IN_CLASSD_HOST()	IN_CLASSD_HOST
U32
f_ic_IN_CLASSD_HOST()

#endif

#ifdef IN_CLASSD_NET
#define	f_ic_IN_CLASSD_NET()	IN_CLASSD_NET
U32
f_ic_IN_CLASSD_NET()

#endif

#ifdef IN_CLASSD_NSHIFT
#define	f_ic_IN_CLASSD_NSHIFT()	IN_CLASSD_NSHIFT
U32
f_ic_IN_CLASSD_NSHIFT()

#endif

#ifdef IN_LOOPBACKNET
#define	f_ic_IN_LOOPBACKNET()	IN_LOOPBACKNET
U32
f_ic_IN_LOOPBACKNET()

#endif

#ifdef IPFRAGTTL
#define	f_ic_IPFRAGTTL()	IPFRAGTTL
U32
f_ic_IPFRAGTTL()

#endif

#ifdef IPOPT_CONTROL
#define	f_ic_IPOPT_CONTROL()	IPOPT_CONTROL
U32
f_ic_IPOPT_CONTROL()

#endif

#ifdef IPOPT_DEBMEAS
#define	f_ic_IPOPT_DEBMEAS()	IPOPT_DEBMEAS
U32
f_ic_IPOPT_DEBMEAS()

#endif

#ifdef IPOPT_EOL
#define	f_ic_IPOPT_EOL()	IPOPT_EOL
U32
f_ic_IPOPT_EOL()

#endif

#ifdef IPOPT_LSRR
#define	f_ic_IPOPT_LSRR()	IPOPT_LSRR
U32
f_ic_IPOPT_LSRR()

#endif

#ifdef IPOPT_MINOFF
#define	f_ic_IPOPT_MINOFF()	IPOPT_MINOFF
U32
f_ic_IPOPT_MINOFF()

#endif

#ifdef IPOPT_NOP
#define	f_ic_IPOPT_NOP()	IPOPT_NOP
U32
f_ic_IPOPT_NOP()

#endif

#ifdef IPOPT_OFFSET
#define	f_ic_IPOPT_OFFSET()	IPOPT_OFFSET
U32
f_ic_IPOPT_OFFSET()

#endif

#ifdef IPOPT_OLEN
#define	f_ic_IPOPT_OLEN()	IPOPT_OLEN
U32
f_ic_IPOPT_OLEN()

#endif

#ifdef IPOPT_OPTVAL
#define	f_ic_IPOPT_OPTVAL()	IPOPT_OPTVAL
U32
f_ic_IPOPT_OPTVAL()

#endif

#ifdef IPOPT_RESERVED1
#define	f_ic_IPOPT_RESERVED1()	IPOPT_RESERVED1
U32
f_ic_IPOPT_RESERVED1()

#endif

#ifdef IPOPT_RESERVED2
#define	f_ic_IPOPT_RESERVED2()	IPOPT_RESERVED2
U32
f_ic_IPOPT_RESERVED2()

#endif

#ifdef IPOPT_RR
#define	f_ic_IPOPT_RR()	IPOPT_RR
U32
f_ic_IPOPT_RR()

#endif

#ifdef IPOPT_SATID
#define	f_ic_IPOPT_SATID()	IPOPT_SATID
U32
f_ic_IPOPT_SATID()

#endif

#ifdef IPOPT_SECURITY
#define	f_ic_IPOPT_SECURITY()	IPOPT_SECURITY
U32
f_ic_IPOPT_SECURITY()

#endif

#ifdef IPOPT_SECUR_CONFID
#define	f_ic_IPOPT_SECUR_CONFID()	IPOPT_SECUR_CONFID
U32
f_ic_IPOPT_SECUR_CONFID()

#endif

#ifdef IPOPT_SECUR_EFTO
#define	f_ic_IPOPT_SECUR_EFTO()	IPOPT_SECUR_EFTO
U32
f_ic_IPOPT_SECUR_EFTO()

#endif

#ifdef IPOPT_SECUR_MMMM
#define	f_ic_IPOPT_SECUR_MMMM()	IPOPT_SECUR_MMMM
U32
f_ic_IPOPT_SECUR_MMMM()

#endif

#ifdef IPOPT_SECUR_RESTR
#define	f_ic_IPOPT_SECUR_RESTR()	IPOPT_SECUR_RESTR
U32
f_ic_IPOPT_SECUR_RESTR()

#endif

#ifdef IPOPT_SECUR_SECRET
#define	f_ic_IPOPT_SECUR_SECRET()	IPOPT_SECUR_SECRET
U32
f_ic_IPOPT_SECUR_SECRET()

#endif

#ifdef IPOPT_SECUR_TOPSECRET
#define	f_ic_IPOPT_SECUR_TOPSECRET()	IPOPT_SECUR_TOPSECRET
U32
f_ic_IPOPT_SECUR_TOPSECRET()

#endif

#ifdef IPOPT_SECUR_UNCLASS
#define	f_ic_IPOPT_SECUR_UNCLASS()	IPOPT_SECUR_UNCLASS
U32
f_ic_IPOPT_SECUR_UNCLASS()

#endif

#ifdef IPOPT_SSRR
#define	f_ic_IPOPT_SSRR()	IPOPT_SSRR
U32
f_ic_IPOPT_SSRR()

#endif

#ifdef IPOPT_TS
#define	f_ic_IPOPT_TS()	IPOPT_TS
U32
f_ic_IPOPT_TS()

#endif

#ifdef IPOPT_TS_PRESPEC
#define	f_ic_IPOPT_TS_PRESPEC()	IPOPT_TS_PRESPEC
U32
f_ic_IPOPT_TS_PRESPEC()

#endif

#ifdef IPOPT_TS_TSANDADDR
#define	f_ic_IPOPT_TS_TSANDADDR()	IPOPT_TS_TSANDADDR
U32
f_ic_IPOPT_TS_TSANDADDR()

#endif

#ifdef IPOPT_TS_TSONLY
#define	f_ic_IPOPT_TS_TSONLY()	IPOPT_TS_TSONLY
U32
f_ic_IPOPT_TS_TSONLY()

#endif

#ifdef IPPORT_RESERVED
#define	f_ic_IPPORT_RESERVED()	IPPORT_RESERVED
U32
f_ic_IPPORT_RESERVED()

#endif

#ifdef IPPORT_TIMESERVER
#define	f_ic_IPPORT_TIMESERVER()	IPPORT_TIMESERVER
U32
f_ic_IPPORT_TIMESERVER()

#endif

#ifdef IPPORT_USERRESERVED
#define	f_ic_IPPORT_USERRESERVED()	IPPORT_USERRESERVED
U32
f_ic_IPPORT_USERRESERVED()

#endif

#ifdef IPPROTO_EGP
#define	f_ic_IPPROTO_EGP()	IPPROTO_EGP
U32
f_ic_IPPROTO_EGP()

#endif

#ifdef IPPROTO_EON
#define	f_ic_IPPROTO_EON()	IPPROTO_EON
U32
f_ic_IPPROTO_EON()

#endif

#ifdef IPPROTO_GGP
#define	f_ic_IPPROTO_GGP()	IPPROTO_GGP
U32
f_ic_IPPROTO_GGP()

#endif

#ifdef IPPROTO_HELLO
#define	f_ic_IPPROTO_HELLO()	IPPROTO_HELLO
U32
f_ic_IPPROTO_HELLO()

#endif

#ifdef IPPROTO_ICMP
#define	f_ic_IPPROTO_ICMP()	IPPROTO_ICMP
U32
f_ic_IPPROTO_ICMP()

#endif

#ifdef IPPROTO_IDP
#define	f_ic_IPPROTO_IDP()	IPPROTO_IDP
U32
f_ic_IPPROTO_IDP()

#endif

#ifdef IPPROTO_IGMP
#define	f_ic_IPPROTO_IGMP()	IPPROTO_IGMP
U32
f_ic_IPPROTO_IGMP()

#endif

#ifdef IPPROTO_IP
#define	f_ic_IPPROTO_IP()	IPPROTO_IP
U32
f_ic_IPPROTO_IP()

#endif

#ifdef IPPROTO_MAX
#define	f_ic_IPPROTO_MAX()	IPPROTO_MAX
U32
f_ic_IPPROTO_MAX()

#endif

#ifdef IPPROTO_PUP
#define	f_ic_IPPROTO_PUP()	IPPROTO_PUP
U32
f_ic_IPPROTO_PUP()

#endif

#ifdef IPPROTO_RAW
#define	f_ic_IPPROTO_RAW()	IPPROTO_RAW
U32
f_ic_IPPROTO_RAW()

#endif

#ifdef IPPROTO_TCP
#define	f_ic_IPPROTO_TCP()	IPPROTO_TCP
U32
f_ic_IPPROTO_TCP()

#endif

#ifdef IPPROTO_TP
#define	f_ic_IPPROTO_TP()	IPPROTO_TP
U32
f_ic_IPPROTO_TP()

#endif

#ifdef IPPROTO_UDP
#define	f_ic_IPPROTO_UDP()	IPPROTO_UDP
U32
f_ic_IPPROTO_UDP()

#endif

#ifdef IPTOS_LOWDELAY
#define	f_ic_IPTOS_LOWDELAY()	IPTOS_LOWDELAY
U32
f_ic_IPTOS_LOWDELAY()

#endif

#ifdef IPTOS_PREC_CRITIC_ECP
#define	f_ic_IPTOS_PREC_CRITIC_ECP()	IPTOS_PREC_CRITIC_ECP
U32
f_ic_IPTOS_PREC_CRITIC_ECP()

#endif

#ifdef IPTOS_PREC_FLASH
#define	f_ic_IPTOS_PREC_FLASH()	IPTOS_PREC_FLASH
U32
f_ic_IPTOS_PREC_FLASH()

#endif

#ifdef IPTOS_PREC_FLASHOVERRIDE
#define	f_ic_IPTOS_PREC_FLASHOVERRIDE()	IPTOS_PREC_FLASHOVERRIDE
U32
f_ic_IPTOS_PREC_FLASHOVERRIDE()

#endif

#ifdef IPTOS_PREC_IMMEDIATE
#define	f_ic_IPTOS_PREC_IMMEDIATE()	IPTOS_PREC_IMMEDIATE
U32
f_ic_IPTOS_PREC_IMMEDIATE()

#endif

#ifdef IPTOS_PREC_INTERNETCONTROL
#define	f_ic_IPTOS_PREC_INTERNETCONTROL()	IPTOS_PREC_INTERNETCONTROL
U32
f_ic_IPTOS_PREC_INTERNETCONTROL()

#endif

#ifdef IPTOS_PREC_NETCONTROL
#define	f_ic_IPTOS_PREC_NETCONTROL()	IPTOS_PREC_NETCONTROL
U32
f_ic_IPTOS_PREC_NETCONTROL()

#endif

#ifdef IPTOS_PREC_PRIORITY
#define	f_ic_IPTOS_PREC_PRIORITY()	IPTOS_PREC_PRIORITY
U32
f_ic_IPTOS_PREC_PRIORITY()

#endif

#ifdef IPTOS_PREC_ROUTINE
#define	f_ic_IPTOS_PREC_ROUTINE()	IPTOS_PREC_ROUTINE
U32
f_ic_IPTOS_PREC_ROUTINE()

#endif

#ifdef IPTOS_RELIABILITY
#define	f_ic_IPTOS_RELIABILITY()	IPTOS_RELIABILITY
U32
f_ic_IPTOS_RELIABILITY()

#endif

#ifdef IPTOS_THROUGHPUT
#define	f_ic_IPTOS_THROUGHPUT()	IPTOS_THROUGHPUT
U32
f_ic_IPTOS_THROUGHPUT()

#endif

#ifdef IPTTLDEC
#define	f_ic_IPTTLDEC()	IPTTLDEC
U32
f_ic_IPTTLDEC()

#endif

#ifdef IPVERSION
#define	f_ic_IPVERSION()	IPVERSION
U32
f_ic_IPVERSION()

#endif

#ifdef IP_ADD_MEMBERSHIP
#define	f_ic_IP_ADD_MEMBERSHIP()	IP_ADD_MEMBERSHIP
U32
f_ic_IP_ADD_MEMBERSHIP()

#endif

#ifdef IP_DEFAULT_MULTICAST_LOOP
#define	f_ic_IP_DEFAULT_MULTICAST_LOOP()	IP_DEFAULT_MULTICAST_LOOP
U32
f_ic_IP_DEFAULT_MULTICAST_LOOP()

#endif

#ifdef IP_DEFAULT_MULTICAST_TTL
#define	f_ic_IP_DEFAULT_MULTICAST_TTL()	IP_DEFAULT_MULTICAST_TTL
U32
f_ic_IP_DEFAULT_MULTICAST_TTL()

#endif

#ifdef IP_DF
#define	f_ic_IP_DF()	IP_DF
U32
f_ic_IP_DF()

#endif

#ifdef IP_DROP_MEMBERSHIP
#define	f_ic_IP_DROP_MEMBERSHIP()	IP_DROP_MEMBERSHIP
U32
f_ic_IP_DROP_MEMBERSHIP()

#endif

#ifdef IP_HDRINCL
#define	f_ic_IP_HDRINCL()	IP_HDRINCL
U32
f_ic_IP_HDRINCL()

#endif

#ifdef IP_MAXPACKET
#define	f_ic_IP_MAXPACKET()	IP_MAXPACKET
U32
f_ic_IP_MAXPACKET()

#endif

#ifdef IP_MAX_MEMBERSHIPS
#define	f_ic_IP_MAX_MEMBERSHIPS()	IP_MAX_MEMBERSHIPS
U32
f_ic_IP_MAX_MEMBERSHIPS()

#endif

#ifdef IP_MF
#define	f_ic_IP_MF()	IP_MF
U32
f_ic_IP_MF()

#endif

#ifdef IP_MSS
#define	f_ic_IP_MSS()	IP_MSS
U32
f_ic_IP_MSS()

#endif

#ifdef IP_MULTICAST_IF
#define	f_ic_IP_MULTICAST_IF()	IP_MULTICAST_IF
U32
f_ic_IP_MULTICAST_IF()

#endif

#ifdef IP_MULTICAST_LOOP
#define	f_ic_IP_MULTICAST_LOOP()	IP_MULTICAST_LOOP
U32
f_ic_IP_MULTICAST_LOOP()

#endif

#ifdef IP_MULTICAST_TTL
#define	f_ic_IP_MULTICAST_TTL()	IP_MULTICAST_TTL
U32
f_ic_IP_MULTICAST_TTL()

#endif

#ifdef IP_OPTIONS
#define	f_ic_IP_OPTIONS()	IP_OPTIONS
U32
f_ic_IP_OPTIONS()

#endif

#ifdef IP_RECVDSTADDR
#define	f_ic_IP_RECVDSTADDR()	IP_RECVDSTADDR
U32
f_ic_IP_RECVDSTADDR()

#endif

#ifdef IP_RECVOPTS
#define	f_ic_IP_RECVOPTS()	IP_RECVOPTS
U32
f_ic_IP_RECVOPTS()

#endif

#ifdef IP_RECVRETOPTS
#define	f_ic_IP_RECVRETOPTS()	IP_RECVRETOPTS
U32
f_ic_IP_RECVRETOPTS()

#endif

#ifdef IP_RETOPTS
#define	f_ic_IP_RETOPTS()	IP_RETOPTS
U32
f_ic_IP_RETOPTS()

#endif

#ifdef IP_TOS
#define	f_ic_IP_TOS()	IP_TOS
U32
f_ic_IP_TOS()

#endif

#ifdef IP_TTL
#define	f_ic_IP_TTL()	IP_TTL
U32
f_ic_IP_TTL()

#endif

#ifdef MAXTTL
#define	f_ic_MAXTTL()	MAXTTL
U32
f_ic_MAXTTL()

#endif

#ifdef SUBNETSHIFT
#define	f_ic_SUBNETSHIFT()	SUBNETSHIFT
U32
f_ic_SUBNETSHIFT()

#endif


MODULE = Net::Gen		PACKAGE = Net::Inet

void
INADDR_ALLHOSTS_GROUP()
	CODE:
	{
	struct in_addr	ip_address;
	ip_address.s_addr = htonl(INADDR_ALLHOSTS_GROUP);
	ST(0) = sv_2mortal(newSVpv((char*)&ip_address, sizeof ip_address));
	}

void
INADDR_MAX_LOCAL_GROUP()
	CODE:
	{
	struct in_addr	ip_address;
	ip_address.s_addr = htonl(INADDR_MAX_LOCAL_GROUP);
	ST(0) = sv_2mortal(newSVpv((char*)&ip_address, sizeof ip_address));
	}

void
INADDR_UNSPEC_GROUP()
	CODE:
	{
	struct in_addr	ip_address;
	ip_address.s_addr = htonl(INADDR_UNSPEC_GROUP);
	ST(0) = sv_2mortal(newSVpv((char*)&ip_address, sizeof ip_address));
	}


MODULE = Net::Gen		PACKAGE = Net::Gen

PROTOTYPES: ENABLE

U32
constant(name)
	char *	name

U32
EOF_NONBLOCK()
	CODE:
	{
#ifdef EOF_NONBLOCK
	RETVAL = 1;
#else
	RETVAL = 0;
#endif
	}
	OUTPUT:
	RETVAL

#ifdef RD_NODATA
U32
RD_NODATA()
	CODE:
	    RETVAL = RD_NODATA;
	OUTPUT:
	    RETVAL

#endif

#ifdef VAL_O_NONBLOCK
U32
VAL_O_NONBLOCK()
	CODE:
	    RETVAL = VAL_O_NONBLOCK;
	OUTPUT:
	    RETVAL

#endif

#ifdef VAL_EAGAIN
U32
VAL_EAGAIN()
	CODE:
	    RETVAL = VAL_EAGAIN;
	OUTPUT:
	    RETVAL

#endif

SV *
pack_sockaddr(family,address)
	U16	family
	SV *	address
	CODE:
	{
	    struct sockaddr sad;
	    char * adata;
	    STRLEN adlen;

	    Zero(&sad, sizeof sad, char);
	    sad.sa_family = family;
	    adata = SvPV(address, adlen);
	    if (adlen > sizeof(sad.sa_data)) {
		SV * rval = sv_newmortal();
		sv_setpvn(rval, (char*)&sad, sizeof sad - sizeof sad.sa_data);
		sv_catpvn(rval, adata, adlen);
		ST(0) = rval;
	    }
	    else {
		Copy(adata, &sad.sa_data, adlen, char);
		ST(0) = sv_2mortal(newSVpv((char*)&sad, sizeof sad));
	    }
	}

void
unpack_sockaddr(sad)
	SV *	sad
	PPCODE:
	{
	    char * cp;
	    STRLEN len;

	    if ((cp = SvPV(sad, len)) != (char*)0) {
		struct sockaddr sa;
		U16  family;
		SV * famsv;
		SV * datsv;

		if (len < sizeof sa - sizeof sa.sa_data)
		    Zero(&sa, sizeof sa - sizeof sa.sa_data, char);
		Copy(cp, &sa, len < sizeof sa ? len : sizeof sa, char);
		family = sa.sa_family;
		famsv = sv_2mortal(newSViv(family));
		if (len >= sizeof sa - sizeof sa.sa_data) {
		    len -= sizeof sa - sizeof sa.sa_data;
		    datsv = sv_2mortal(newSVpv(cp + sizeof sa - sizeof sa.sa_data, len));
		}
		else {
		    datsv = sv_mortalcopy(&sv_undef);
		}
		
		EXTEND(sp, 2);
		PUSHs(famsv);
		PUSHs(datsv);
	    }
	}

