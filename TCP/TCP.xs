/*

# Copyright 1995,1996 Spider Boardman.
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
#include <netinet/ip_var.h>
#include <netinet/tcp.h>
#include <netinet/tcpip.h>

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
	break;
    case 'J':
	break;
    case 'K':
	break;
    case 'L':
	break;
    case 'M':
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
	break;
    case 'T':
	if (strEQ(name, "TCPOPT_EOL"))
#ifdef TCPOPT_EOL
	    return TCPOPT_EOL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCPOPT_MAXSEG"))
#ifdef TCPOPT_MAXSEG
	    return TCPOPT_MAXSEG;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCPOPT_NOP"))
#ifdef TCPOPT_NOP
	    return TCPOPT_NOP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCPOPT_WINDOW"))
#ifdef TCPOPT_WINDOW
	    return TCPOPT_WINDOW;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_MAXSEG"))
#ifdef TCP_MAXSEG
	    return TCP_MAXSEG;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_MAXWIN"))
#ifdef TCP_MAXWIN
	    return TCP_MAXWIN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_MAX_WINSHIFT"))
#ifdef TCP_MAX_WINSHIFT
	    return TCP_MAX_WINSHIFT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_MSS"))
#ifdef TCP_MSS
	    return TCP_MSS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_NODELAY"))
#ifdef TCP_NODELAY
	    return TCP_NODELAY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TCP_RPTR2RXT"))
#ifdef TCP_RPTR2RXT
	    return TCP_RPTR2RXT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_ACK"))
#ifdef TH_ACK
	    return TH_ACK;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_FIN"))
#ifdef TH_FIN
	    return TH_FIN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_PUSH"))
#ifdef TH_PUSH
	    return TH_PUSH;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_RST"))
#ifdef TH_RST
	    return TH_RST;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_SYN"))
#ifdef TH_SYN
	    return TH_SYN;
#else
	    goto not_there;
#endif
	if (strEQ(name, "TH_URG"))
#ifdef TH_URG
	    return TH_URG;
#else
	    goto not_there;
#endif
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


MODULE = Net::TCP		PACKAGE = Net::TCP

U32
constant(name,arg)
	char *		name
	int		arg

