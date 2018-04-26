; fortress-one.nsi
; compile with NSIS
; plugins:
;   inetc, nsisunz
;--------------------------------

; The name of the installer
Name "FortressOne"

; The file to write
OutFile "fortress-one-0.1.0-setup.exe"

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
  setoutpath $instdir

  inetc::get https://github.com/ezquake/ezquake-source/releases/download/v3.0/ezquake_win32_3.0-full.zip $EXEDIR\ezquake_win32_3.0-full.zip
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/paks.zip $EXEDIR\paks.zip
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-cfg.zip $EXEDIR\fortress-one-cfg.zip
  inetc::get https://s3-ap-southeast-2.amazonaws.com/qwtf/fortress-one-gfx.zip $EXEDIR\fortress-one-gfx.zip
  nsisunz::Unzip $EXEDIR\ezquake_win32_3.0-full.zip $INSTDIR
  nsisunz::Unzip $EXEDIR\paks.zip $INSTDIR
  nsisunz::Unzip $EXEDIR\fortress-one-cfg.zip $INSTDIR
  nsisunz::Unzip $EXEDIR\fortress-one-gfx.zip $INSTDIR
sectionend
