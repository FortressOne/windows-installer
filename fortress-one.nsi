!define APPNAME "FortressOne"
!define ORGNAME "FortressOne"
!define DESCRIPTION "A minimal QuakeWorld Team Fortress installation"
!define VERSIONMAJOR 0
!define VERSIONMINOR 1
!define VERSIONBUILD 3

RequestExecutionLevel admin

InstallDir "$PROGRAMFILES\${APPNAME}"

Name "${APPNAME}"
Icon "logo.ico"
outFile "fortress-one-installer-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.exe"

!include LogicLib.nsh

page directory
Page instfiles

!macro VerifyUserIsAdmin
  UserInfo::GetAccountType
  pop $0
  ${If} $0 != "admin" ;Require admin rights on NT4+
    messageBox mb_iconstop "Administrator rights required!"
    setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    quit
  ${EndIf}
!macroend

function .onInit
  setShellVarContext all
  !insertmacro VerifyUserIsAdmin
functionEnd

section "install"
  setOutPath $INSTDIR

  ; Copy icon
  File logo.ico

  ; get ezQuake 3.0
  inetc::get https://github.com/ezquake/ezquake-source/releases/download/v3.0/ezquake_win32_3.0-full.zip $EXEDIR\ezquake_win32_3.0-full.zip
  nsisunz::Unzip $EXEDIR\ezquake_win32_3.0-full.zip $INSTDIR

  ; get ezQuake 3.1 daily
  inetc::get http://uttergrottan.localghost.net/ezquake/dev/nightlybuilds/win32/2018-05-09-236a8d6-ezquake.7z $EXEDIR\2018-05-09-236a8d6-ezquake.7z
  Nsis7z::Extract $EXEDIR\2018-05-09-236a8d6-ezquake.7z
  Delete $INSTDIR\ezquake.exe
  Rename $INSTDIR\ezquake-236a8d6.exe $INSTDIR\ezquake.exe

  ; get gfx files
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip $EXEDIR\fortress-one-gfx.zip
  nsisunz::Unzip $EXEDIR\fortress-one-gfx.zip $INSTDIR

  ; get paks
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/paks.zip $EXEDIR\paks.zip
  nsisunz::Unzip $EXEDIR\paks.zip $INSTDIR

  ; get minimum cfgs
  inetc::get https://github.com/drzel/fortress-one-cfgs/archive/master.zip $EXEDIR\fortress-one-cfgs-master.zip
  nsisunz::Unzip $EXEDIR\fortress-one-cfgs-master.zip $INSTDIR
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\autoexec.cfg $INSTDIR\fortress\autoexec.cfg
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\bindings.cfg $INSTDIR\fortress\bindings.cfg
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\gfx_preset.cfg $INSTDIR\fortress\gfx_preset.cfg
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\config.cfg $INSTDIR\fortress\config.cfg
  RMDir /r "$INSTDIR\fortress-one-cfgs-master"

  # Uninstaller - See function un.onInit and section "uninstall" for configuration
  writeUninstaller "$INSTDIR\uninstall.exe"

  # Start Menu
  createDirectory "$SMPROGRAMS\${ORGNAME}"
  CreateShortCut "$SMPROGRAMS\${ORGNAME}\${APPNAME}.lnk" "$INSTDIR\ezquake.exe" "-game fortress" "$INSTDIR\logo.ico"
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\ezquake.exe" "-game fortress" "$INSTDIR\logo.ico"

  # Registry information for add/remove programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "$\"${ORGNAME}$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}

  # There is no option for modifying or repairing the install
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
sectionEnd

# Uninstaller

function un.onInit
  SetShellVarContext all

  #Verify the uninstaller - last chance to back out
  MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
    Abort
  next:
  !insertmacro VerifyUserIsAdmin
functionEnd

section "uninstall"
  delete "$SMPROGRAMS\${ORGNAME}\${APPNAME}.lnk"
  delete "$DESKTOP\${APPNAME}.lnk"
  rmDir "$SMPROGRAMS\${APPNAME}"

  rmdir /r $INSTDIR

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
sectionEnd
