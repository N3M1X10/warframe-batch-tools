@echo off
chcp 65001>nul
taskkill /f /im "Overwolf.exe" /t
taskkill /f /im "OverwolfLauncher.exe" /t
taskkill /f /im "OverwolfHelper64.exe"
taskkill /f /im "OverwolfHelper.exe"
taskkill /f /im "OverwolfBrowser.exe"
>nul timeout /t 1 /nobreak
set overwolf=G:\Program Files (x86)\Tools\overwolf\
start "%overwolf%" "%overwolf%OverwolfLauncher.exe" ^
-launchapp afmcagbpgggkpdkokjhjkllpegnadmkignlonpjm -from-startmenu
exit
