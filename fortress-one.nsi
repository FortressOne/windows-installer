; fortress-one.nsi
;--------------------------------

; The name of the installer
Name "FortressOne"

; The file to write
OutFile "fortress-one-0.1.0-setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\FortressOne

; Request application privileges for Windows Vista
RequestExecutionLevel user

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File temp.txt
  
SectionEnd ; end the section
