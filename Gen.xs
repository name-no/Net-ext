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

#if defined(sun) || defined(__sun__) || defined(__sun)
#ifndef MIN
#include <netinet/common.h>
#endif
#endif

#ifdef __cplusplus
}
#endif

/* Just in case still don't have MIN and we need it for TCP_MSS.... */
#ifndef MIN
#define	MIN(_A,_B)	(((_A)<(_B))?(_A):(_B))
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
	switch (name[1]) {
	  case 'C':
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
	    break;
	  case 'N':
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
	    break;
	  case 'P':
	    switch(name[2]) {
	      case 'F':
#ifndef IPFRAGTTL
		if (strEQ(name, "IPFRAGTTL"))
		    goto not_there;
#endif
		break;
	      case 'O':
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
		break;
	      case 'P':
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
		break;
	      case 'T':
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
		break;
	      case 'V':
#ifndef IPVERSION
		if (strEQ(name, "IPVERSION"))
		    goto not_there;
#endif
		break;
	      case '_':
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
	    }
	    break;
	}
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
	switch (name[1]) {
	  case 'C':
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
	    break;
	  case 'H':
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
	}
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

XS(cv_constant)
{
    dXSARGS;
    if (items != 0) {
	ST(0) = sv_newmortal();
	gv_efullname3(ST(0), CvGV(cv), Nullch);
	croak("Usage: %s()", SvPVX(ST(0)));
    }
    if (CvSTART(cv)) {
	ST(0) = ((SVOP*)CvSTART(cv))->op_sv;
	XSRETURN(1);
    }
    XSRETURN_UNDEF;
}

void
newXSconst(name, valsv, file)
char * name;
SV * valsv;
char * file;
{
    CV *cv;
    OP *svop;
    cv = newXS(name, cv_constant, file);
    sv_setpvn((SV*)cv, "", 0);		/* prototype it as () */
    if (SvTEMP(valsv))			/* Don't let mortality get you down. */
	SvREFCNT_inc(valsv);		/* Give it an afterlife.  :-> */
    svop = newSVOP(OP_CONST, 0, valsv);	/* does SvREADONLY_on */
    svop->op_next = Nullop;		/* terminate search in cv_const_sv() */
    CvSTART(cv) = svop;			/* voila!  we're a constant! */
}

void
newXSconstPV(name, string, file)
char *name;
char *string;
char *file;
{
    SV *valsv = newSVpv(string, strlen(string));
    newXSconst(name, valsv, file);
}

void
newXSconstPVN(name, string, len, file)
char *name;
char *string;
STRLEN len;
char *file;
{
    SV *valsv = newSVpv(string, len);
    newXSconst(name, valsv, file);
}

void
newXSconstIV(name, ival, file)
char *name;
IV ival;
char *file;
{
    newXSconst(name, newSViv(ival), file);
}

void
newXSconstUV(name, uval, file)
char *	name;
UV	uval;
char *	file;
{
    SV * valsv = newSVsv(&sv_undef);		/* missing newSVuv()! */
    sv_setuv(valsv, uval);
    newXSconst(name, valsv, file);
}

void
newXSconstNV(name, nval, file)
char *	name;
double	nval;
char *	file;
{
    newXSconst(name, newSVnv(nval), file);
}


MODULE = Net::Gen		PACKAGE = Net::TCP	PREFIX = f_ic_

PROTOTYPES: ENABLE

#ifdef TCPOPT_EOL
BOOT:
	newXSconstUV("Net::TCP::TCPOPT_EOL", TCPOPT_EOL, file);

#endif

#ifdef TCPOPT_MAXSEG
BOOT:
	newXSconstUV("Net::TCP::TCPOPT_MAXSEG", TCPOPT_MAXSEG, file);

#endif

#ifdef TCPOPT_NOP
BOOT:
	newXSconstUV("Net::TCP::TCPOPT_NOP", TCPOPT_NOP, file);

#endif

#ifdef TCPOPT_WINDOW
BOOT:
	newXSconstUV("Net::TCP::TCPOPT_WINDOW", TCPOPT_WINDOW, file);

#endif

