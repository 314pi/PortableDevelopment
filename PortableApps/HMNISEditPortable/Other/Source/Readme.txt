The base application's source code is available from the portable app's
homepage listed in the help.html file (if applicable).

Details of most other things are available there as well.

LICENSE
=======

This package's installer and launcher are released under the GPL.

USER CONFIGURATION
==================

Some configuration in the launcher can be overridden by the
user in an INI file next to HMNISEditPortable.exe called HMNISEditPortable.ini.
If you are happy with the default options, it is not necessary, though.  There
is an example INI included with this package to get you started.  To use it,
copy AppNamePortable.ini from this directory to HMNISEditPortable.ini next to
HMNISEditPortable.exe. The options in the INI file are as follows:

   AdditionalParameters=
   DisableSplashScreen=false
   
(There is no need for an INI header in this file; if you have one, though, it
won't damage anything.)

The AdditionalParameters entry allows you to pass additional command-line
parameters to the application.

The DisableSplashScreen entry allows you to run the launcher without the splash
screen showing up.  The default is false.

There may be other values also permitted in the user configuration file by the
portable application; refer to help.html for any details of them.
