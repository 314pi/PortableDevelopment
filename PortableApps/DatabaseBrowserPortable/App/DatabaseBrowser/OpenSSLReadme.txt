-----------------------------------------------------------------------------
OpenSSL v0.9.8l, Precompiled Binaries for Win32
-----------------------------------------------------------------------------

Released Date:  November 9, 2009

Created by:     Arvid Winkelsdorf (digivendo GmbH, www.digivendo.com)
                for The Indy Project (www.indyproject.org)

Dependencies:   Requires Indy v10.2.5/10.5.5 or higher (SVN)
                (i.e. Indy preinstalled with Delphi 2009/2010)

THIS SOFTWARE IS PROVIDED BY THE INDY PROJECT 'AS IS'. Please see the
OpenSSL license terms in OpenSSL-License.txt.

Build Informations
------------------

Built with:     MinGW-5.1.4 / gcc 3.4.5 (mingw-vista special r3)
                Strawberry Perl v5.10.1.0 built for MSWin32-x86-multi-thread
Commands:       perl configure mingw
                ms\mingw32				 
Test commands:  cd out
                ..\ms\test
Renaming:       \libssl32.dll to \ssleay32.dll

Comment:
  Win32 DLLs built using Mingw32 in order to provide best support for older 
  OS (e.g. Win9x/2k) by linking against msvcrt.dll. Building libraries with 
  compilers like MS VC++ 2005/2008 would require installation of MS VC 
  Runtime Libaries on some target systems.

----------------------------------------------------------------------------- 