#ifdef TCP_MAXSEG
BOOT:
	newXSconstUV("Net::TCP::TCP_MAXSEG", TCP_MAXSEG, file);

#endif

#ifdef TCP_MAXWIN
BOOT:
	newXSconstUV("Net::TCP::TCP_MAXWIN", TCP_MAXWIN, file);

#endif

#ifdef TCP_MAX_WINSHIFT
BOOT:
	newXSconstUV("Net::TCP::TCP_MAX_WINSHIFT", TCP_MAX_WINSHIFT, file);

#endif

#ifdef TCP_MSS
BOOT:
	newXSconstUV("Net::TCP::TCP_MSS", TCP_MSS, file);

#endif

#ifdef TCP_NODELAY
BOOT:
	newXSconstUV("Net::TCP::TCP_NODELAY", TCP_NODELAY, file);

#endif

#ifdef TCP_RPTR2RXT
BOOT:
	newXSconstUV("Net::TCP::TCP_RPTR2RXT", TCP_RPTR2RXT, file);

#endif

#ifdef TH_ACK
BOOT:
	newXSconstUV("Net::TCP::TH_ACK", TH_ACK, file);

#endif

#ifdef TH_FIN
BOOT:
	newXSconstUV("Net::TCP::TH_FIN", TH_FIN, file);

#endif

#ifdef TH_PUSH
BOOT:
	newXSconstUV("Net::TCP::TH_PUSH", TH_PUSH, file);

#endif

#ifdef TH_RST
BOOT:
	newXSconstUV("Net::TCP::TH_RST", TH_RST, file);

#endif

#ifdef TH_SYN
BOOT:
	newXSconstUV("Net::TCP::TH_SYN", TH_SYN, file);

#endif

#ifdef TH_URG
BOOT:
	newXSconstUV("Net::TCP::TH_URG", TH_URG, file);

#endif


MODULE = Net::Gen		PACKAGE = Net::Inet	PREFIX = f_ic_

#ifdef ICMP_ADVLENMIN
BOOT:
	newXSconstUV("Net::Inet::ICMP_ADVLENMIN", ICMP_ADVLENMIN, file);

#endif

#ifdef ICMP_ECHO
BOOT:
	newXSconstUV("Net::Inet::ICMP_ECHO", ICMP_ECHO, file);

#endif

#ifdef ICMP_ECHOREPLY
BOOT:
	newXSconstUV("Net::Inet::ICMP_ECHOREPLY", ICMP_ECHOREPLY, file);

#endif

#ifdef ICMP_IREQ
BOOT:
	newXSconstUV("Net::Inet::ICMP_IREQ", ICMP_IREQ, file);

#endif

#ifdef ICMP_IREQREPLY
BOOT:
	newXSconstUV("Net::Inet::ICMP_IREQREPLY", ICMP_IREQREPLY, file);

#endif

#ifdef ICMP_MASKLEN
BOOT:
	newXSconstUV("Net::Inet::ICMP_MASKLEN", ICMP_MASKLEN, file);

#endif

#ifdef ICMP_MASKREPLY
BOOT:
	newXSconstUV("Net::Inet::ICMP_MASKREPLY", ICMP_MASKREPLY, file);

#endif

#ifdef ICMP_MASKREQ
BOOT:
	newXSconstUV("Net::Inet::ICMP_MASKREQ", ICMP_MASKREQ, file);

#endif

#ifdef ICMP_MAXTYPE
BOOT:
	newXSconstUV("Net::Inet::ICMP_MAXTYPE", ICMP_MAXTYPE, file);

#endif

#ifdef ICMP_MINLEN
BOOT:
	newXSconstUV("Net::Inet::ICMP_MINLEN", ICMP_MINLEN, file);

#endif

#ifdef ICMP_PARAMPROB
BOOT:
	newXSconstUV("Net::Inet::ICMP_PARAMPROB", ICMP_PARAMPROB, file);

#endif

#ifdef ICMP_REDIRECT
BOOT:
	newXSconstUV("Net::Inet::ICMP_REDIRECT", ICMP_REDIRECT, file);

#endif

