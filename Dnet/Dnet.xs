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

#include <netdnet/dn.h>
#include <netdnet/dnetdb.h>
#include <netdnet/nsp_addr.h>

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static U32
iconst(name)
char *name;
{
    switch (*name) {
    case 'A':
	if (strEQ(name, "ACC_DEFER"))
#ifdef ACC_DEFER
	    return ACC_DEFER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ACC_IMMED"))
#ifdef ACC_IMMED
	    return ACC_IMMED;
#else
	    goto not_there;
#endif
	break;
    case 'D':
	if (strEQ(name, "DNOBJECT_CTERM"))
#ifdef DNOBJECT_CTERM
	    return DNOBJECT_CTERM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_DTERM"))
#ifdef DNOBJECT_DTERM
	    return DNOBJECT_DTERM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_DTR"))
#ifdef DNOBJECT_DTR
	    return DNOBJECT_DTR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_EVR"))
#ifdef DNOBJECT_EVR
	    return DNOBJECT_EVR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_FAL"))
#ifdef DNOBJECT_FAL
	    return DNOBJECT_FAL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_MAIL11"))
#ifdef DNOBJECT_MAIL11
	    return DNOBJECT_MAIL11;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_MIRROR"))
#ifdef DNOBJECT_MIRROR
	    return DNOBJECT_MIRROR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_NICE"))
#ifdef DNOBJECT_NICE
	    return DNOBJECT_NICE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJECT_PHONE"))
#ifdef DNOBJECT_PHONE
	    return DNOBJECT_PHONE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_EVL"))
#ifdef DNPROTO_EVL
	    return DNPROTO_EVL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_EVR"))
#ifdef DNPROTO_EVR
	    return DNPROTO_EVR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_NML"))
#ifdef DNPROTO_NML
	    return DNPROTO_NML;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_NSP"))
#ifdef DNPROTO_NSP
	    return DNPROTO_NSP;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_NSPT"))
#ifdef DNPROTO_NSPT
	    return DNPROTO_NSPT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNPROTO_ROU"))
#ifdef DNPROTO_ROU
	    return DNPROTO_ROU;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DN_MAXADDL"))
#ifdef DN_MAXADDL
	    return DN_MAXADDL;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_ACCEPTMODE"))
#ifdef DSO_ACCEPTMODE
	    return DSO_ACCEPTMODE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_CONACCEPT"))
#ifdef DSO_CONACCEPT
	    return DSO_CONACCEPT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_CONACCESS"))
#ifdef DSO_CONACCESS
	    return DSO_CONACCESS;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_CONDATA"))
#ifdef DSO_CONDATA
	    return DSO_CONDATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_CONREJECT"))
#ifdef DSO_CONREJECT
	    return DSO_CONREJECT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_DISDATA"))
#ifdef DSO_DISDATA
	    return DSO_DISDATA;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_LINKINFO"))
#ifdef DSO_LINKINFO
	    return DSO_LINKINFO;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_MAX"))
#ifdef DSO_MAX
	    return DSO_MAX;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_SEQPACKET"))
#ifdef DSO_SEQPACKET
	    return DSO_SEQPACKET;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DSO_STREAM"))
#ifdef DSO_STREAM
	    return DSO_STREAM;
#else
	    goto not_there;
#endif
	break;
    case 'L':
	if (strEQ(name, "LL_CONNECTING"))
#ifdef LL_CONNECTING
	    return LL_CONNECTING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "LL_DISCONNECTING"))
#ifdef LL_DISCONNECTING
	    return LL_DISCONNECTING;
#else
	    goto not_there;
#endif
	if (strEQ(name, "LL_INACTIVE"))
#ifdef LL_INACTIVE
	    return LL_INACTIVE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "LL_RUNNING"))
#ifdef LL_RUNNING
	    return LL_RUNNING;
#else
	    goto not_there;
#endif
	break;
    case 'N':
	if (strEQ(name, "ND_MAXNODE"))
#ifdef ND_MAXNODE
	    return ND_MAXNODE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ND_PERMANENT"))
#ifdef ND_PERMANENT
	    return ND_PERMANENT;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ND_VERSION"))
