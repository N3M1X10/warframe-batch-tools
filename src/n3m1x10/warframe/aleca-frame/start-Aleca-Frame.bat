@echo off
chcp 65001>nul
setlocal
:: Overwolf Path
set overwolf=G:\Program Files (x86)\Tools\overwolf\

cd /d "%overwolf%"
start "" "%overwolf%OverwolfLauncher.exe" -launchapp afmcagbpgggkpdkokjhjkllpegnadmkignlonpjm -from-startmenu"
endlocal
exit