#ifdef ICMP_REDIRECT_HOST
BOOT:
	newXSconstUV("Net::Inet::ICMP_REDIRECT_HOST", ICMP_REDIRECT_HOST, file);

#endif

#ifdef ICMP_REDIRECT_NET
BOOT:
	newXSconstUV("Net::Inet::ICMP_REDIRECT_NET", ICMP_REDIRECT_NET, file);

#endif

#ifdef ICMP_REDIRECT_TOSHOST
BOOT:
	newXSconstUV("Net::Inet::ICMP_REDIRECT_TOSHOST", ICMP_REDIRECT_TOSHOST, file);

#endif

#ifdef ICMP_REDIRECT_TOSNET
BOOT:
	newXSconstUV("Net::Inet::ICMP_REDIRECT_TOSNET", ICMP_REDIRECT_TOSNET, file);

#endif

#ifdef ICMP_SOURCEQUENCH
BOOT:
	newXSconstUV("Net::Inet::ICMP_SOURCEQUENCH", ICMP_SOURCEQUENCH, file);

#endif

#ifdef ICMP_TIMXCEED
BOOT:
	newXSconstUV("Net::Inet::ICMP_TIMXCEED", ICMP_TIMXCEED, file);

#endif

#ifdef ICMP_TIMXCEED_INTRANS
BOOT:
	newXSconstUV("Net::Inet::ICMP_TIMXCEED_INTRANS", ICMP_TIMXCEED_INTRANS, file);

#endif

#ifdef ICMP_TIMXCEED_REASS
BOOT:
	newXSconstUV("Net::Inet::ICMP_TIMXCEED_REASS", ICMP_TIMXCEED_REASS, file);

#endif

#ifdef ICMP_TSLEN
BOOT:
	newXSconstUV("Net::Inet::ICMP_TSLEN", ICMP_TSLEN, file);

#endif

#ifdef ICMP_TSTAMP
BOOT:
	newXSconstUV("Net::Inet::ICMP_TSTAMP", ICMP_TSTAMP, file);

#endif

#ifdef ICMP_TSTAMPREPLY
BOOT:
	newXSconstUV("Net::Inet::ICMP_TSTAMPREPLY", ICMP_TSTAMPREPLY, file);

#endif

#ifdef ICMP_UNREACH
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH", ICMP_UNREACH, file);

#endif

#ifdef ICMP_UNREACH_HOST
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_HOST", ICMP_UNREACH_HOST, file);

#endif

#ifdef ICMP_UNREACH_NEEDFRAG
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_NEEDFRAG", ICMP_UNREACH_NEEDFRAG, file);

#endif

#ifdef ICMP_UNREACH_NET
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_NET", ICMP_UNREACH_NET, file);

#endif

#ifdef ICMP_UNREACH_PORT
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_PORT", ICMP_UNREACH_PORT, file);

#endif

#ifdef ICMP_UNREACH_PROTOCOL
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_PROTOCOL", ICMP_UNREACH_PROTOCOL, file);

#endif

#ifdef ICMP_UNREACH_SRCFAIL
BOOT:
	newXSconstUV("Net::Inet::ICMP_UNREACH_SRCFAIL", ICMP_UNREACH_SRCFAIL, file);

#endif

#ifdef IN_CLASSA_HOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_HOST", IN_CLASSA_HOST, file);

#endif

#ifdef IN_CLASSA_MAX
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_MAX", IN_CLASSA_MAX, file);

#endif

#ifdef IN_CLASSA_NET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_NET", IN_CLASSA_NET, file);

#endif

#ifdef IN_CLASSA_NSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_NSHIFT", IN_CLASSA_NSHIFT, file);

#endif

#ifdef IN_CLASSA_SUBHOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_SUBHOST", IN_CLASSA_SUBHOST, file);

#endif

#ifdef IN_CLASSA_SUBNET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_SUBNET", IN_CLASSA_SUBNET, file);

#endif

#ifdef IN_CLASSA_SUBNSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSA_SUBNSHIFT", IN_CLASSA_SUBNSHIFT, file);

#endif

#ifdef IN_CLASSB_HOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_HOST", IN_CLASSB_HOST, file);

#endif

#ifdef IN_CLASSB_MAX
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_MAX", IN_CLASSB_MAX, file);

