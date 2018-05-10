;Copyright (C) 2006-2018 John T. Haller

;Website: http://PortableApps.com/Installer

;This software is OSI Certified Open Source Software.
;OSI Certified is a certification mark of the Open Source Initiative.

;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;as published by the Free Software Foundation; either version 2
;of the License, or (at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

!define APPNAME "PortableApps.com Installer"
!define VER "3.5.7.0"
!define WEBSITE "PortableApps.com/Installer"
!define FRIENDLYVER "3.5.7"
!define PORTABLEAPPS.COMFORMATVERSION "3.5"

;=== Program Details
Name "${APPNAME}"
OutFile "..\..\PortableApps.comInstaller.exe"
Caption "${APPNAME}"
VIProductVersion "${VER}"
VIAddVersionKey ProductName "${APPNAME}"
VIAddVersionKey Comments "For additional details, visit ${WEBSITE}"
VIAddVersionKey CompanyName "PortableApps.com"
VIAddVersionKey LegalCopyright "John T. Haller"
VIAddVersionKey FileDescription "${APPNAME}"
VIAddVersionKey FileVersion "${VER}"
VIAddVersionKey ProductVersion "${VER}"
VIAddVersionKey InternalName "${APPNAME}"
VIAddVersionKey LegalTrademarks "PortableApps.com is a trademark of Rare Ideas, LLC."
VIAddVersionKey OriginalFilename "PortableApps.comInstaller.exe"

;=== Runtime Switches
Unicode true
ManifestDPIAware true
CRCCheck On
RequestExecutionLevel user
SetCompress Auto
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize On

;=== Include
;(Standard)
!include WordFunc.nsh
!insertmacro WordReplace
!include FileFunc.nsh
!insertmacro GetFileName
!insertmacro GetParameters
!insertmacro GetParent
!insertmacro GetSize
!include LogicLib.nsh
!include MUI2.nsh
!include nsDialogs.nsh

;(Custom)
!include MoveFiles.nsh
!include ReadINIStrWithDefault.nsh
!include TBProgress.nsh

;=== Icon & Stye ===
!define MUI_ICON "..\..\App\AppInfo\appicon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP header.bmp
!define MUI_HEADERIMAGE_BITMAP_RTL header_rtl.bmp

BrandingText "PortableApps.com®"
InstallButtonText "Go >"
ShowInstDetails show
SubCaption 3 " | Processing Files"

;=== Variables
;Internal
Var bolAutomaticCompile
Var bolErrorOccurred
Var bolHighContrast
Var bolInteractiveMode
Var bolPluginInstaller
Var bolSkipWelcomePage
Var bolUseExtractedIcon
Var browseOptions
Var chkInteractiveMode
Var dirAppPath
Var lblOptionsPageCreateInstaller
Var pageOptionsCustom
Var strAppInfoINIFile
Var strFinishPageText
Var strFinishPageTitle
Var strInstallAppDirectory
Var strInstallerFilename
Var strInstallerINIFile

;Direct Config Read/Write
Var APPID								;string
Var ALLLANGUAGES						;boolean
Var APPLANGUAGE							;string
Var COMMONFILESPLUGIN					;boolean
Var DISPLAYVERSION						;string
Var EULAVERSION							;integer
Var INCLUDEINSTALLERSOURCE				;boolean
Var OPTIONALCOMPONENTS					;boolean
Var OPTIONALSECTIONSELECTEDINSTALLTYPE	;string
Var PORTABLEAPPNAME						;string
Var PORTABLEAPPNAMEDOUBLEDAMPERSANDS	;string
Var PLUGINNAME							;string
Var SHORTNAME							;string

;=== Pages
;Welcome
!define MUI_WELCOMEFINISHPAGE_BITMAP welcomefinish.bmp
!define MUI_WELCOMEPAGE_TITLE "PortableApps.com Installer ${FRIENDLYVER}"
!define MUI_WELCOMEPAGE_TEXT "Welcome to the PortableApps.com Installer.$\r$\n$\r$\nThis utility allows you to create a PortableApps.com Installer package for an app in PortableApps.com Format.  Just click next and select the application to package.$\r$\n$\r$\nLICENSE: The PortableApps.com Installer can be used with open source and freeware apps provided the installer is unmodified and the app adheres to the current PortableApps.com Format Specification as published at PortableApps.com/development. It may also be used with commercial software by contacting PortableApps.com."
!define MUI_PAGE_CUSTOMFUNCTION_PRE WelcomePagePre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW WelcomePageShow
!insertmacro MUI_PAGE_WELCOME
;Options
Page custom OptionsPageShow OptionsPageLeave " | Portable App Folder Selection"
;Install
!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstallPageShow
!insertmacro MUI_PAGE_INSTFILES
;Finish
!define MUI_PAGE_CUSTOMFUNCTION_PRE FinishPagePre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW FinishPageShow
!define MUI_FINISHPAGE_TITLE "$strFinishPageTitle"
!define MUI_FINISHPAGE_TEXT "$strFinishPageText"
!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_RUN_TEXT "Test Installer"
!define MUI_FINISHPAGE_RUN_FUNCTION FinishPageRun
!define MUI_FINISHPAGE_SHOWREADME "$EXEDIR\Data\PortableApps.comInstallerLog.txt"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "View log file"
;!define MUI_FINISHPAGE_CANCEL_ENABLED - Broken in MUI2, hack below
!insertmacro MUI_PAGE_FINISH

;=== Languages
!insertmacro MUI_LANGUAGE "English"

;=== Macros
!define AppInfoFileMissingAskInsertDefault "!insertmacro AppInfoFileMissingAskInsertDefault"
!macro AppInfoFileMissingAskInsertDefault FileName FileDescription
	${IfNot} ${FileExists} "$strInstallAppDirectory\App\AppInfo\${FileName}"
	${AndIf} $bolPluginInstaller != "true"
		${If} $bolUseExtractedIcon == "true"
			!if ${FileName} == appicon.ico
			;Copy the default icon in (appicon_*.png don't get included)
			CopyFiles /SILENT "$EXEDIR\App\default_bits\${FileName}" "$strInstallAppDirectory\App\AppInfo"
			!endif
		${ElseIf} $bolInteractiveMode = true
		${AndIf} ${Cmd} ${|} MessageBox MB_ICONQUESTION|MB_YESNO "The app does not have ${FileDescription} (${FileName}) in the App\AppInfo directory.  Would you like to use a default icon for test purposes for now?" IDYES ${|}
			CopyFiles /SILENT "$EXEDIR\App\default_bits\${FileName}" "$strInstallAppDirectory\App\AppInfo"
			MessageBox MB_ICONINFORMATION "Before releasing this application, please be sure to create a proper ${FileName} app icon in App\AppInfo."
		${Else}
			${WriteErrorToLog} "No ${FileName} in $strInstallAppDirectory\App\AppInfo."
		${EndIf}
	${EndIf}
!macroend

!define GetLicenseValueFromAppInfo "!insertmacro GetLicenseValueFromAppInfo"
!macro GetLicenseValueFromAppInfo Key Prompt
	ReadINIStr $1 $strAppInfoINIFile License ${Key}
	${If} $1 == ""
		${If} $bolInteractiveMode = true
			${If} ${Cmd} ${|} MessageBox MB_ICONQUESTION|MB_YESNO "License Question: ${Prompt}" IDYES ${|}
				StrCpy $1 "true"
			${Else}
				StrCpy $1 "false"
			${EndIf}
			WriteINIStr $strAppInfoINIFile License ${Key} $1
		${EndIf}
	${EndIf}
!macroend

!define GetValueFromAppInfo "!insertmacro GetValueFromAppInfo"
!macro GetValueFromAppInfo Section Key Prompt DefaultValue Variable Required
	ReadINIStr ${Variable} $strAppInfoINIFile ${Section} ${Key}
	${If} ${Variable} == ""
		${If} $bolInteractiveMode = true
			;${InputTextBox} "${APPNAME}" "${Prompt}" "${DefaultValue}" "255" "OK" "Cancel" 9
			StrCpy $9 "${DefaultValue}"
			DialogsW::InputBox 0 "${APPNAME}" "${Prompt}" "OK" "Cancel" 8 9
			${If} $8 == 1 ;OK was pressed
				StrCpy ${Variable} $9
				WriteINIStr $strAppInfoINIFile ${Section} ${Key} $9
			!if ${Required} == required
			${Else}
				${WriteErrorToLog} "AppInfo.ini - ${Section} - ${Key} is missing."
			!endif
			${EndIf}
		!if ${Required} == required
		${Else}
			${WriteErrorToLog} "AppInfo.ini - ${Section} - ${Key} is missing."
		!endif
		${EndIf}
	${EndIf}
!macroend

!define PageHeaderHackForHighContrast "!insertmacro PageHeaderHackForHighContrast"
!macro PageHeaderHackForHighContrast
	!if ${MUI_SYSVERSION} >= 2
		SetCtlColors $mui.Header.Text 0x000000 0xFFFFFF
		SetCtlColors $mui.Header.SubText 0x000000 0xFFFFFF
	!else
		Push $0
		FindWindow $0 "#32770" "" $HWNDPARENT
		GetDlgItem $0 $HWNDPARENT 1037
		SetCtlColors $0 0x000000 0xFFFFFF
		GetDlgItem $0 $HWNDPARENT 1038
		SetCtlColors $0 0x000000 0xFFFFFF
		Pop $0
	!endif
!macroend

!define SetIndividualLanguage "!insertmacro SetIndividualLanguage"
!macro SetIndividualLanguage IndividualLanguage
	StrCpy $2 "${IndividualLanguage}"
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "Languages" "$2" "false"
	${If} $1 == "true"
	${OrIf} $ALLLANGUAGES == "true"
		${WriteConfig} USES_$2 "true"
	${EndIf}
!macroend

!define TransferInstallerINIToConfig "!insertmacro TransferInstallerINIToConfig"
!macro TransferInstallerINIToConfig Section Key Required
	${ReadINIStrWithDefault} $1 $strInstallerINIFile ${Section} ${Key} ""
	${If} $1 != ""
		${WriteConfig} ${Key} "$1"
	!if ${Required} == required
	${Else}
		${WriteErrorToLog} "Installer.ini - ${Section} - ${Key} is missing."
	!endif
	${EndIf}
!macroend

!define WriteConfig "!insertmacro WriteConfig"
!macro WriteConfig Variable Value
	FileWriteUTF16LE $0 `!define ${Variable} "${Value}"$\r$\n`
!macroend

!define WriteErrorToLog "!insertmacro WriteErrorToLog"
!macro WriteErrorToLog ErrorToWrite
	FileOpen $9 "$EXEDIR\Data\PortableApps.comInstallerLog.txt" a
	FileSeek $9 0 END
	FileWriteUTF16LE $9 `ERROR: ${ErrorToWrite}$\r$\n`
	FileClose $9
	StrCpy $bolErrorOccurred "true"
!macroend


;=== Main and Page Functions
Function .onInit
	;=== Check for high contrast mode from platform
	ReadEnvStr $bolHighContrast "PortableApps.comHighContrast"
	
	;=== Check for settings.ini
	${IfNot} ${FileExists} $EXEDIR\Data\settings.ini
		CreateDirectory $EXEDIR\Data
		CopyFiles /SILENT $EXEDIR\App\DefaultData\settings.ini $EXEDIR\Data
	${EndIf}

	; Get settings
	ReadINIStr $bolSkipWelcomePage "$EXEDIR\Data\settings.ini" "InstallerWizard" "SkipWelcomePage"
	ReadINIStr $strInstallAppDirectory "$EXEDIR\Data\settings.ini" "InstallerWizard" "INSTALLAPPDIRECTORY"

	${GetParameters} $R0
	${If} $R0 != ""
		StrCpy $strInstallAppDirectory $R0
		StrCpy $bolSkipWelcomePage "true"
		StrCpy $bolAutomaticCompile "true"
		;Strip quotes from $strInstallAppDirectory
		StrCpy $R0 $strInstallAppDirectory 1
		${If} $R0 == `"`
			StrCpy $strInstallAppDirectory $strInstallAppDirectory "" 1
			StrCpy $strInstallAppDirectory $strInstallAppDirectory -1
		${EndIf}
	${EndIf}

	;=== Pre-Fill Path with Directory
	;WriteINIStr $PLUGINSDIR\InstallerWizardForm.ini "Field 2" "State" "$strInstallAppDirectory"
FunctionEnd

Function WelcomePagePre
	${If} $bolSkipWelcomePage == "true"
		Abort
	${EndIf}
FunctionEnd

Function WelcomePageShow
	SetCtlColors $mui.WelcomePage.Title 0x000000 0xFFFFFF
	SetCtlColors $mui.WelcomePage.Text 0x000000 0xFFFFFF
FunctionEnd

Function OptionsPageShow
	!insertmacro MUI_HEADER_TEXT "PortableApps.com Installer ${FRIENDLYVER}" "the open portable software standard"
	
	${PageHeaderHackForHighContrast}
	
	${If} $bolAutomaticCompile == "true"
		${If} ${FileExists} "$strInstallAppDirectory\App\AppInfo\appinfo.ini"
			StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\appinfo.ini"
			StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\installer.ini"
			StrCpy $bolPluginInstaller "false"
			Abort
		${ElseIf} ${FileExists} "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $bolPluginInstaller "true"
			Abort
		${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\plugininstaller.ini"
			CreateDirectory "$strInstallAppDirectory\App"
			CreateDirectory "$strInstallAppDirectory\App\AppInfo"
			Rename "$strInstallAppDirectory\Other\Source\plugininstaller.ini" "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
			StrCpy $bolPluginInstaller "true"
			Abort
		${EndIf}
	${EndIf}
	${ReadINIStrWithDefault} $0 "$EXEDIR\Data\settings.ini" "InstallerWizard" "InteractiveMode" "1"
	${If} $0 == 1
		StrCpy $bolInteractiveMode true
	${Else}
		StrCpy $bolInteractiveMode false
	${EndIf}
	
	nsDialogs::Create 1018
	Pop $pageOptionsCustom
	
	${NSD_CreateLabel} 0 0 100% 13u "Create Installer For:"
	Pop $lblOptionsPageCreateInstaller
	
	${NSD_CreateDirRequest} 0 13u 84% 13u "Choose directory"
	Pop $dirAppPath
	${NSD_SetText} $dirAppPath $strInstallAppDirectory
	
	${NSD_CreateBrowseButton} 85% 13u 15% 13u "Browse..."
    Pop $browseOptions
    ${NSD_OnClick} $browseOptions OptionsPageBrowse
	
	${NSD_CreateCheckbox} 0 30u 100% 13u "Interactive Mode (prompts for missing information)"
	Pop $chkInteractiveMode
	
	${If} $bolInteractiveMode == true
		${NSD_Check} $chkInteractiveMode
	${Else}
		${NSD_Uncheck} $chkInteractiveMode
	${EndIf}

	nsDialogs::Show
FunctionEnd

Function OptionsPageBrowse
	${NSD_GetText} $dirAppPath $0
	${IfNot} ${FileExists} "$0\*.*"
		${GetParent} $0 $0
		${IfNot} ${FileExists} "$0\*.*"
			StrCpy $0 $EXEDIR
		${EndIf}
	${EndIf}
	nsDialogs::SelectFolderDialog /NOUNLOAD "Directory" $0
    Pop $0
    ${If} $0 == error
    ${Else}
        ${NSD_SetText} $dirAppPath $0
    ${EndIf}
FunctionEnd

Function OptionsPageLeave
	;=== Blank
	${NSD_GetText} $dirAppPath $strInstallAppDirectory
	
	${NSD_GetState} $chkInteractiveMode $0
	
	${If} $0 == ${BST_CHECKED}
		StrCpy $bolInteractiveMode true
	${Else}
		StrCpy $bolInteractiveMode false
	${EndIf}
	
	
	StrCmp $strInstallAppDirectory "" NoInstallAppDirectoryError
	${If} ${FileExists} "$strInstallAppDirectory\App\AppInfo\appinfo.ini"
		StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\appinfo.ini"
		StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\installer.ini"
		StrCpy $bolPluginInstaller "false"
	${ElseIf} ${FileExists} "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $bolPluginInstaller "true"
	${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\plugininstaller.ini"
		CreateDirectory "$strInstallAppDirectory\App"
		CreateDirectory "$strInstallAppDirectory\App\AppInfo"
		Rename "$strInstallAppDirectory\Other\Source\plugininstaller.ini" "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $strAppInfoINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $strInstallerINIFile "$strInstallAppDirectory\App\AppInfo\plugininstaller.ini"
		StrCpy $bolPluginInstaller "true"
	${ElseIf} $bolInteractiveMode = true
		; No AppInfo found
		${IfNot} ${FileExists} "$strInstallAppDirectory\*.exe"
		${AndIf} $bolPluginInstaller != "true"
			Goto NoInstallAppDirectoryError
		${EndIf}

		MessageBox MB_ICONQUESTION|MB_YESNO "The app does not appear to have the necessary files within the App\AppInfo directory required by PortableApps.com Format.  Would you like to create the settings interactively and use a set of default icons for now for testing?" IDNO NoInstallAppDirectoryError

			;Find EXE file
			FindFirst $2 $3 "$strInstallAppDirectory\*.exe"
			StrCpy $4 0

			${DoWhile} $3 != ""
				StrCpy $5 $3
				IntOp $4 $4 + 1
				FindNext $2 $3
			${Loop}
			FindClose $2

			${If} $4 > 1
				MessageBox MB_OK|MB_ICONEXCLAMATION `Multiple EXEs were found in the directory you selected.  The PortableApps.com Installer can only generate default information for applications with a single EXE.  Please review the information at PortableApps.com/development for details on creating the configuration files.`
				Abort
			${EndIf}

			CreateDirectory "$strInstallAppDirectory\App\AppInfo"
			CopyFiles /SILENT "$EXEDIR\App\default_bits\appicon_16.png" "$strInstallAppDirectory\App\AppInfo"
			CopyFiles /SILENT "$EXEDIR\App\default_bits\appicon_32.png" "$strInstallAppDirectory\App\AppInfo"
			CopyFiles /SILENT "$EXEDIR\App\default_bits\appicon.ico" "$strInstallAppDirectory\App\AppInfo"
			CopyFiles /SILENT "$EXEDIR\App\default_bits\appinfo.ini" "$strInstallAppDirectory\App\AppInfo"
			WriteINIStr "$strInstallAppDirectory\App\AppInfo\appinfo.ini" "Format" "Version" "${PORTABLEAPPS.COMFORMATVERSION}"
			WriteINIStr "$strInstallAppDirectory\App\AppInfo\appinfo.ini" "Control" "Start" "$5"

			MessageBox MB_ICONINFORMATION "Before releasing this application, please be sure to create a set of proper icons in App\AppInfo."
	${Else}
		Goto NoInstallAppDirectoryError
	${EndIf}

	; Store settings
	WriteINIStr "$EXEDIR\Data\settings.ini" "InstallerWizard" "INSTALLAPPDIRECTORY" $strInstallAppDirectory
	${If} $bolInteractiveMode == true
		WriteINIStr "$EXEDIR\Data\settings.ini" "InstallerWizard" "InteractiveMode" 1
	${Else}
		WriteINIStr "$EXEDIR\Data\settings.ini" "InstallerWizard" "InteractiveMode" 0
	${EndIf}
	Goto EndLeaveOptionsWindow

	NoInstallAppDirectoryError:
		MessageBox MB_OK|MB_ICONEXCLAMATION `Please select a valid portable app's base directory to create an installer for.`
		Abort

	EndLeaveOptionsWindow:
FunctionEnd

Function InstallPageShow
	${PageHeaderHackForHighContrast}
FunctionEnd

Section Main
	!insertmacro MUI_HEADER_TEXT "PortableApps.com Installer ${FRIENDLYVER}" "the open portable software standard"
	${TBProgress} 33
	SetDetailsPrint ListOnly
	DetailPrint "App: $strInstallAppDirectory"
	DetailPrint " "
	;FindWindow $0 "#32770" "" $HWNDPARENT
	;FindWindow $1 "msctls_progress32" "" $0
	
	;DetailPrint "Handle: $1"
	${If} $bolAutomaticCompile != "true"
		;Work around for bug where Finish auto-closes and doesn't call OnGUIEnd
		RealProgress::SetProgress /NOUNLOAD 1
		RealProgress::GradualProgress /NOUNLOAD 2 1 90 "Processing complete."
	${EndIf}
	DetailPrint "Generating installer code..."
	SetDetailsPrint none

	;Ensure the source directory exists
	CreateDirectory "$strInstallAppDirectory\Other\Source"

	;Remove any existing installer files (leaving custom intact)
	RMDir /r "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerLanguages"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.bmp"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.ico"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.nsi"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig-EXAMPLE.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerDumpLogToFile.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeader.bmp"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerMoveFiles.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerStrRep.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeaderRTL.bmp"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPlugin.nsi"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPluginConfig.nsh"
	Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerTBProgress.nsh"

	;Copy the current PortableApps.com Installer in
	CopyFiles /SILENT "$EXEDIR\App\installer\*.*" "$strInstallAppDirectory\Other\Source"
	${If} $bolPluginInstaller == "true"
		Rename "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.nsi" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPlugin.nsi"
		Rename "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig.nsh" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPluginConfig.nsh"
	${EndIf}

	;Generate the configuration file
	Delete "$EXEDIR\Data\PortableApps.comInstallerLog.txt"

	;Determine icon type
	${ReadINIStrWithDefault} $1 $strAppInfoINIFile "Control" "ExtractIcon" ""
	${If} $1 != ""
		StrCpy $bolUseExtractedIcon "true"
	${EndIf}

	;Check for content
	${IfNot} ${FileExists} "$strInstallAppDirectory\*.exe"
	${AndIf} $bolPluginInstaller != "true"
		${WriteErrorToLog} "No EXE in $strInstallAppDirectory."
	${EndIf}

	${IfNot} ${FileExists} "$strInstallAppDirectory\help.html"
	${AndIf} $bolPluginInstaller != "true"
		${WriteErrorToLog} "No help.html in $strInstallAppDirectory."
	${EndIf}

	${AppInfoFileMissingAskInsertDefault} appicon_16.png "a 16x16 PNG icon"
	${AppInfoFileMissingAskInsertDefault} appicon_32.png "a 32x32 PNG icon"
	${AppInfoFileMissingAskInsertDefault} appicon.ico    "an icon"

	${If} $bolPluginInstaller == "true"
		FileOpen $0 "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPluginConfig.nsh" a
	${Else}
		FileOpen $0 "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig.nsh" a
	${EndIf}
	FileSeek $0 0 END
	FileWriteUTF16LE $0 `;Code generated by PortableApps.com Installer ${FRIENDLYVER}.  DO NOT EDIT.$\r$\n$\r$\n`

	;PortableApps.comFormat Version
	${ReadINIStrWithDefault} $1 $strAppInfoINIFile "Format" "Version" ""
	${If} $1 == "0.9.8"
		;Preserve old installer config in case it's needed
		Rename "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig.nsh" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfigOld.nsh"

		;Autogenerate App ID is handled normally when interactive

		;Language selection is handled normally when in interactive

		;This brings it up to 0.90
		StrCpy $1 "0.90"
	${EndIf}
	${If} $1 == "0.90"
	${OrIf} $1 == "0.91"
	${OrIf} $1 == "1.0"
	${OrIf} $1 == "2.0"
	${OrIf} $1 == "3.0"
		;Versions from 0.90 and later can be moved forward to 3.2
		;ExtractTo must be updated to AdvancedExtractTo
		${ReadINIStrWithDefault} $2 $strInstallerINIFile "DownloadFiles" "Extract1To" ""
		${If} $2 != ""
			;Update from ExtractTo to AdvancedExtractTo
			${For} $R1 1 10
				${ReadINIStrWithDefault} $2 $strInstallerINIFile "DownloadFiles" "Extract$R1To" ""
				${If} $2 != ""
					WriteINIStr $strInstallerINIFile "DownloadFiles" "AdvancedExtract$R1To" "$2"
					${ReadINIStrWithDefault} $3 $strInstallerINIFile "DownloadFiles" "Extract$R1File" ""
					WriteINIStr $strInstallerINIFile "DownloadFiles" "AdvancedExtract$R1Filter" "$3"
					DeleteINIStr $strInstallerINIFile "DownloadFiles" "Extract$R1To"
					DeleteINIStr $strInstallerINIFile "DownloadFiles" "Extract$R1File"
				${EndIf}
			${Next}
		${EndIf}
		StrCpy $1 "3.2"
	${EndIf}
	${If} $1 == "3.2"
	${OrIf} $1 == "3.3"
	${OrIf} $1 == "3.4"
		;No changes from 3.2/3.3/3.4 to 3.5
		StrCpy $1 "3.5"
		WriteINIStr $strAppInfoINIFile "Format" "Version" "${PORTABLEAPPS.COMFORMATVERSION}"
	${EndIf}



	;App Name
	${GetValueFromAppInfo} \
		Details \
		Name \
		"Enter the portable app's name (e.g. FileZilla Portable):" \
		"AppName Portable" \
		$PORTABLEAPPNAME \
		required

	${If} $bolPluginInstaller != "true"
		${WriteConfig} PORTABLEAPPNAME "$PORTABLEAPPNAME"
		${WordReplace} $PORTABLEAPPNAME "&" "~~~@@@~~~" + $PORTABLEAPPNAMEDOUBLEDAMPERSANDS
		${WordReplace} $PORTABLEAPPNAMEDOUBLEDAMPERSANDS "~~~@@@~~~" "&&" + $PORTABLEAPPNAMEDOUBLEDAMPERSANDS
		${WriteConfig} PORTABLEAPPNAMEDOUBLEDAMPERSANDS "$PORTABLEAPPNAMEDOUBLEDAMPERSANDS"
	${EndIf}

	;Plugin Name
	${If} $bolPluginInstaller == "true"
		${GetValueFromAppInfo} \
			Details \
			PluginName \
			"Enter the plugin's name (e.g. Acme Plugin):" \
			"Plugin" \
			$PLUGINNAME \
			required

		${WriteConfig} PLUGINNAME "$PLUGINNAME"
		${WriteConfig} PORTABLEAPPNAME "$PLUGINNAME"
		${WordReplace} $PLUGINNAME "&" "~~~@@@~~~" + $PORTABLEAPPNAMEDOUBLEDAMPERSANDS
		${WordReplace} $PORTABLEAPPNAMEDOUBLEDAMPERSANDS "~~~@@@~~~" "&&" + $PORTABLEAPPNAMEDOUBLEDAMPERSANDS
		${WriteConfig} PORTABLEAPPNAMEDOUBLEDAMPERSANDS "$PORTABLEAPPNAMEDOUBLEDAMPERSANDS"
		${ReadINIStrWithDefault} $1 $strAppInfoINIFile "Details" "PluginType" "App"
		${If} $1 == "CommonFiles"
			StrCpy $COMMONFILESPLUGIN "true"
			${WriteConfig} COMMONFILESPLUGIN "true"
		${EndIf}
	${EndIf}


	;App ID
	${WordReplace} $PORTABLEAPPNAME " "   ""  + $8
	${WordReplace} $8               " "   "_" + $8
	${WordReplace} $8               "("   ""  + $8
	${WordReplace} $8               ")"   ""  + $8
	${WordReplace} $8               "["   ""  + $8
	${WordReplace} $8               "]"   ""  + $8
	${WordReplace} $8               "~"   "-" + $8
	${WordReplace} $8               "&"   "+" + $8
	${WordReplace} $8               "#"   "+" + $8
	${WordReplace} $8               "$\"" "-" + $8
	${WordReplace} $8               "*"   "+" + $8
	${WordReplace} $8               "/"   "_" + $8
	${WordReplace} $8               "\"   "_" + $8
	${WordReplace} $8               ":"   "." + $8
	${WordReplace} $8               "<"   "-" + $8
	${WordReplace} $8               ">"   "-" + $8
	${WordReplace} $8               "?"   ""  + $8
	${WordReplace} $8               "|"   "-" + $8
	${WordReplace} $8               "="   "-" + $8
	${WordReplace} $8               ","   "." + $8
	${WordReplace} $8               ";"   "." + $8
	${GetValueFromAppInfo} \
		Details \
		AppID \
		"Enter the portable app's App ID (usually the name with no spaces or symbols):" \
		$8 \
		$APPID \
		required

	${WriteConfig} APPID "$APPID"
	StrCpy $SHORTNAME $APPID

	;Publisher
	${GetValueFromAppInfo} \
		Details \
		Publisher \
		"Enter the publisher ('App Developer && PortableApps.com' for our apps):" \
		"No Publisher Specified" \
		$1 \
		optional

	;Homepage
	${GetValueFromAppInfo} \
		Details \
		Homepage \
		"Enter the app's homepage (e.g. portableapps.com):" \
		"example.com" \
		$1 \
		optional

	;Category
	${GetValueFromAppInfo} \
		Details \
		Category \
		"Enter the app's category *exactly* (Accessibility, Development, Education, Games, Graphics && Pictures, Internet, Music && Video, Office, Operating Systems, Utilities):" \
		"" \
		$1 \
		optional

	;Description
	${GetValueFromAppInfo} \
		Details \
		Description \
		"Enter the app's description (e.g. Simple FTP program.):" \
		"" \
		$1 \
		optional

	;Language
	${GetValueFromAppInfo} \
		Details \
		Language \
		"Enter the portable app's language as expected by NSIS (e.g. English or Multilingual):" \
		"English" \
		$APPLANGUAGE \
		optional
	${If} $APPLANGUAGE == ""
		StrCpy $APPLANGUAGE "English"
	${EndIf}

	;License
	${GetLicenseValueFromAppInfo} Shareable     "Can this application be legally shared from one user to another?"
	${GetLicenseValueFromAppInfo} OpenSource    "Is this application 100% open source under an OSI-approved license?"
	${GetLicenseValueFromAppInfo} Freeware      "Is this application freeware (it can be used without payment)?"
	${GetLicenseValueFromAppInfo} CommercialUse "Can this app be used in a commercial environment?"

	;EULA Version
	${ReadINIStrWithDefault} $EULAVERSION $strAppInfoINIFile "License" "EULAVersion" ""

	;Display Version
	${GetValueFromAppInfo} \
		Version \
		DisplayVersion \
		"Enter the portable app's display version (e.g. 1.0 or 2.2 Beta 1):" \
		"0.1" \
		$DISPLAYVERSION \
		required

	;Package Version
	${GetValueFromAppInfo} \
		Version \
		PackageVersion \
		"Enter the portable app's package version as all numbers in the form X.X.X.X (e.g. 1.0.0.0 or 2.2.0.1):" \
		"0.1.0.0" \
		$1 \
		required

	${WriteConfig} VERSION "$1"

	;Filename should only be alpha, numbers as well as:  + . - _
	${If} $bolPluginInstaller == "true"
		StrCpy $strInstallerFilename "$PLUGINNAME_$DISPLAYVERSION"
	${Else}
		StrCpy $strInstallerFilename "$APPID_$DISPLAYVERSION"
	${EndIf}

	${If} $APPLANGUAGE != "Multilingual"
		StrCpy $strInstallerFilename "$strInstallerFilename_$APPLANGUAGE"
	${EndIf}

	${WordReplace} $strInstallerFilename " "   "_"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "("   ""     + $strInstallerFilename
	${WordReplace} $strInstallerFilename ")"   ""     + $strInstallerFilename
	${WordReplace} $strInstallerFilename "["   ""     + $strInstallerFilename
	${WordReplace} $strInstallerFilename "]"   ""     + $strInstallerFilename
	${WordReplace} $strInstallerFilename "~"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "&"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "#"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "$\"" "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "*"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "/"   "_"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "\"   "_"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename ":"   "."    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "<"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename ">"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "?"   ""     + $strInstallerFilename
	${WordReplace} $strInstallerFilename "|"   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "="   "-"    + $strInstallerFilename
	${WordReplace} $strInstallerFilename ","   "."    + $strInstallerFilename
	${WordReplace} $strInstallerFilename ";"   "."    + $strInstallerFilename
	${WordReplace} $strInstallerFilename "+"   "Plus" + $strInstallerFilename

	${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "DownloadURL" ""
	${If} $1 != ""
		StrCpy $strInstallerFilename "$strInstallerFilename_online"
	${EndIf}

	${WriteConfig} FILENAME "$strInstallerFilename"

	
	${ReadINIStrWithDefault} $1 $strAppInfoINIFile "Control" "Start" ""
		${If} $1 == ""
		${WriteErrorToLog} "AppInfo.ini - Control - Start is missing."
	${Else}
		${WriteConfig} FINISHPAGERUN "$1"
	${EndIf}
	${IfNot} ${FileExists} "$strInstallAppDirectory\$1"
	${AndIf} $bolPluginInstaller != "true"
		${WriteErrorToLog} "AppInfo.ini - Control - Start=$1, file is missing."
	${EndIf}

	${ReadINIStrWithDefault} $2 $strInstallerINIFile "CheckRunning" "CloseEXE" "$1"
	${WriteConfig} CHECKRUNNING "$2"
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "CheckRunning" "CloseName" "$PORTABLEAPPNAME"
	${WriteConfig} CLOSENAME "$1"
	${ReadINIStrWithDefault} $1 $strAppInfoINIFile "SpecialPaths" "Plugins" "NONE"
	${WriteConfig} ADDONSDIRECTORYPRESERVE "$1"
	${WriteConfig} INSTALLERCOMMENTS "For additional details, visit PortableApps.com"
	${ReadINIStrWithDefault} $1 $strAppInfoINIFile "Details" "Trademarks" ""
	${If} $1 != ""
		;Replace double quotes with single quotes
		${WordReplace} $1 '"' "'" "+" $1
		WriteINIStr $strAppInfoINIFile "Details" "Trademarks" $1
		StrCpy $1 "$1. "
	${EndIf}
	${WriteConfig} INSTALLERADDITIONALTRADEMARKS "$1"

	;Source Code
	${ReadINIStrWithDefault} $INCLUDEINSTALLERSOURCE $strInstallerINIFile "Source" "IncludeInstallerSource" "false"
	${If} $INCLUDEINSTALLERSOURCE == "true"
		${WriteConfig} INCLUDEINSTALLERSOURCE "true"
	${EndIf}

	;Languages
	${If} $APPLANGUAGE != "Multilingual"
		${WriteConfig} INSTALLERLANGUAGE "$APPLANGUAGE"
	${Else}
		${WriteConfig} INSTALLERMULTILINGUAL "true"

		${ReadINIStrWithDefault} $1 $strInstallerINIFile "Languages" "English" ""
		${If} $1 == ""
			StrCpy $ALLLANGUAGES "true"
		${EndIf}

		${SetIndividualLanguage} "ENGLISH"
		${SetIndividualLanguage} "ENGLISHGB"
		${SetIndividualLanguage} "AFRIKAANS"
		${SetIndividualLanguage} "ALBANIAN"
		${SetIndividualLanguage} "ARABIC"
		${SetIndividualLanguage} "ARMENIAN"
		${SetIndividualLanguage} "ASTURIAN"
		${SetIndividualLanguage} "BASQUE"
		${SetIndividualLanguage} "BELARUSIAN"
		${SetIndividualLanguage} "BOSNIAN"
		${SetIndividualLanguage} "BRETON"
		${SetIndividualLanguage} "BULGARIAN"
		${SetIndividualLanguage} "CATALAN"
		${SetIndividualLanguage} "CIBEMBA"
		${SetIndividualLanguage} "CROATIAN"
		${SetIndividualLanguage} "CZECH"
		${SetIndividualLanguage} "DANISH"
		${SetIndividualLanguage} "DUTCH"
		${SetIndividualLanguage} "EFIK"
		${SetIndividualLanguage} "ESPERANTO"
		${SetIndividualLanguage} "ESTONIAN"
		${SetIndividualLanguage} "FARSI"
		${SetIndividualLanguage} "FINNISH"
		${SetIndividualLanguage} "FRENCH"
		${SetIndividualLanguage} "GALICIAN"
		${SetIndividualLanguage} "GEORGIAN"
		${SetIndividualLanguage} "GERMAN"
		${SetIndividualLanguage} "GREEK"
		${SetIndividualLanguage} "HEBREW"
		${SetIndividualLanguage} "HUNGARIAN"
		${SetIndividualLanguage} "ICELANDIC"
		${SetIndividualLanguage} "INDONESIAN"
		${SetIndividualLanguage} "IRISH"
		${SetIndividualLanguage} "ITALIAN"
		${SetIndividualLanguage} "JAPANESE"
		${SetIndividualLanguage} "KHMER"
		${SetIndividualLanguage} "KOREAN"
		${SetIndividualLanguage} "KURDISH"
		${SetIndividualLanguage} "LATVIAN"
		${SetIndividualLanguage} "LITHUANIAN"
		${SetIndividualLanguage} "LUXEMBOURGISH"
		${SetIndividualLanguage} "MACEDONIAN"
		${SetIndividualLanguage} "MALAGASY"
		${SetIndividualLanguage} "MALAY"
		${SetIndividualLanguage} "MONGOLIAN"
		${SetIndividualLanguage} "NORWEGIAN"
		${SetIndividualLanguage} "NORWEGIANNYNORSK"
		${SetIndividualLanguage} "PASHTO"
		${SetIndividualLanguage} "POLISH"
		${SetIndividualLanguage} "PORTUGUESE"
		${SetIndividualLanguage} "PORTUGUESEBR"
		${SetIndividualLanguage} "ROMANIAN"
		${SetIndividualLanguage} "RUSSIAN"
		${SetIndividualLanguage} "SERBIAN"
		${SetIndividualLanguage} "SERBIANLATIN"
		${SetIndividualLanguage} "SIMPCHINESE"
		${SetIndividualLanguage} "SLOVAK"
		${SetIndividualLanguage} "SLOVENIAN"
		${SetIndividualLanguage} "SPANISH"
		${SetIndividualLanguage} "SPANISHINTERNATIONAL"
		${SetIndividualLanguage} "SWAHILI"
		${SetIndividualLanguage} "SWEDISH"
		${SetIndividualLanguage} "THAI"
		${SetIndividualLanguage} "TRADCHINESE"
		${SetIndividualLanguage} "TURKISH"
		${SetIndividualLanguage} "UKRAINIAN"
		${SetIndividualLanguage} "UZBEK"
		${SetIndividualLanguage} "VALENCIAN"
		${SetIndividualLanguage} "VIETNAMESE"
		${SetIndividualLanguage} "WELSH"
		${SetIndividualLanguage} "YORUBA"
	${EndIf}

	;EULA
	${If} $bolPluginInstaller == "true"
		${If} ${FileExists} "$strInstallAppDirectory\App\AppInfo\PluginEULA.txt"
			${WriteConfig} LICENSEAGREEMENT "PluginEULA.txt"
		${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\PluginEULA.txt"
			Rename "$strInstallAppDirectory\Other\Source\PluginEULA.txt" "$strInstallAppDirectory\App\AppInfo\PluginEULA.txt"
			${WriteConfig} LICENSEAGREEMENT "PluginEULA.txt"
		${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\PluginEULA.rtf"
			${WriteErrorToLog} "EULA - Other\Source\PluginEULA.rtf is no longer supported.  Use App\AppInfo\PluginEULA.txt instead."
		${ElseIf} ${FileExists} "$strInstallAppDirectory\App\AppInfo\PluginEULA.rtf"
			${WriteErrorToLog} "EULA - App\AppInfo\PluginEULA.rtf is not supported.  Use App\AppInfo\PluginEULA.txt instead."
		${EndIf}
	${Else}
		${If} ${FileExists} "$strInstallAppDirectory\App\AppInfo\EULA.txt"
			${WriteConfig} LICENSEAGREEMENT "eula.txt"
		${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\EULA.txt"
			Rename "$strInstallAppDirectory\Other\Source\EULA.txt" "$strInstallAppDirectory\App\AppInfo\EULA.txt"
			${WriteConfig} LICENSEAGREEMENT "eula.txt"
		${ElseIf} ${FileExists} "$strInstallAppDirectory\Other\Source\EULA.rtf"
			${WriteErrorToLog} "EULA - Other\Source\EULA.rtf is no longer supported.  Use App\AppInfo\EULA.txt instead."
		${ElseIf} ${FileExists} "$strInstallAppDirectory\App\AppInfo\EULA.rtf"
			${WriteErrorToLog} "EULA - App\AppInfo\EULA.rtf is not supported.  Use App\AppInfo\EULA.txt instead."
		${EndIf}
	${EndIf}

	${If} $EULAVERSION != ""
		${WriteConfig} EULAVERSION "$EULAVERSION"
	${EndIf}

	;OptionalComponents
	${ReadINIStrWithDefault} $OPTIONALCOMPONENTS $strInstallerINIFile "OptionalComponents" "OptionalComponents" "false"
	${If} $OPTIONALCOMPONENTS == "true"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "MainSectionTitle" "$PORTABLEAPPNAME (English) [Required]"
		${WriteConfig} MAINSECTIONTITLE "$1"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "MainSectionDescription" "Install the portable app"
		${WriteConfig} MAINSECTIONDESCRIPTION "$1"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionTitle" "Additional Languages"
		${WriteConfig} OPTIONALSECTIONTITLE "$1"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionDescription" "Add multilingual support for this app"
		${WriteConfig} OPTIONALSECTIONDESCRIPTION "$1"
		${ReadINIStrWithDefault} $OptionalSectionSelectedInstallType $strInstallerINIFile "OptionalComponents" "OptionalSectionSelectedInstallType" "Multilingual"
		${WriteConfig} OPTIONALSECTIONSELECTEDINSTALLTYPE "$OptionalSectionSelectedInstallType"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionNotSelectedInstallType" "English"
		${WriteConfig} OPTIONALSECTIONNOTSELECTEDINSTALLTYPE "$1"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionPreSelectedIfNonEnglishInstall" "true"
		${If} $1 == "true"
			${WriteConfig} OPTIONALSECTIONPRESELECTEDIFNONENGLISHINSTALL "$1"
		${EndIf}

		${If} $OptionalSectionSelectedInstallType == "Multilingual"
			${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionInstalledWhenSilent" "false"
		${Else}
			${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalSectionInstalledWhenSilent" "true"
		${EndIf}

		${If} $1 == "true"
			${WriteConfig} OPTIONALSECTIONINSTALLEDWHENSILENT "$1"
		${EndIf}
	${EndIf}

	;Main directories
	${If} $bolPluginInstaller == "true"
	${AndIf} $COMMONFILESPLUGIN != "true"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "MainDirectories" "RemoveAppDirectory" "false"
	${Else}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "MainDirectories" "RemoveAppDirectory" "true"
	${EndIf}
	${If} $1 == "true"
		${WriteConfig} REMOVEAPPDIRECTORY "true"
	${EndIf}
	${If} $bolPluginInstaller == "true"
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "MainDirectories" "RemoveOtherDirectory" "false"
	${Else}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "MainDirectories" "RemoveOtherDirectory" "true"
	${EndIf}
	${If} $1 == "true"
		${WriteConfig} REMOVEOTHERDIRECTORY "true"
	${EndIf}

	;Preserve directories
	StrCpy $R1 1
	${Do}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "DirectoriesToPreserve" "PreserveDirectory$R1" ""
		${If} $1 != ""
			${WriteConfig} PRESERVEDIRECTORY$R1 "$1"
		${EndIf}
		IntOp $R1 $R1 + 1
	${LoopUntil} $R1 > 10

	;Remove directories
	StrCpy $R1 1
	${Do}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "DirectoriesToRemove" "RemoveDirectory$R1" ""
		${If} $1 != ""
			${WriteConfig} REMOVEDIRECTORY$R1 "$1"
		${EndIf}
		IntOp $R1 $R1 + 1
	${LoopUntil} $R1 > 10

	;Preserve files
	StrCpy $R1 1
	${Do}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "FilesToPreserve" "PreserveFile$R1" ""
		${If} $1 != ""
			${WriteConfig} PRESERVEFILE$R1 "$1"
		${EndIf}
		IntOp $R1 $R1 + 1
	${LoopUntil} $R1 > 10

	;Remove files
	StrCpy $R1 1
	${Do}
		${ReadINIStrWithDefault} $1 $strInstallerINIFile "FilesToRemove" "RemoveFile$R1" ""
		${If} $1 != ""
			${WriteConfig} REMOVEFILE$R1 "$1"
		${EndIf}
		IntOp $R1 $R1 + 1
	${LoopUntil} $R1 > 10

	;Custom code
	${If} $bolPluginInstaller == "true"
		StrCpy $9 "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPluginCustom.nsh"
	${Else}
		StrCpy $9 "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerCustom.nsh"
	${EndIf}
	${If} ${FileExists} $9
		${WriteConfig} USESCUSTOMCODE "true"
	${EndIf}

	;Local Files
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "CopyLocalFiles" "CopyLocalFiles" "false"
	${If} $1 == "true"
		${WriteConfig} COPYLOCALFILES "true"

		${TransferInstallerINIToConfig} CopyLocalFiles CopyFromRegPath -
		${TransferInstallerINIToConfig} CopyLocalFiles CopyFromRegKey -
		${TransferInstallerINIToConfig} CopyLocalFiles CopyFromRegRemoveDirectories -
		${TransferInstallerINIToConfig} CopyLocalFiles CopyFromDirectory -
		${TransferInstallerINIToConfig} CopyLocalFiles CopyToDirectory -
	${EndIf}

	;Download files
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "DownloadURL" ""
	${If} $1 != ""
		StrCpy $2 $1 7
		StrCpy $3 $1 8

		${If} $2 == "http://"
		${OrIf} $3 == "https://"
		
			${WriteConfig} DownloadURL "$1"

			${TransferInstallerINIToConfig} DownloadFiles DownloadKnockURL      -
			${TransferInstallerINIToConfig} DownloadFiles DownloadName          required
			${TransferInstallerINIToConfig} DownloadFiles DownloadFilename      required
			${TransferInstallerINIToConfig} DownloadFiles DownloadMD5           -
			${TransferInstallerINIToConfig} DownloadFiles DownloadTo            -
			${TransferInstallerINIToConfig} DownloadFiles DownloadCachedByPAc   -
			${TransferInstallerINIToConfig} DownloadFiles AdditionalInstallSize required

			${For} $R1 1 10
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "AdvancedExtract$R1To" ""
				${If} $1 != ""
					${If} $1 == "<ROOT>"
						StrCpy $1 ""
					${EndIf}
					${WriteConfig} AdvancedExtract$R1To "$1"
				${EndIf}
			${Next}

			${For} $R1 1 10
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "AdvancedExtract$R1Filter" ""
				${If} $1 != ""
					${WriteConfig} AdvancedExtract$R1Filter "$1"
				${EndIf}
			${Next}

			${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "DoubleExtractFilename" ""
			${If} $1 != ""
				${WriteConfig} DoubleExtractFilename "$1"

				${For} $R1 1 10
					${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "DoubleExtract$R1To" ""
					${If} $1 != ""
						${If} $1 == "<ROOT>"
							StrCpy $1 ""
						${EndIf}
						${WriteConfig} DoubleExtract$R1To "$1"
					${EndIf}
				${Next}

				${For} $R1 1 10
					${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "DoubleExtract$R1Filter" ""
					${If} $1 != ""
						${WriteConfig} DoubleExtract$R1Filter "$1"
					${EndIf}
				${Next}

			${EndIf}
		${Else}
			${WriteErrorToLog} "Installer.ini - DownloadFiles - DownloadURL must begin with http://"
		${EndIf}
	${EndIf}
	
	;Download2 files
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2URL" ""
	${If} $1 != ""
		StrCpy $2 $1 7
		StrCpy $3 $1 8

		${If} $2 == "http://"
		${OrIf} $3 == "https://"
		
			${WriteConfig} Download2URL "$1"

			${TransferInstallerINIToConfig} DownloadFiles Download2KnockURL      -
			${TransferInstallerINIToConfig} DownloadFiles Download2Name          required
			${TransferInstallerINIToConfig} DownloadFiles Download2Filename      required
			${TransferInstallerINIToConfig} DownloadFiles Download2MD5           -
			${TransferInstallerINIToConfig} DownloadFiles Download2To            -
			${TransferInstallerINIToConfig} DownloadFiles Download2CachedByPAc   -

			${For} $R1 1 10
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2AdvancedExtract$R1To" ""
				${If} $1 != ""
					${If} $1 == "<ROOT>"
						StrCpy $1 ""
					${EndIf}
					${WriteConfig} Download2AdvancedExtract$R1To "$1"
				${EndIf}
			${Next}

			${For} $R1 1 10
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2AdvancedExtract$R1Filter" ""
				${If} $1 != ""
					${WriteConfig} Download2AdvancedExtract$R1Filter "$1"
				${EndIf}
			${Next}

			${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2DoubleExtractFilename" ""
			${If} $1 != ""
				${WriteConfig} Download2DoubleExtractFilename "$1"

				${For} $R1 1 10
					${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2DoubleExtract$R1To" ""
					${If} $1 != ""
						${If} $1 == "<ROOT>"
							StrCpy $1 ""
						${EndIf}
						${WriteConfig} Download2DoubleExtract$R1To "$1"
					${EndIf}
				${Next}

				${For} $R1 1 10
					${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "Download2DoubleExtract$R1Filter" ""
					${If} $1 != ""
						${WriteConfig} Download2DoubleExtract$R1Filter "$1"
					${EndIf}
				${Next}

			${EndIf}
		${Else}
			${WriteErrorToLog} "Installer.ini - DownloadFiles - Download2URL must begin with http://"
		${EndIf}
	${EndIf}
	
	${ReadINIStrWithDefault} $1 $strInstallerINIFile "DownloadFiles" "CustomCodeUses7zip" "false"
	${If} $1 == "true"
		${WriteConfig} CustomCodeUses7zip "true"
	${EndIf}

	FileClose $0

	; If errors have occurred, there's no point in going on to the actual generation of it.
	${If} $bolErrorOccurred != "true"
		;Make the installer header
		${If} $bolPluginInstaller == "true"
			CopyFiles /SILENT "$EXEDIR\App\default_bits\PortableApps.comInstallerHeaderPlugin.bmp" "$strInstallAppDirectory\Other\Source"
			Rename "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeaderPlugin.bmp" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeader.bmp" 
			CopyFiles /SILENT "$EXEDIR\App\default_bits\PortableApps.comInstallerHeaderPluginRTL.bmp" "$strInstallAppDirectory\Other\Source"
			Rename "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeaderPluginRTL.bmp" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeaderRTL.bmp" 
		${Else}
			${If} $bolUseExtractedIcon == "true"
			${AndIfNot} ${FileExists} "$strInstallAppDirectory\App\AppInfo\appicon_32.png"
				CopyFiles /SILENT "$EXEDIR\App\default_bits\PortableApps.comInstallerHeader.bmp" "$strInstallAppDirectory\Other\Source"
				CopyFiles /SILENT "$EXEDIR\App\default_bits\PortableApps.comInstallerHeaderRTL.bmp" "$strInstallAppDirectory\Other\Source"
			${Else}
				ExecWait `"$EXEDIR\App\bin\MakeHeader.exe" "$strInstallAppDirectory"`
			${EndIf}
		${EndIf}

		;Move optional component files
		${If} $OPTIONALCOMPONENTS == "true"
			CreateDirectory "$strInstallAppDirectory\Optional1"

			;Move directories
			StrCpy $R1 1
			${Do}
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalDirectory$R1" "\COMPLETED\"
				${If} $1 != ""
				${AndIf} $1 != "\COMPLETED\"
					${GetParent} "$strInstallAppDirectory\Optional1\$1" $2
					CreateDirectory $2
					Rename "$strInstallAppDirectory\$1" "$strInstallAppDirectory\Optional1\$1"
				${EndIf}
				IntOp $R1 $R1 + 1
			${LoopUntil} $1 == "\COMPLETED\"

			;Move files
			StrCpy $R1 1
			${Do}
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalFile$R1" "\COMPLETED\"
				${If} $1 != ""
				${AndIf} $1 != "\COMPLETED\"
					${GetParent} "$strInstallAppDirectory\Optional1\$1" $2
					CreateDirectory $2
					${GetParent} "$strInstallAppDirectory\$1" $3
					${GetFileName} "$strInstallAppDirectory\Optional1\$1" $4
					${MoveFiles} DOS "$4" "$3" "$2"
				${EndIf}
				IntOp $R1 $R1 + 1
			${LoopUntil} $1 == "\COMPLETED\"

		${EndIf}

		;Compile the installer
		SetDetailsPrint ListOnly
		${If} $bolPluginInstaller == "true"
			DetailPrint "Creating $PLUGINNAME installer..."
		${Else}
			DetailPrint "Creating $PORTABLEAPPNAME installer..."
		${EndIf}
		SetDetailsPrint none
		${TBProgress} 66

		;Delete existing installer if there is one
		${GetParent} $strInstallAppDirectory $0
		Delete "$0\$strInstallerFilename.paf.exe"
		${If} ${FileExists} "$0\$strInstallerFilename.paf.exe"
			MessageBox MB_OK|MB_ICONEXCLAMATION "Unable to delete file: $0\$strInstallerFilename.paf.exe.  Please be sure the file is not in use"
			${WriteErrorToLog} "Unable to delete file: $0\$strInstallerFilename.paf.exe.  Please be sure the file is not in use."
		${Else}
			${If} ${FileExists} "$strInstallAppDirectory\App\AppInfo\appinfo.ini"
				DeleteINISec "$strInstallAppDirectory\App\AppInfo\appinfo.ini" "PortableApps.comInstaller"
			${EndIf}
			Delete "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini"
			SetOutPath "$EXEDIR\App\nsis"
			${If} $bolPluginInstaller == "true"
				ExecDos::exec `"$EXEDIR\App\nsis\makensis.exe" /O"$EXEDIR\Data\PortableApps.comInstallerLog.txt" "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPlugin.nsi"` "" ""
			${Else}
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info1" "Do not delete or modify this file. It may be necessary for this app to function correctly."
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info2" "This file was generated by the PortableApps.com Installer wizard."
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info3" "This file should be excluded from git repositories by using the appropriate gitignore."
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Run" "false"
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "WizardVersion" "${VER}"
				${GetTime} "" "L" $R0 $R1 $R2 $R3 $R4 $R5 $R6
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "PackagingDate" "$R2-$R1-$R0"
				WriteINIStr "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "PackagingTime" "$R4:$R5:$R6"
				ExecDos::exec `"$EXEDIR\App\nsis\makensis.exe" /O"$EXEDIR\Data\PortableApps.comInstallerLog.txt" "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.nsi"` "" ""
				Delete "$strInstallAppDirectory\App\AppInfo\pac_installer_log.ini"
			${EndIf}
		${EndIf}

		;Move optional component files back
		${If} $OPTIONALCOMPONENTS == "true"
			;Move directories
			StrCpy $R1 1
			${Do}
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalDirectory$R1" "\COMPLETED\"
				${If} $1 != ""
				${AndIf} $1 != "\COMPLETED\"
					Rename "$strInstallAppDirectory\Optional1\$1" "$strInstallAppDirectory\$1"
				${EndIf}
				IntOp $R1 $R1 + 1
			${LoopUntil} $1 == "\COMPLETED\"

			;Move files
			StrCpy $R1 1
			${Do}
				${ReadINIStrWithDefault} $1 $strInstallerINIFile "OptionalComponents" "OptionalFile$R1" "\COMPLETED\"
				${If} $1 != ""
				${AndIf} $1 != "\COMPLETED\"
					${GetParent} "$strInstallAppDirectory\Optional1\$1" $2
					${GetParent} "$strInstallAppDirectory\$1" $3
					${GetFileName} "$strInstallAppDirectory\Optional1\$1" $4
					${MoveFiles} DOS "$4" "$2" "$3"
				${EndIf}
				IntOp $R1 $R1 + 1
			${LoopUntil} $1 == "\COMPLETED\"

			RMDir /r "$strInstallAppDirectory\Optional1"
		${EndIf}
	${EndIf}

	; Done
	SetDetailsPrint ListOnly
	DetailPrint " "
	DetailPrint "Processing complete."

	${If} ${FileExists} "$0\$strInstallerFilename.paf.exe"
	${AndIf} $bolErrorOccurred != "true"
		StrCpy $strFinishPageTitle "Installer Created"
		StrCpy $strFinishPageText "The installer has been created. Installer location:$\r$\n$0$\r$\n$\r$\nInstaller name:$\r$\n$strInstallerFilename.paf.exe"
	${Else}
		StrCpy $strFinishPageTitle "An Error Occured"
		StrCpy $strFinishPageText "The installer was not created.  You can view the log file for more information."
		StrCpy $bolErrorOccurred "true"
	${EndIf}

	SetDetailsPrint none
	;Remove the installer files if not included
	${If} $INCLUDEINSTALLERSOURCE != "true"
	${AndIf} $bolErrorOccurred != "true"
		RMDir /r "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerLanguages\"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.bmp"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.ico"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstaller.nsi"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerConfig.nsh"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerDriveFreeSpaceCustom.nsh"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerDumpLogToFile.nsh"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeader.bmp"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerHeaderRTL.bmp"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerMoveFiles.nsh"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPlugin.nsi"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerPluginConfig.nsh"
		Delete "$strInstallAppDirectory\Other\Source\PortableApps.comInstallerTBProgress.nsh"
	${EndIf}

	;Remove the Source and Other directories if empty
	RMDir "$strInstallAppDirectory\Other\Source"
	RMDir "$strInstallAppDirectory\Other"
	${TBProgress_State} NoProgress 
SectionEnd

Function FinishPagePre
	${If} $bolAutomaticCompile == "true"
	${AndIf} $bolErrorOccurred != "true"
		;If running in automated mode and no errors, just exit
		Abort
	${EndIf}
FunctionEnd

;Annoying hack to fix MUI2's broken cancel button
!ifndef SC_CLOSE
!define SC_CLOSE 0xF060
!endif

Function FinishPageShow
	;Annoying hack to fix MUI2's broken cancel button Pt2
	EnableWindow $mui.Button.Cancel 1
	System::Call 'USER32::GetSystemMenu(i $hwndparent,i0)i.s'
	System::Call 'USER32::EnableMenuItem(is,i${SC_CLOSE},i0)'

	${If} $bolErrorOccurred == "true"
		;Disallow running the app since it wasn't created
		EnableWindow $mui.Finishpage.Run 0
		;Check the box to show the log file by default
		${NSD_Check} $mui.FinishPage.ShowReadme
	${EndIf}
	SetCtlColors $mui.FinishPage.Title 0x000000 0xFFFFFF
	SetCtlColors $mui.FinishPage.Text 0x000000 0xFFFFFF
	;These should work but do not
	SetCtlColors $mui.Finishpage.Run 0x000000 0xFFFFFF
	SetCtlColors $mui.FinishPage.ShowReadme 0x000000 0xFFFFFF
	${If} $bolHighContrast == "true"
		;Annoying hack to ensure checkboxes are visible when high contrast is on
		SetCtlColors $mui.Finishpage.Run 0x000000 0x888888
		SetCtlColors $mui.FinishPage.ShowReadme 0x000000 0x888888
	${EndIf}
FunctionEnd

Function FinishPageRun
	Exec `"$0\$strInstallerFilename.paf.exe"`
FunctionEnd

Function .onGUIEnd
	${If} $bolAutomaticCompile != "true"
		RealProgress::Unload
	${EndIf}
FunctionEnd