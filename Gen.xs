/*

# Copyright 1995,1996,1997,1998 Spider Boardman.
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


#include "netgen.h"

#ifdef __cplusplus
}
#endif

/* Just in case still don't have MIN and we need it for TCP_MSS.... */
#ifndef MIN
#define	MIN(_A,_B)	(((_A)<(_B))?(_A):(_B))
#endif

/* Default EAGAIN and EWOULDBLOCK from each other, punting to 0 if neither
 * is available.
 */
#ifndef	EAGAIN
#ifndef	EWOULDBLOCK
#define	EWOULDBLOCK	0
#endif
#define	EAGAIN		EWOULDBLOCK
#endif
#ifndef	EWOULDBLOCK
#define	EWOULDBLOCK	EAGAIN
#endif

static U32
constant(name)
char *name;
{
    errno = 0;
    switch (*name) {
      case 'I':
	switch (name[1]) {
	  case 'N':
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
	    break;
	  case 'P':
	    switch(name[2]) {
	      case 'F':
#ifndef IPFRAGTTL
		if (strEQ(name, "IPFRAGTTL"))
		    goto not_there;
#endif
		break;
	      case 'P':
#ifndef IPPORT_TIMESERVER
		if (strEQ(name, "IPPORT_TIMESERVER"))
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
#ifndef IP_DROP_MEMBERSHIP
		if (strEQ(name, "IP_DROP_MEMBERSHIP"))
		    goto not_there;
#endif
#ifndef IP_HDRINCL
		if (strEQ(name, "IP_HDRINCL"))
		    goto not_there;
#endif
#ifndef IP_MAX_MEMBERSHIPS
		if (strEQ(name, "IP_MAX_MEMBERSHIPS"))
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
#ifndef TCP_MAXSEG
	if (strEQ(name, "TCP_MAXSEG"))
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

/*
 * cv_constant() exists so that the constant XSUBs will return their
 * proper values even when not inlined.
 */

static
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

/*
 * Create a new 'constant' XSUB, suitable for inlining as a constant.
 * Depends on the behaviour of cv_const_sv().
 */

static void
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

/*
 * Auxiliary routines to create constant XSUBs of various types.
 */

static void
newXSconstPV(name, string, file)
char *name;
char *string;
char *file;
{
    SV *valsv = newSVpv(string, strlen(string));
    newXSconst(name, valsv, file);
}

static void
newXSconstPVN(name, string, len, file)
char *name;
char *string;
STRLEN len;
char *file;
{
    SV *valsv = newSVpv(string, len);
    newXSconst(name, valsv, file);
}

static void
newXSconstIV(name, ival, file)
char *name;
IV ival;
char *file;
{
    newXSconst(name, newSViv(ival), file);
}

static void
newXSconstUV(name, uval, file)
char *	name;
UV	uval;
char *	file;
{
    SV * valsv = newSVsv(&sv_undef);		/* missing newSVuv()! */
    sv_setuv(valsv, uval);
    newXSconst(name, valsv, file);
}

static void
newXSconstNV(name, nval, file)
char *	name;
double	nval;
char *	file;
{
    newXSconst(name, newSVnv(nval), file);
}


typedef U32 sv_inaddr_t;
/*
 * typemap helper for T_INADDR inputs
 */

static sv_inaddr_t
sv2inaddr(sv)
SV *sv;
{
    struct in_addr ina;
    char *cp;
    STRLEN len;
    if (!sv)
	return 0;
    if (SvGMAGICAL(sv)) {
	mg_get(sv);
	if (SvIOKp(sv))
	    return (sv_inaddr_t)SvUVX(sv);
	if (SvNOKp(sv))
	    return (sv_inaddr_t)U_V(SvNVX(sv));
	if (!SvPOKp(sv) || SvCUR(sv) != sizeof ina)
	    return (sv_inaddr_t)sv_2uv(sv);
    }
    else if (SvROK(sv))
	return (sv_inaddr_t)sv_2uv(sv);
    else if (SvNIOK(sv)) {
	if (SvIOK(sv))
	    return (sv_inaddr_t)SvUVX(sv);
	return (sv_inaddr_t)U_V(SvNVX(sv));
    }
    else if (!SvPOK(sv) || SvCUR(sv) != sizeof ina)
	return (sv_inaddr_t)sv_2uv(sv);
    /* Here for apparent inaddr's, perhaps from unpack_sockaddr_in(). */
    cp = SvPV(sv,len);
    Copy(cp, (char*)&ina, len, char);
    return (sv_inaddr_t)ntohl(ina.s_addr);
}


/*
 * In the XS sections which follow, the sections with f_?c_ prefixes
 * are generated from the list of exportable constants.
 */

MODULE = Net::Gen		PACKAGE = Net::Gen

PROTOTYPES: ENABLE


MODULE = Net::Gen		PACKAGE = Net::TCP	PREFIX = f_uc_

BOOT:
	newXSconstUV("Net::TCP::TCPOPT_EOL", TCPOPT_EOL, file);
	newXSconstUV("Net::TCP::TCPOPT_MAXSEG", TCPOPT_MAXSEG, file);
	newXSconstUV("Net::TCP::TCPOPT_NOP", TCPOPT_NOP, file);
	newXSconstUV("Net::TCP::TCPOPT_WINDOW", TCPOPT_WINDOW, file);
#ifdef TCP_MAXSEG
	newXSconstUV("Net::TCP::TCP_MAXSEG", TCP_MAXSEG, file);
#endif
	newXSconstUV("Net::TCP::TCP_MAXWIN", TCP_MAXWIN, file);
	newXSconstUV("Net::TCP::TCP_MAX_WINSHIFT", TCP_MAX_WINSHIFT, file);
	newXSconstUV("Net::TCP::TCP_MSS", TCP_MSS, file);
#ifdef TCP_NODELAY
	newXSconstUV("Net::TCP::TCP_NODELAY", TCP_NODELAY, file);
#endif
#ifdef TCP_RPTR2RXT
	newXSconstUV("Net::TCP::TCP_RPTR2RXT", TCP_RPTR2RXT, file);
#endif
	newXSconstUV("Net::TCP::TH_ACK", TH_ACK, file);
	newXSconstUV("Net::TCP::TH_FIN", TH_FIN, file);
	newXSconstUV("Net::TCP::TH_PUSH", TH_PUSH, file);
	newXSconstUV("Net::TCP::TH_RST", TH_RST, file);
	newXSconstUV("Net::TCP::TH_SYN", TH_SYN, file);
	newXSconstUV("Net::TCP::TH_URG", TH_URG, file);


MODULE = Net::Gen		PACKAGE = Net::Inet	PREFIX = f_uc_

BOOT:
	newXSconstUV("Net::Inet::DEFTTL", DEFTTL, file);
	newXSconstUV("Net::Inet::ICMP_ADVLENMIN", ICMP_ADVLENMIN, file);
	newXSconstUV("Net::Inet::ICMP_ECHO", ICMP_ECHO, file);
	newXSconstUV("Net::Inet::ICMP_ECHOREPLY", ICMP_ECHOREPLY, file);
	newXSconstUV("Net::Inet::ICMP_IREQ", ICMP_IREQ, file);
	newXSconstUV("Net::Inet::ICMP_IREQREPLY", ICMP_IREQREPLY, file);
	newXSconstUV("Net::Inet::ICMP_MASKLEN", ICMP_MASKLEN, file);
	newXSconstUV("Net::Inet::ICMP_MASKREPLY", ICMP_MASKREPLY, file);
	newXSconstUV("Net::Inet::ICMP_MASKREQ", ICMP_MASKREQ, file);
	newXSconstUV("Net::Inet::ICMP_MAXTYPE", ICMP_MAXTYPE, file);
	newXSconstUV("Net::Inet::ICMP_MINLEN", ICMP_MINLEN, file);
	newXSconstUV("Net::Inet::ICMP_PARAMPROB", ICMP_PARAMPROB, file);
	newXSconstUV("Net::Inet::ICMP_REDIRECT", ICMP_REDIRECT, file);
	newXSconstUV("Net::Inet::ICMP_REDIRECT_HOST", ICMP_REDIRECT_HOST, file);
	newXSconstUV("Net::Inet::ICMP_REDIRECT_NET", ICMP_REDIRECT_NET, file);
	newXSconstUV("Net::Inet::ICMP_REDIRECT_TOSHOST", ICMP_REDIRECT_TOSHOST, file);
	newXSconstUV("Net::Inet::ICMP_REDIRECT_TOSNET", ICMP_REDIRECT_TOSNET, file);
	newXSconstUV("Net::Inet::ICMP_SOURCEQUENCH", ICMP_SOURCEQUENCH, file);
	newXSconstUV("Net::Inet::ICMP_TIMXCEED", ICMP_TIMXCEED, file);
	newXSconstUV("Net::Inet::ICMP_TIMXCEED_INTRANS", ICMP_TIMXCEED_INTRANS, file);
	newXSconstUV("Net::Inet::ICMP_TIMXCEED_REASS", ICMP_TIMXCEED_REASS, file);
	newXSconstUV("Net::Inet::ICMP_TSLEN", ICMP_TSLEN, file);
	newXSconstUV("Net::Inet::ICMP_TSTAMP", ICMP_TSTAMP, file);
	newXSconstUV("Net::Inet::ICMP_TSTAMPREPLY", ICMP_TSTAMPREPLY, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH", ICMP_UNREACH, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_HOST", ICMP_UNREACH_HOST, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_NEEDFRAG", ICMP_UNREACH_NEEDFRAG, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_NET", ICMP_UNREACH_NET, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_PORT", ICMP_UNREACH_PORT, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_PROTOCOL", ICMP_UNREACH_PROTOCOL, file);
	newXSconstUV("Net::Inet::ICMP_UNREACH_SRCFAIL", ICMP_UNREACH_SRCFAIL, file);
	newXSconstUV("Net::Inet::IN_CLASSA_HOST", IN_CLASSA_HOST, file);
	newXSconstUV("Net::Inet::IN_CLASSA_MAX", IN_CLASSA_MAX, file);
	newXSconstUV("Net::Inet::IN_CLASSA_NET", IN_CLASSA_NET, file);
	newXSconstUV("Net::Inet::IN_CLASSA_NSHIFT", IN_CLASSA_NSHIFT, file);
#ifdef IN_CLASSA_SUBHOST
	newXSconstUV("Net::Inet::IN_CLASSA_SUBHOST", IN_CLASSA_SUBHOST, file);
#endif
#ifdef IN_CLASSA_SUBNET
	newXSconstUV("Net::Inet::IN_CLASSA_SUBNET", IN_CLASSA_SUBNET, file);
#endif
#ifdef IN_CLASSA_SUBNSHIFT
	newXSconstUV("Net::Inet::IN_CLASSA_SUBNSHIFT", IN_CLASSA_SUBNSHIFT, file);
#endif
	newXSconstUV("Net::Inet::IN_CLASSB_HOST", IN_CLASSB_HOST, file);
	newXSconstUV("Net::Inet::IN_CLASSB_MAX", IN_CLASSB_MAX, file);
	newXSconstUV("Net::Inet::IN_CLASSB_NET", IN_CLASSB_NET, file);
	newXSconstUV("Net::Inet::IN_CLASSB_NSHIFT", IN_CLASSB_NSHIFT, file);
#ifdef IN_CLASSB_SUBHOST
	newXSconstUV("Net::Inet::IN_CLASSB_SUBHOST", IN_CLASSB_SUBHOST, file);
#endif
#ifdef IN_CLASSB_SUBNET
	newXSconstUV("Net::Inet::IN_CLASSB_SUBNET", IN_CLASSB_SUBNET, file);
#endif
#ifdef IN_CLASSB_SUBNSHIFT
	newXSconstUV("Net::Inet::IN_CLASSB_SUBNSHIFT", IN_CLASSB_SUBNSHIFT, file);
#endif
	newXSconstUV("Net::Inet::IN_CLASSC_HOST", IN_CLASSC_HOST, file);
	newXSconstUV("Net::Inet::IN_CLASSC_MAX", IN_CLASSC_MAX, file);
	newXSconstUV("Net::Inet::IN_CLASSC_NET", IN_CLASSC_NET, file);
	newXSconstUV("Net::Inet::IN_CLASSC_NSHIFT", IN_CLASSC_NSHIFT, file);
	newXSconstUV("Net::Inet::IN_CLASSD_HOST", IN_CLASSD_HOST, file);
	newXSconstUV("Net::Inet::IN_CLASSD_NET", IN_CLASSD_NET, file);
	newXSconstUV("Net::Inet::IN_CLASSD_NSHIFT", IN_CLASSD_NSHIFT, file);
	newXSconstUV("Net::Inet::IN_LOOPBACKNET", IN_LOOPBACKNET, file);
#ifdef IPFRAGTTL
	newXSconstUV("Net::Inet::IPFRAGTTL", IPFRAGTTL, file);
#endif
	newXSconstUV("Net::Inet::IPOPT_CIPSO", IPOPT_CIPSO, file);
	newXSconstUV("Net::Inet::IPOPT_CONTROL", IPOPT_CONTROL, file);
	newXSconstUV("Net::Inet::IPOPT_DEBMEAS", IPOPT_DEBMEAS, file);
	newXSconstUV("Net::Inet::IPOPT_EOL", IPOPT_EOL, file);
	newXSconstUV("Net::Inet::IPOPT_LSRR", IPOPT_LSRR, file);
	newXSconstUV("Net::Inet::IPOPT_MINOFF", IPOPT_MINOFF, file);
	newXSconstUV("Net::Inet::IPOPT_NOP", IPOPT_NOP, file);
	newXSconstUV("Net::Inet::IPOPT_OFFSET", IPOPT_OFFSET, file);
	newXSconstUV("Net::Inet::IPOPT_OLEN", IPOPT_OLEN, file);
	newXSconstUV("Net::Inet::IPOPT_OPTVAL", IPOPT_OPTVAL, file);
	newXSconstUV("Net::Inet::IPOPT_RESERVED1", IPOPT_RESERVED1, file);
	newXSconstUV("Net::Inet::IPOPT_RESERVED2", IPOPT_RESERVED2, file);
	newXSconstUV("Net::Inet::IPOPT_RIPSO_AUX", IPOPT_RIPSO_AUX, file);
	newXSconstUV("Net::Inet::IPOPT_RR", IPOPT_RR, file);
	newXSconstUV("Net::Inet::IPOPT_SATID", IPOPT_SATID, file);
	newXSconstUV("Net::Inet::IPOPT_SECURITY", IPOPT_SECURITY, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_CONFID", IPOPT_SECUR_CONFID, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_EFTO", IPOPT_SECUR_EFTO, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_MMMM", IPOPT_SECUR_MMMM, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_RESTR", IPOPT_SECUR_RESTR, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_SECRET", IPOPT_SECUR_SECRET, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_TOPSECRET", IPOPT_SECUR_TOPSECRET, file);
	newXSconstUV("Net::Inet::IPOPT_SECUR_UNCLASS", IPOPT_SECUR_UNCLASS, file);
	newXSconstUV("Net::Inet::IPOPT_SSRR", IPOPT_SSRR, file);
	newXSconstUV("Net::Inet::IPOPT_TS", IPOPT_TS, file);
	newXSconstUV("Net::Inet::IPOPT_TS_PRESPEC", IPOPT_TS_PRESPEC, file);
	newXSconstUV("Net::Inet::IPOPT_TS_TSANDADDR", IPOPT_TS_TSANDADDR, file);
	newXSconstUV("Net::Inet::IPOPT_TS_TSONLY", IPOPT_TS_TSONLY, file);
	newXSconstUV("Net::Inet::IPPORT_RESERVED", IPPORT_RESERVED, file);
#ifdef IPPORT_TIMESERVER
	newXSconstUV("Net::Inet::IPPORT_TIMESERVER", IPPORT_TIMESERVER, file);
#endif
	newXSconstUV("Net::Inet::IPPORT_USERRESERVED", IPPORT_USERRESERVED, file);
	newXSconstUV("Net::Inet::IPPROTO_EGP", IPPROTO_EGP, file);
	newXSconstUV("Net::Inet::IPPROTO_EON", IPPROTO_EON, file);
	newXSconstUV("Net::Inet::IPPROTO_GGP", IPPROTO_GGP, file);
	newXSconstUV("Net::Inet::IPPROTO_HELLO", IPPROTO_HELLO, file);
	newXSconstUV("Net::Inet::IPPROTO_ICMP", IPPROTO_ICMP, file);
	newXSconstUV("Net::Inet::IPPROTO_IDP", IPPROTO_IDP, file);
	newXSconstUV("Net::Inet::IPPROTO_IGMP", IPPROTO_IGMP, file);
	newXSconstUV("Net::Inet::IPPROTO_IP", IPPROTO_IP, file);
	newXSconstUV("Net::Inet::IPPROTO_IPIP", IPPROTO_IPIP, file);
	newXSconstUV("Net::Inet::IPPROTO_MAX", IPPROTO_MAX, file);
	newXSconstUV("Net::Inet::IPPROTO_PUP", IPPROTO_PUP, file);
	newXSconstUV("Net::Inet::IPPROTO_RAW", IPPROTO_RAW, file);
	newXSconstUV("Net::Inet::IPPROTO_RSVP", IPPROTO_RSVP, file);
	newXSconstUV("Net::Inet::IPPROTO_TCP", IPPROTO_TCP, file);
	newXSconstUV("Net::Inet::IPPROTO_TP", IPPROTO_TP, file);
	newXSconstUV("Net::Inet::IPPROTO_UDP", IPPROTO_UDP, file);
	newXSconstUV("Net::Inet::IPTOS_LOWDELAY", IPTOS_LOWDELAY, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_CRITIC_ECP", IPTOS_PREC_CRITIC_ECP, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_FLASH", IPTOS_PREC_FLASH, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_FLASHOVERRIDE", IPTOS_PREC_FLASHOVERRIDE, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_IMMEDIATE", IPTOS_PREC_IMMEDIATE, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_INTERNETCONTROL", IPTOS_PREC_INTERNETCONTROL, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_NETCONTROL", IPTOS_PREC_NETCONTROL, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_PRIORITY", IPTOS_PREC_PRIORITY, file);
	newXSconstUV("Net::Inet::IPTOS_PREC_ROUTINE", IPTOS_PREC_ROUTINE, file);
	newXSconstUV("Net::Inet::IPTOS_RELIABILITY", IPTOS_RELIABILITY, file);
	newXSconstUV("Net::Inet::IPTOS_THROUGHPUT", IPTOS_THROUGHPUT, file);
	newXSconstUV("Net::Inet::IPTTLDEC", IPTTLDEC, file);
	newXSconstUV("Net::Inet::IPVERSION", IPVERSION, file);
#ifdef IP_ADD_MEMBERSHIP
	newXSconstUV("Net::Inet::IP_ADD_MEMBERSHIP", IP_ADD_MEMBERSHIP, file);
#endif
#ifdef IP_DEFAULT_MULTICAST_LOOP
	newXSconstUV("Net::Inet::IP_DEFAULT_MULTICAST_LOOP", IP_DEFAULT_MULTICAST_LOOP, file);
#endif
#ifdef IP_DEFAULT_MULTICAST_TTL
	newXSconstUV("Net::Inet::IP_DEFAULT_MULTICAST_TTL", IP_DEFAULT_MULTICAST_TTL, file);
#endif
	newXSconstUV("Net::Inet::IP_DF", IP_DF, file);
#ifdef IP_DROP_MEMBERSHIP
	newXSconstUV("Net::Inet::IP_DROP_MEMBERSHIP", IP_DROP_MEMBERSHIP, file);
#endif
#ifdef IP_HDRINCL
	newXSconstUV("Net::Inet::IP_HDRINCL", IP_HDRINCL, file);
#endif
	newXSconstUV("Net::Inet::IP_MAXPACKET", IP_MAXPACKET, file);
#ifdef IP_MAX_MEMBERSHIPS
	newXSconstUV("Net::Inet::IP_MAX_MEMBERSHIPS", IP_MAX_MEMBERSHIPS, file);
#endif
	newXSconstUV("Net::Inet::IP_MF", IP_MF, file);
	newXSconstUV("Net::Inet::IP_MSS", IP_MSS, file);
#ifdef IP_MULTICAST_IF
	newXSconstUV("Net::Inet::IP_MULTICAST_IF", IP_MULTICAST_IF, file);
#endif
#ifdef IP_MULTICAST_LOOP
	newXSconstUV("Net::Inet::IP_MULTICAST_LOOP", IP_MULTICAST_LOOP, file);
#endif
#ifdef IP_MULTICAST_TTL
	newXSconstUV("Net::Inet::IP_MULTICAST_TTL", IP_MULTICAST_TTL, file);
#endif
#ifdef IP_OPTIONS
	newXSconstUV("Net::Inet::IP_OPTIONS", IP_OPTIONS, file);
#endif
#ifdef IP_RECVDSTADDR
	newXSconstUV("Net::Inet::IP_RECVDSTADDR", IP_RECVDSTADDR, file);
#endif
#ifdef IP_RECVOPTS
	newXSconstUV("Net::Inet::IP_RECVOPTS", IP_RECVOPTS, file);
#endif
#ifdef IP_RECVRETOPTS
	newXSconstUV("Net::Inet::IP_RECVRETOPTS", IP_RECVRETOPTS, file);
#endif
#ifdef IP_RETOPTS
	newXSconstUV("Net::Inet::IP_RETOPTS", IP_RETOPTS, file);
#endif
#ifdef IP_TOS
	newXSconstUV("Net::Inet::IP_TOS", IP_TOS, file);
#endif
#ifdef IP_TTL
	newXSconstUV("Net::Inet::IP_TTL", IP_TTL, file);
#endif
	newXSconstUV("Net::Inet::MAXTTL", MAXTTL, file);
	newXSconstUV("Net::Inet::MAX_IPOPTLEN", MAX_IPOPTLEN, file);
	newXSconstUV("Net::Inet::MINTTL", MINTTL, file);
#ifdef SUBNETSHIFT
	newXSconstUV("Net::Inet::SUBNETSHIFT", SUBNETSHIFT, file);
#endif
    {
	struct in_addr ina;
	ina.s_addr = htonl(INADDR_ALLHOSTS_GROUP);
	newXSconstPVN("Net::Inet::INADDR_ALLHOSTS_GROUP",
		      (char*)&ina, sizeof ina, file);
	ina.s_addr = htonl(INADDR_ALLRTRS_GROUP);
	newXSconstPVN("Net::Inet::INADDR_ALLRTRS_GROUP",
		      (char*)&ina, sizeof ina, file);
	ina.s_addr = htonl(INADDR_MAX_LOCAL_GROUP);
	newXSconstPVN("Net::Inet::INADDR_MAX_LOCAL_GROUP",
		      (char*)&ina, sizeof ina, file);
	ina.s_addr = htonl(INADDR_UNSPEC_GROUP);
	newXSconstPVN("Net::Inet::INADDR_UNSPEC_GROUP",
		      (char*)&ina, sizeof ina, file);
    }


MODULE = Net::Gen		PACKAGE = Net::Inet

bool
IN_CLASSA(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_CLASSB(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_CLASSC(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_CLASSD(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_MULTICAST(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_EXPERIMENTAL(hostaddr)
	sv_inaddr_t	hostaddr

bool
IN_BADCLASS(hostaddr)
	sv_inaddr_t	hostaddr

bool
IPOPT_COPIED(ipopt)
	U8	ipopt

bool
IPOPT_CLASS(ipopt)
	U8	ipopt

bool
IPOPT_NUMBER(ipopt)
	U8	ipopt

bool
ICMP_INFOTYPE(icmp_code)
	U8	icmp_code

SV *
_pack_sockaddr_in(family,port,address)
	U8	family
	U16	port
	SV *	address
    PREINIT:
	struct sockaddr_in sin;
	char * adata;
	STRLEN adlen;
    CODE:
	Zero(&sin, sizeof sin, char);
	sin.sin_family = family;
	adata = SvPV(address, adlen);
	sin.sin_port = htons(port);
	if (adlen == sizeof sin.sin_addr) {
	    Copy(adata, &sin.sin_addr, sizeof sin.sin_addr, char);
	    ST(0) = sv_2mortal(newSVpv((char*)&sin, sizeof sin));
	}
	else {
	    SV *adsv = sv_2mortal(newSVpv((char*)&sin,
					  STRUCT_OFFSET(struct sockaddr_in,
							sin_addr)));
	    sv_catpvn(adsv, adata, adlen);
	    ST(0) = adsv;
	}

void
unpack_sockaddr_in(sad)
	SV *	sad
    PREINIT:
	char *	cp;
	struct sockaddr_in sin;
	STRLEN	len;
    PPCODE:
	if ((cp = SvPV(sad, len)) != (char*)0 && len >= sizeof sin) {
	    U16  family;
	    U16  port;
	    char * adata;
	    STRLEN addrlen;

	    Copy(cp, &sin, sizeof sin, char);
	    family = sin.sin_family;
	    if (family > 255) {	/* 4.4BSD anyone? */
		U8 famlen1, famlen2;
		famlen1 = family & 255;
		famlen2 = (family >> 8) & 255;
		if (famlen1 == famlen2) {
		    family = famlen1;
		}
		else if (famlen1 == len) {
		    family = famlen2;
		}
		else if (famlen2 == len) {
		    family = famlen1;
		}
		else if (famlen1 == AF_INET || famlen2 == AF_INET) {
		    family = AF_INET;
		}
		else if (famlen1 < famlen2) {
		    family = famlen1;
		}
		else {
		    family = famlen2;
		}
	    }
	    port = ntohs(sin.sin_port);
	    /* now work on the address */
	    cp += STRUCT_OFFSET(struct sockaddr_in, sin_addr);
	    addrlen = len - STRUCT_OFFSET(struct sockaddr_in, sin_addr);
	    if (family == AF_INET && len == sizeof sin)
		addrlen = sizeof sin.sin_addr;

	    EXTEND(sp,3);
	    PUSHs(sv_2mortal(newSViv((IV)family)));
	    PUSHs(sv_2mortal(newSViv((IV)port)));
	    PUSHs(sv_2mortal(newSVpv(cp, addrlen)));
	}


MODULE = Net::Gen		PACKAGE = Net::Gen	PREFIX = f_ic_

BOOT:
#ifdef	EOF_NONBLOCK
#define	f_ic_EOF_NONBLOCK	1
#else
#define	f_ic_EOF_NONBLOCK	0
#endif
	newXSconstIV("Net::Gen::EOF_NONBLOCK", f_ic_EOF_NONBLOCK, file);
#ifdef	RD_NODATA
	newXSconstIV("Net::Gen::RD_NODATA", RD_NODATA, file);
#endif


MODULE = Net::Gen		PACKAGE = Net::Gen	PREFIX = f_uc_

BOOT:
#ifdef	VAL_O_NONBLOCK
	newXSconstUV("Net::Gen::VAL_O_NONBLOCK", VAL_O_NONBLOCK, file);
#endif
#ifdef	VAL_EAGAIN
	newXSconstUV("Net::Gen::VAL_EAGAIN", VAL_EAGAIN, file);
#endif
	newXSconstUV("Net::Gen::MSG_OOB", MSG_OOB, file);
	newXSconstUV("Net::Gen::ENOENT", ENOENT, file);
	newXSconstUV("Net::Gen::EINVAL", EINVAL, file);
	newXSconstUV("Net::Gen::EBADF", EBADF, file);
	newXSconstUV("Net::Gen::EAGAIN", EAGAIN, file);
	newXSconstUV("Net::Gen::EWOULDBLOCK", EWOULDBLOCK, file);
	newXSconstUV("Net::Gen::EINPROGRESS", EINPROGRESS, file);
	newXSconstUV("Net::Gen::EALREADY", EALREADY, file);
	newXSconstUV("Net::Gen::ENOTSOCK", ENOTSOCK, file);
	newXSconstUV("Net::Gen::EDESTADDRREQ", EDESTADDRREQ, file);
	newXSconstUV("Net::Gen::EMSGSIZE", EMSGSIZE, file);
	newXSconstUV("Net::Gen::EPROTOTYPE", EPROTOTYPE, file);
	newXSconstUV("Net::Gen::ENOPROTOOPT", ENOPROTOOPT, file);
	newXSconstUV("Net::Gen::EPROTONOSUPPORT", EPROTONOSUPPORT, file);
	newXSconstUV("Net::Gen::ESOCKTNOSUPPORT", ESOCKTNOSUPPORT, file);
	newXSconstUV("Net::Gen::EOPNOTSUPP", EOPNOTSUPP, file);
	newXSconstUV("Net::Gen::EPFNOSUPPORT", EPFNOSUPPORT, file);
	newXSconstUV("Net::Gen::EAFNOSUPPORT", EAFNOSUPPORT, file);
	newXSconstUV("Net::Gen::EADDRINUSE", EADDRINUSE, file);
	newXSconstUV("Net::Gen::EADDRNOTAVAIL", EADDRNOTAVAIL, file);
	newXSconstUV("Net::Gen::ENETDOWN", ENETDOWN, file);
	newXSconstUV("Net::Gen::ENETUNREACH", ENETUNREACH, file);
	newXSconstUV("Net::Gen::ENETRESET", ENETRESET, file);
	newXSconstUV("Net::Gen::ECONNABORTED", ECONNABORTED, file);
	newXSconstUV("Net::Gen::ECONNRESET", ECONNRESET, file);
	newXSconstUV("Net::Gen::ENOBUFS", ENOBUFS, file);
	newXSconstUV("Net::Gen::EISCONN", EISCONN, file);
	newXSconstUV("Net::Gen::ENOTCONN", ENOTCONN, file);
	newXSconstUV("Net::Gen::ESHUTDOWN", ESHUTDOWN, file);
	newXSconstUV("Net::Gen::ETOOMANYREFS", ETOOMANYREFS, file);
	newXSconstUV("Net::Gen::ETIMEDOUT", ETIMEDOUT, file);
	newXSconstUV("Net::Gen::ECONNREFUSED", ECONNREFUSED, file);
	newXSconstUV("Net::Gen::EHOSTDOWN", EHOSTDOWN, file);
	newXSconstUV("Net::Gen::EHOSTUNREACH", EHOSTUNREACH, file);
	newXSconstUV("Net::Gen::ENOSR", ENOSR, file);
	newXSconstUV("Net::Gen::ETIME", ETIME, file);
	newXSconstUV("Net::Gen::EBADMSG", EBADMSG, file);
	newXSconstUV("Net::Gen::EPROTO", EPROTO, file);
	newXSconstUV("Net::Gen::ENODATA", ENODATA, file);
	newXSconstUV("Net::Gen::ENOSTR", ENOSTR, file);
	newXSconstUV("Net::Gen::SOMAXCONN", SOMAXCONN, file);


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