#endif

#ifdef IN_CLASSB_NET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_NET", IN_CLASSB_NET, file);

#endif

#ifdef IN_CLASSB_NSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_NSHIFT", IN_CLASSB_NSHIFT, file);

#endif

#ifdef IN_CLASSB_SUBHOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_SUBHOST", IN_CLASSB_SUBHOST, file);

#endif

#ifdef IN_CLASSB_SUBNET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_SUBNET", IN_CLASSB_SUBNET, file);

#endif

#ifdef IN_CLASSB_SUBNSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSB_SUBNSHIFT", IN_CLASSB_SUBNSHIFT, file);

#endif

#ifdef IN_CLASSC_HOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSC_HOST", IN_CLASSC_HOST, file);

#endif

#ifdef IN_CLASSC_MAX
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSC_MAX", IN_CLASSC_MAX, file);

#endif

#ifdef IN_CLASSC_NET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSC_NET", IN_CLASSC_NET, file);

#endif

#ifdef IN_CLASSC_NSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSC_NSHIFT", IN_CLASSC_NSHIFT, file);

#endif

#ifdef IN_CLASSD_HOST
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSD_HOST", IN_CLASSD_HOST, file);

#endif

#ifdef IN_CLASSD_NET
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSD_NET", IN_CLASSD_NET, file);

#endif

#ifdef IN_CLASSD_NSHIFT
BOOT:
	newXSconstUV("Net::Inet::IN_CLASSD_NSHIFT", IN_CLASSD_NSHIFT, file);

#endif

#ifdef IN_LOOPBACKNET
BOOT:
	newXSconstUV("Net::Inet::IN_LOOPBACKNET", IN_LOOPBACKNET, file);

#endif

#ifdef IPFRAGTTL
BOOT:
	newXSconstUV("Net::Inet::IPFRAGTTL", IPFRAGTTL, file);

#endif

#ifdef IPOPT_CONTROL
BOOT:
	newXSconstUV("Net::Inet::IPOPT_CONTROL", IPOPT_CONTROL, file);

#endif

#ifdef IPOPT_DEBMEAS
BOOT:
	newXSconstUV("Net::Inet::IPOPT_DEBMEAS", IPOPT_DEBMEAS, file);

#endif

#ifdef IPOPT_EOL
BOOT:
	newXSconstUV("Net::Inet::IPOPT_EOL", IPOPT_EOL, file);

#endif

#ifdef IPOPT_LSRR
BOOT:
	newXSconstUV("Net::Inet::IPOPT_LSRR", IPOPT_LSRR, file);

#endif

#ifdef IPOPT_MINOFF
BOOT:
	newXSconstUV("Net::Inet::IPOPT_MINOFF", IPOPT_MINOFF, file);

#endif

#ifdef IPOPT_NOP
BOOT:
	newXSconstUV("Net::Inet::IPOPT_NOP", IPOPT_NOP, file);

#endif

#ifdef IPOPT_OFFSET
BOOT:
	newXSconstUV("Net::Inet::IPOPT_OFFSET", IPOPT_OFFSET, file);

#endif

#ifdef IPOPT_OLEN
BOOT:
	newXSconstUV("Net::Inet::IPOPT_OLEN", IPOPT_OLEN, file);

#endif

#ifdef IPOPT_OPTVAL
BOOT:
	newXSconstUV("Net::Inet::IPOPT_OPTVAL", IPOPT_OPTVAL, file);

#endif

#ifdef IPOPT_RESERVED1
BOOT:
	newXSconstUV("Net::Inet::IPOPT_RESERVED1", IPOPT_RESERVED1, file);

#endif

#ifdef IPOPT_RESERVED2
BOOT:
	newXSconstUV("Net::Inet::IPOPT_RESERVED2", IPOPT_RESERVED2, file);

#endif

#ifdef IPOPT_RR
BOOT:
	newXSconstUV("Net::Inet::IPOPT_RR", IPOPT_RR, file);

#endif

#ifdef IPOPT_SATID
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SATID", IPOPT_SATID, file);

#endif

#ifdef IPOPT_SECURITY
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECURITY", IPOPT_SECURITY, file);

