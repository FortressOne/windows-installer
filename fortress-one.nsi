; fortress-one.nsi
; compile with NSIS
; plugins:
;   inetc, nsisunz
;--------------------------------

; The name of the installer
Name "FortressOne"

; The file to write
OutFile "fortress-one-0.1.1-setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FortressOne

; Request application privileges for Windows Vista
RequestExecutionLevel highest

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
section ""
  setoutpath $INSTDIR

  ; Copy icon
  File fortress-one.ico

  ; get ezQuake 3.0
  inetc::get https://github.com/ezquake/ezquake-source/releases/download/v3.0/ezquake_win32_3.0-full.zip $EXEDIR\ezquake_win32_3.0-full.zip
  nsisunz::Unzip $EXEDIR\ezquake_win32_3.0-full.zip $INSTDIR

  ; get ezQuake 3.1 daily
  inetc::get http://uttergrottan.localghost.net/ezquake/dev/nightlybuilds/win32/2018-04-29-41575f7-ezquake.7z $EXEDIR\2018-04-29-41575f7-ezquake.7z
  Nsis7z::Extract $EXEDIR\2018-04-29-41575f7-ezquake.7z
  Delete $INSTDIR\ezquake.exe
  Rename $INSTDIR\ezquake-41575f7.exe $INSTDIR\ezquake.exe

  ; get gfx files
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip $EXEDIR\fortress-one-gfx.zip
  nsisunz::Unzip $EXEDIR\fortress-one-gfx.zip $INSTDIR

  ; get paks
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/paks.zip $EXEDIR\paks.zip
  nsisunz::Unzip $EXEDIR\paks.zip $INSTDIR

  ; get minimum cfgs
  inetc::get https://github.com/drzel/fortress-one-cfgs/archive/master.zip $EXEDIR\fortress-one-cfgs-master.zip
  nsisunz::Unzip $EXEDIR\fortress-one-cfgs-master.zip $INSTDIR
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\config.cfg $INSTDIR\fortress\config.cfg
  Rename $INSTDIR\fortress-one-cfgs-master\fortress\bindings.cfg $INSTDIR\fortress\bindings.cfg
  RMDir /r "$INSTDIR\fortress-one-cfgs-master"

  ; create shortcut
  CreateShortCut "$DESKTOP\FortressOne.lnk" "$INSTDIR\ezquake.exe" "-game fortress +exec config.cfg" "$INSTDIR\fortress-one.ico"
sectionend