#ifdef ND_VERSION
	    return ND_VERSION;
#else
	    goto not_there;
#endif
	if (strEQ(name, "ND_VOLATILE"))
#ifdef ND_VOLATILE
	    return ND_VOLATILE;
#else
	    goto not_there;
#endif
	break;
    case 'O':
	if (strEQ(name, "OB_MAXFILE"))
#ifdef OB_MAXFILE
	    return OB_MAXFILE;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OB_MAXNAME"))
#ifdef OB_MAXNAME
	    return OB_MAXNAME;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OB_MAXUSER"))
#ifdef OB_MAXUSER
	    return OB_MAXUSER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OF_DEFER"))
#ifdef OF_DEFER
	    return OF_DEFER;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OF_STREAM"))
#ifdef OF_STREAM
	    return OF_STREAM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OSIOCGNETADDR"))
#ifdef OSIOCGNETADDR
	    return OSIOCGNETADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "OSIOCSNETADDR"))
#ifdef OSIOCSNETADDR
	    return OSIOCSNETADDR;
#else
	    goto not_there;
#endif
	break;
    case 'S':
	if (strEQ(name, "SDF_PROXY"))
#ifdef SDF_PROXY
	    return SDF_PROXY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SDF_UICPROXY"))
#ifdef SDF_UICPROXY
	    return SDF_UICPROXY;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SDF_WILD"))
#ifdef SDF_WILD
	    return SDF_WILD;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCGNETADDR"))
#ifdef SIOCGNETADDR
	    return SIOCGNETADDR;
#else
	    goto not_there;
#endif
	if (strEQ(name, "SIOCSNETADDR"))
#ifdef SIOCSNETADDR
	    return SIOCSNETADDR;
#else
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

static char *
sconst(name)
char *name;
{
    switch (name[sizeof "DNOBJ_" - 1]) {
    case 'C':
	if (strEQ(name, "DNOBJ_CTERM"))
#ifdef DNOBJ_CTERM
	    return DNOBJ_CTERM;
#else
	    goto not_there;
#endif
	break;
    case 'D':
	if (strEQ(name, "DNOBJ_DTERM"))
#ifdef DNOBJ_DTERM
	    return DNOBJ_DTERM;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJ_DTR"))
#ifdef DNOBJ_DTR
	    return DNOBJ_DTR;
#else
	    goto not_there;
#endif
	break;
    case 'E':
	if (strEQ(name, "DNOBJ_EVR"))
#ifdef DNOBJ_EVR
	    return DNOBJ_EVR;
#else
	    goto not_there;
#endif
	break;
    case 'F':
	if (strEQ(name, "DNOBJ_FAL"))
#ifdef DNOBJ_FAL
	    return DNOBJ_FAL;
#else
	    goto not_there;
#endif
	break;
    case 'M':
	if (strEQ(name, "DNOBJ_MAIL11"))
#ifdef DNOBJ_MAIL11
	    return DNOBJ_MAIL11;
#else
	    goto not_there;
#endif
	if (strEQ(name, "DNOBJ_MIRROR"))
#ifdef DNOBJ_MIRROR
	    return DNOBJ_MIRROR;
#else
	    goto not_there;
#endif
	break;
    case 'N':
	if (strEQ(name, "DNOBJ_NICE"))
#ifdef DNOBJ_NICE
	    return DNOBJ_NICE;
#else
	    goto not_there;
#endif
	break;
    case 'P':
	if (strEQ(name, "DNOBJ_PHONE"))
#ifdef DNOBJ_PHONE
	    return DNOBJ_PHONE;
#else
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

static SV *
constant(name, arg)
char *name;
{
    U32 uv;
    char *cp;
    SV *svp;

    svp = sv_newmortal();
    errno = 0;
    if (strnEQ(name, "DNOBJ_", 6)) {
	cp = sconst(name);
	if (!errno && cp) {
	    sv_setpv(svp, cp);
	}
    }
    else {
	uv = iconst(name);
	if (!errno) {
	    sv_setiv(svp, (IV)uv);
	}
    }
    return svp;
}


MODULE = Net::Dnet		PACKAGE = Net::Dnet


SV *
constant(name)
	char *		name

