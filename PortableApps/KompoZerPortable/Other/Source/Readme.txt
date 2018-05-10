Nvu & KompoZer Portable Launcher 1.5.2.0
========================================
Copyright 2004-2007 John T. Haller of PortableApps.com
Portions Copyright 2004 mai9

Website: http://PortableApps.com/NvuPortable

This software is OSI Certified Open Source Software.
OSI Certified is a certification mark of the Open Source Initiative.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

ABOUT Nvu PORTABLE
==================
The Nvu Portable Launcher allows you to run Nvu from a removable drive whose letter changes as you move it to another computer.  The web editor and the profile can be entirely self-contained on the drive and then used on any Windows computer.  Specific configuration changes are made to the chrome.rdf so that your extensions will still work as the drive letter changes.


LICENSE
=======
This code is released under the GPL.  Within the NvuPortableSource directory you will find the code (NvuPortable.nsi) as well as the full GPL license (License.txt).  If you use the launcher or code in your own product, please give proper and prominent attribution.


INSTALLATION / DIRECTORY STRUCTURE
==================================
By default, the program expects this directory structure:

-\ <--- Directory with NvuPortable.exe
  +\App\
    +\Nvu\
  +\Data\
    +\profile\
    +\plugins\ (optional)
    +\userprofile\ (optional)

It can be used in other directory configurations by including the NvuPortable.ini file in the same directory as NvuPortable.exe and configuring it as details in the INI file section below.


NvuPortable.INI CONFIGURATION
=============================
The Nvu Portable Launcher will look for an ini file called NvuPortable.ini within its directory.  If you are happy with the default options, it is not necessary, though.  There is an example INI included with this package to get you started.  The INI file is formatted as follows:

[NvuPortable]
NvuDirectory=App\Nvu
ProfileDirectory=Data\profile
PluginsDirectory=Data\plugins
SettingsDirectory=Data\settings
NvuExecutable=Nvu.exe
AdditionalParameters=
DisableSplashScreen=false
DisableIntelligentStart=false
AllowMultipleInstances=false
SkipChromeFix=false
SkipCompregFix=false
WaitForNvu=false
RunLocally=false

NOTE: For KompoZer, just substritue KompoZer for Nvu in the INI.

The NvuDirectory, ProfileDrectory, PluginsDirectory and SettingsDirectory entries should be set to the *relative* path to the directories containing Nvu.exe, your profile, your plugins, etc. from the current directory.  All must be a subdirectory (or multiple subdirectories) of the directory containing NvuPortable.exe.  The default entries for these are described in the installation section above.

The NvuExecutable entry allows you to set the Nvu Portable Launcher to use an alternate EXE call to launch Nvu.  This is helpful if you are using a machine that is set to deny Nvu.exe from running.  You'll need to rename the Nvu.exe file and then enter the name you gave it on the Nvuexecutable= line of the INI.

The AdditionalParameters entry allows you to pass additional commandline parameter entries to Nvu.exe.  Whatever you enter here will be appended to the call to Nvu.exe.

The DisableSplashScreen entry allows you to run the Nvu Portable Launcher without the splash screen showing up.  The default is false.

The DisableIntelligentStart entry allows you to to have Nvu Portable run its chrome
and component registry fixes on every start.  Normally, it tracks when you've moved to a
new path (switching PCs for instance) and only processes the chrome and component
registry when you do.  By skipping it when the path is the same, Nvu Portable starts
up faster.  But, if you copy a profile into Nvu Portable between sessions (it handles
a copy in on first run automatically), it won't know to process these.  This usually
happens if you copy a profile into Nvu Portable from your local PC on a regular basis
with a sync utility that doesn't work with Nvu Portable (like Portable Apps Sync
does).  Setting this to true causes Nvu Portable to process each on every start.

The AllowMultipleInstances entry will allow Nvu Portable to run alongside your regular local copy of Nvu if you set it to true (lowercase).  The default is false.

The SkipChromeFix entry allows you to set Nvu Portable not to adjust the chrome.rdf for extension compatibility on launch.  It is useful if you are only using Nvu Portable on computers you control and are able to have the drive letter set the same each time as Nvu Portable will launch more quickly.  Set it to true (lowercase) to skip chrome.rdf processing.  The default is false.

The SkipCompregFix entry allows you to set Nvu Portable not to adjust the component registry (compreg.dat) for certain extension compatibility on launch.  It is useful if you are only using Nvu Portable on computers you control and are able to have the drive letter set the same each time or if you are not using extensions which make use of the component registry (like Forecast Fox or the Mozilla Calendar) as Nvu Portable will launch more quickly.  Set it to true (lowercase) to skip chrome.rdf processing.  The default is false.

The WaitForNvu entry allows you to set the Nvu Portable Launcher to wait for Nvu to close before it closes.  This option is mainly of use when NvuPortable.exe is called by another program that awaits it's conclusion to perform a task.  WaitForNvu does not currently work with AllowMultipleInstances as it cannot track which version of Nvu is running.

The RunLocally entry allows you to set Nvu Portable to copy your profile, plugins and Nvu binaries to the local machine's temp directory.  This can be useful for instances where you'd like to run Nvu Portable from a CD (aka Nvu Portable Live) or when you're working on a machine that may have spyware or viruses and you'd like to keep your device set to read-only mode.  The only caveat is, of course, that any changes you make that session (cookies, bookmarks, etc) aren't saved back to your device.  When done running, the local temp directories used by Nvu Portable are removed.  Setting RunLocally to true automatically sets WaitForNvu to true.  RunLocally does not currently work with AllowMultipleInstances as it cannot track which version of Nvu is running.


PROGRAM HISTORY / ABOUT THE AUTHORS
===================================
This launcher contains elements from multiple sources.  It began as a batch file launcher written by myself (John T. Haller) and posted to the mozillaZine.org thread about running Nvu from a USB key.  tracon later released a launcher called fflaunch which I enhanced and re-released as Nvu Portable.  mai9 later improved on fflaunch's techniques and released it as Free The Fox.  Multiple suggestions back and forth as well as improvements from mai9, myself and others lead to the launcher we have today.  This most recent version adds some of mai9's methods for running multiple copies of Nvu and my methods for allowing the code to be run from anywhere on first launch (as opposed to a specific directory), pass in commandline options, run without an ini file and allow the use of profiles from local installations.