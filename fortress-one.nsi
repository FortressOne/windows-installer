; fortress-one.nsi
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

  CopyFiles $EXEDIR\ezquake_win32_3.0-full.zip $INSTDIR/ezquake_win32_3.0-full.zip
sectionend