#endif

#ifdef IPOPT_SECUR_CONFID
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_CONFID", IPOPT_SECUR_CONFID, file);

#endif

#ifdef IPOPT_SECUR_EFTO
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_EFTO", IPOPT_SECUR_EFTO, file);

#endif

#ifdef IPOPT_SECUR_MMMM
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_MMMM", IPOPT_SECUR_MMMM, file);

#endif

#ifdef IPOPT_SECUR_RESTR
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_RESTR", IPOPT_SECUR_RESTR, file);

#endif

#ifdef IPOPT_SECUR_SECRET
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_SECRET", IPOPT_SECUR_SECRET, file);

#endif

#ifdef IPOPT_SECUR_TOPSECRET
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_TOPSECRET", IPOPT_SECUR_TOPSECRET, file);

#endif

#ifdef IPOPT_SECUR_UNCLASS
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SECUR_UNCLASS", IPOPT_SECUR_UNCLASS, file);

#endif

#ifdef IPOPT_SSRR
BOOT:
	newXSconstUV("Net::Inet::IPOPT_SSRR", IPOPT_SSRR, file);

#endif

#ifdef IPOPT_TS
BOOT:
	newXSconstUV("Net::Inet::IPOPT_TS", IPOPT_TS, file);

#endif

#ifdef IPOPT_TS_PRESPEC
BOOT:
	newXSconstUV("Net::Inet::IPOPT_TS_PRESPEC", IPOPT_TS_PRESPEC, file);

#endif

#ifdef IPOPT_TS_TSANDADDR
BOOT:
	newXSconstUV("Net::Inet::IPOPT_TS_TSANDADDR", IPOPT_TS_TSANDADDR, file);

#endif

#ifdef IPOPT_TS_TSONLY
BOOT:
	newXSconstUV("Net::Inet::IPOPT_TS_TSONLY", IPOPT_TS_TSONLY, file);

#endif

#ifdef IPPORT_RESERVED
BOOT:
	newXSconstUV("Net::Inet::IPPORT_RESERVED", IPPORT_RESERVED, file);

#endif

#ifdef IPPORT_TIMESERVER
BOOT:
	newXSconstUV("Net::Inet::IPPORT_TIMESERVER", IPPORT_TIMESERVER, file);

#endif

#ifdef IPPORT_USERRESERVED
BOOT:
	newXSconstUV("Net::Inet::IPPORT_USERRESERVED", IPPORT_USERRESERVED, file);

#endif

#ifdef IPPROTO_EGP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_EGP", IPPROTO_EGP, file);

#endif

#ifdef IPPROTO_EON
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_EON", IPPROTO_EON, file);

#endif

#ifdef IPPROTO_GGP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_GGP", IPPROTO_GGP, file);

#endif

#ifdef IPPROTO_HELLO
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_HELLO", IPPROTO_HELLO, file);

#endif

#ifdef IPPROTO_ICMP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_ICMP", IPPROTO_ICMP, file);

#endif

#ifdef IPPROTO_IDP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_IDP", IPPROTO_IDP, file);

#endif

#ifdef IPPROTO_IGMP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_IGMP", IPPROTO_IGMP, file);

#endif

#ifdef IPPROTO_IP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_IP", IPPROTO_IP, file);

#endif

#ifdef IPPROTO_MAX
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_MAX", IPPROTO_MAX, file);

#endif

#ifdef IPPROTO_PUP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_PUP", IPPROTO_PUP, file);

#endif

#ifdef IPPROTO_RAW
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_RAW", IPPROTO_RAW, file);

#endif

#ifdef IPPROTO_TCP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_TCP", IPPROTO_TCP, file);

#endif

#ifdef IPPROTO_TP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_TP", IPPROTO_TP, file);

#endif

#ifdef IPPROTO_UDP
BOOT:
	newXSconstUV("Net::Inet::IPPROTO_UDP", IPPROTO_UDP, file);

#endif

#ifdef IPTOS_LOWDELAY
BOOT:
	newXSconstUV("Net::Inet::IPTOS_LOWDELAY", IPTOS_LOWDELAY, file);

