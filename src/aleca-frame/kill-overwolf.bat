@echo off
chcp 65001>nul
>nul taskkill /f /im "Overwolf.exe" /t
>nul taskkill /f /im "OverwolfLauncher.exe" /t
>nul taskkill /f /im "OverwolfHelper64.exe"
>nul taskkill /f /im "OverwolfHelper.exe"
>nul taskkill /f /im "OverwolfBrowser.exe"
exit
