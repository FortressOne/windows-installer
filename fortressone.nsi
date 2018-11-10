!define APPNAME "FortressOne"
!define ORGNAME "The FortressOne Team"
!define DESCRIPTION "A minimal QuakeWorld Team Fortress installation"
!define VERSIONMAJOR 0
!define VERSIONMINOR 3
!define VERSIONBUILD 0

InstallDir "$LOCALAPPDATA\${APPNAME}"

Name "${APPNAME}"
Icon "logo.ico"
outFile "fortressone-${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.exe"

!include LogicLib.nsh

page directory
Page instfiles

section "install"
  setOutPath $INSTDIR

  ; Copy icon
  File logo.ico

  ; get FortressOne client 3.1
  inetc::get https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/fortressone.exe $TEMP\fortressone.exe
  Rename $TEMP\fortressone.exe $INSTDIR\fortressone.exe
  createDirectory $INSTDIR\ezquake
  createDirectory $INSTDIR\id1
  createDirectory $INSTDIR\fortress

  ; get fragfile.dat
  inetc::get https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/fragfile.dat $TEMP\fragfile.dat
  CopyFiles $TEMP\fragfile.dat $INSTDIR\fortress

  ; get server browser sources
  inetc::get https://github.com/FortressOne/ezquake-source/releases/download/v3.1.0/sb.zip $TEMP\sb.zip
  nsisunz::Unzip $TEMP\sb.zip $INSTDIR\ezquake

  ;get FortressOne client media files
  inetc::get https://github.com/FortressOne/ezquake-media/releases/download/v1.0.0/fortressone.pk3 $INSTDIR\fortress\fortressone.pk3

  ; get shareware Quake pak0.pak
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/paks/id1/pak0.pak $INSTDIR\id1\pak0.pak

  ; get fortressone pak0.pk3
  inetc::get https://github.com/FortressOne/assets/releases/download/1.0.0/pak0.pk3 $INSTDIR\fortress\pak0.pk3

  ; get minimum cfgs
  inetc::get https://github.com/drzel/fortress-one-cfgs/archive/master.zip $TEMP\fortress-one-cfgs-master.zip
  nsisunz::Unzip $TEMP\fortress-one-cfgs-master.zip $TEMP

  Rename $TEMP\fortress-one-cfgs-master\fortress\autoexec.cfg $INSTDIR\fortress\autoexec.cfg

  createDirectory $INSTDIR\fortress\cfg
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\tf2_bindings.cfg $INSTDIR\fortress\cfg\tf2_bindings.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\zeltf_bindings.cfg $INSTDIR\fortress\cfg\zeltf_bindings.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\hud.cfg $INSTDIR\fortress\cfg\hud.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\crosshair.cfg $INSTDIR\fortress\cfg\crosshair.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\gfx_gl_eyecandy.cfg $INSTDIR\fortress\cfg\gfx_gl_eyecandy.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\gfx_gl_faithful.cfg $INSTDIR\fortress\cfg\gfx_gl_faithful.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\gfx_gl_fast.cfg $INSTDIR\fortress\cfg\gfx_gl_fast.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\gfx_gl_higheyecandy.cfg $INSTDIR\fortress\cfg\gfx_gl_higheyecandy.cfg 
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\set_compatibility_aliases.cfg $INSTDIR\fortress\cfg\set_compatibility_aliases.cfg
  Rename $TEMP\fortress-one-cfgs-master\fortress\cfg\unset_compatibility_aliases.cfg $INSTDIR\fortress\cfg\unset_compatibility_aliases.cfg

  createDirectory $INSTDIR\ezquake\configs
  Rename $TEMP\fortress-one-cfgs-master\ezquake\configs\config.cfg $INSTDIR\ezquake\configs\config.cfg

  RMDir /r "$TEMP\fortress-one-cfgs-master"

  # Uninstaller - See function un.onInit and section "uninstall" for configuration
  writeUninstaller "$INSTDIR\uninstall.exe"

  # Start Menu
  CreateShortCut "$SMPROGRAMS\${APPNAME}.lnk" "$INSTDIR\fortressone.exe" "$INSTDIR\logo.ico"
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\fortressone.exe" "$INSTDIR\logo.ico"

  # Registry information for add/remove programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "${ORGNAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}

  # There is no option for modifying or repairing the install
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
sectionEnd

# Uninstaller

function un.onInit
  #Verify the uninstaller - last chance to back out
  MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
  Abort
  next:
functionEnd

section "uninstall"
  delete "$SMPROGRAMS\${APPNAME}.lnk"
  delete "$DESKTOP\${APPNAME}.lnk"

  rmdir /r $INSTDIR

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
sectionEnd