#endif

#ifdef IPTOS_PREC_CRITIC_ECP
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_CRITIC_ECP", IPTOS_PREC_CRITIC_ECP, file);

#endif

#ifdef IPTOS_PREC_FLASH
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_FLASH", IPTOS_PREC_FLASH, file);

#endif

#ifdef IPTOS_PREC_FLASHOVERRIDE
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_FLASHOVERRIDE", IPTOS_PREC_FLASHOVERRIDE, file);

#endif

#ifdef IPTOS_PREC_IMMEDIATE
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_IMMEDIATE", IPTOS_PREC_IMMEDIATE, file);

#endif

#ifdef IPTOS_PREC_INTERNETCONTROL
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_INTERNETCONTROL", IPTOS_PREC_INTERNETCONTROL, file);

#endif

#ifdef IPTOS_PREC_NETCONTROL
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_NETCONTROL", IPTOS_PREC_NETCONTROL, file);

#endif

#ifdef IPTOS_PREC_PRIORITY
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_PRIORITY", IPTOS_PREC_PRIORITY, file);

#endif

#ifdef IPTOS_PREC_ROUTINE
BOOT:
	newXSconstUV("Net::Inet::IPTOS_PREC_ROUTINE", IPTOS_PREC_ROUTINE, file);

#endif

#ifdef IPTOS_RELIABILITY
BOOT:
	newXSconstUV("Net::Inet::IPTOS_RELIABILITY", IPTOS_RELIABILITY, file);

#endif

#ifdef IPTOS_THROUGHPUT
BOOT:
	newXSconstUV("Net::Inet::IPTOS_THROUGHPUT", IPTOS_THROUGHPUT, file);

#endif

#ifdef IPTTLDEC
BOOT:
	newXSconstUV("Net::Inet::IPTTLDEC", IPTTLDEC, file);

#endif

#ifdef IPVERSION
BOOT:
	newXSconstUV("Net::Inet::IPVERSION", IPVERSION, file);

#endif

#ifdef IP_ADD_MEMBERSHIP
BOOT:
	newXSconstUV("Net::Inet::IP_ADD_MEMBERSHIP", IP_ADD_MEMBERSHIP, file);

#endif

#ifdef IP_DEFAULT_MULTICAST_LOOP
BOOT:
	newXSconstUV("Net::Inet::IP_DEFAULT_MULTICAST_LOOP", IP_DEFAULT_MULTICAST_LOOP, file);

#endif

#ifdef IP_DEFAULT_MULTICAST_TTL
BOOT:
	newXSconstUV("Net::Inet::IP_DEFAULT_MULTICAST_TTL", IP_DEFAULT_MULTICAST_TTL, file);

#endif

#ifdef IP_DF
BOOT:
	newXSconstUV("Net::Inet::IP_DF", IP_DF, file);

#endif

#ifdef IP_DROP_MEMBERSHIP
BOOT:
	newXSconstUV("Net::Inet::IP_DROP_MEMBERSHIP", IP_DROP_MEMBERSHIP, file);

#endif

#ifdef IP_HDRINCL
BOOT:
	newXSconstUV("Net::Inet::IP_HDRINCL", IP_HDRINCL, file);

#endif

#ifdef IP_MAXPACKET
BOOT:
	newXSconstUV("Net::Inet::IP_MAXPACKET", IP_MAXPACKET, file);

#endif

#ifdef IP_MAX_MEMBERSHIPS
BOOT:
	newXSconstUV("Net::Inet::IP_MAX_MEMBERSHIPS", IP_MAX_MEMBERSHIPS, file);

#endif

#ifdef IP_MF
BOOT:
	newXSconstUV("Net::Inet::IP_MF", IP_MF, file);

#endif

#ifdef IP_MSS
BOOT:
	newXSconstUV("Net::Inet::IP_MSS", IP_MSS, file);

#endif

#ifdef IP_MULTICAST_IF
BOOT:
	newXSconstUV("Net::Inet::IP_MULTICAST_IF", IP_MULTICAST_IF, file);

#endif

#ifdef IP_MULTICAST_LOOP
BOOT:
	newXSconstUV("Net::Inet::IP_MULTICAST_LOOP", IP_MULTICAST_LOOP, file);

