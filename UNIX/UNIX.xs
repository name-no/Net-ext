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

#include <sys/un.h>

static int
not_here(s)
char *s;
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    switch (*name) {
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


MODULE = Net::UNIX		PACKAGE = Net::UNIX


double
constant(name,arg)
	char *		name
	int		arg

SV *
_pack_sockaddr_un(fam,pathsv)
	unsigned short	fam
	SV *	pathsv
 CODE:
	{
	    struct sockaddr_un sunad;
	    char *pathp;
	    STRLEN plen;
	    pathp = SvPV(pathsv, plen);
	    sunad.sun_family = fam;
	    (void) strncpy((char *)&sunad.sun_path, pathp,
			   sizeof(sunad.sun_path)); /* it's a real pathname */
	    RETVAL = sv_2mortal(newSVpv((char *)&sunad, sizeof sunad));
	    if (plen > sizeof(sunad.sun_path)) {
		pathp += sizeof(sunad.sun_path);
		plen -= sizeof(sunad.sun_path);
		sv_catpvn(RETVAL, pathp, plen+1);
	    }
	}
 OUTPUT:
	RETVAL