#endif

#ifdef IP_MULTICAST_TTL
BOOT:
	newXSconstUV("Net::Inet::IP_MULTICAST_TTL", IP_MULTICAST_TTL, file);

#endif

#ifdef IP_OPTIONS
BOOT:
	newXSconstUV("Net::Inet::IP_OPTIONS", IP_OPTIONS, file);

#endif

#ifdef IP_RECVDSTADDR
BOOT:
	newXSconstUV("Net::Inet::IP_RECVDSTADDR", IP_RECVDSTADDR, file);

#endif

#ifdef IP_RECVOPTS
BOOT:
	newXSconstUV("Net::Inet::IP_RECVOPTS", IP_RECVOPTS, file);

#endif

#ifdef IP_RECVRETOPTS
BOOT:
	newXSconstUV("Net::Inet::IP_RECVRETOPTS", IP_RECVRETOPTS, file);

#endif

#ifdef IP_RETOPTS
BOOT:
	newXSconstUV("Net::Inet::IP_RETOPTS", IP_RETOPTS, file);

#endif

#ifdef IP_TOS
BOOT:
	newXSconstUV("Net::Inet::IP_TOS", IP_TOS, file);

#endif

#ifdef IP_TTL
BOOT:
	newXSconstUV("Net::Inet::IP_TTL", IP_TTL, file);

#endif

#ifdef MAXTTL
BOOT:
	newXSconstUV("Net::Inet::MAXTTL", MAXTTL, file);

#endif

#ifdef SUBNETSHIFT
BOOT:
	newXSconstUV("Net::Inet::SUBNETSHIFT", SUBNETSHIFT, file);

#endif

BOOT:
    {
	struct in_addr ina;
	ina.s_addr = htonl(INADDR_ALLHOSTS_GROUP);
	newXSconstPVN("Net::Inet::INADDR_ALLHOSTS_GROUP",
		      (char*)&ina, sizeof ina, file);
	ina.s_addr = htonl(INADDR_MAX_LOCAL_GROUP);
	newXSconstPVN("Net::Inet::INADDR_MAX_LOCAL_GROUP",
		      (char*)&ina, sizeof ina, file);
	ina.s_addr = htonl(INADDR_UNSPEC_GROUP);
	newXSconstPVN("Net::Inet::INADDR_UNSPEC_GROUP",
		      (char*)&ina, sizeof ina, file);
    }


MODULE = Net::Gen		PACKAGE = Net::Gen	PREFIX = f_ic_

#ifdef	EOF_NONBLOCK
#define	f_ic_EOF_NONBLOCK	1
#else
#define	f_ic_EOF_NONBLOCK	0
#endif
BOOT:
	newXSconstIV("Net::Gen::EOF_NONBLOCK", f_ic_EOF_NONBLOCK, file);

#ifdef	RD_NODATA
BOOT:
	newXSconstIV("Net::Gen::RD_NODATA", RD_NODATA, file);

#endif

#ifdef	VAL_O_NONBLOCK
BOOT:
	newXSconstUV("Net::Gen::VAL_O_NONBLOCK", VAL_O_NONBLOCK, file);

#endif

#ifdef	VAL_EAGAIN
BOOT:
	newXSconstUV("Net::Gen::VAL_EAGAIN", VAL_EAGAIN, file);

#endif


MODULE = Net::Gen		PACKAGE = Net::Gen

U32
constant(name)
	char *	name

SV *
pack_sockaddr(family,address)
	U8	family
	SV *	address
    PREINIT:
	struct sockaddr sad;
	char * adata;
	STRLEN adlen;
    CODE:
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

void
unpack_sockaddr(sad)
	SV *	sad
    PREINIT:
	char * cp;
	STRLEN len;
    PPCODE:
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
		datsv = sv_2mortal(newSVpv(cp + sizeof sa - sizeof sa.sa_data,
					   len));
	    }
	    else {
		datsv = sv_mortalcopy(&sv_undef);
	    }
	    EXTEND(sp, 2);
	    PUSHs(famsv);
	    PUSHs(datsv);
	}

