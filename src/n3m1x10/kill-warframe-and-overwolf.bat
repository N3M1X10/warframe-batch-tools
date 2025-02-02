@echo off
chcp 65001>nul
:: Kill Overwolf and Warframe
:: Overwolf
>nul taskkill /f /im "Overwolf.exe" /t
>nul taskkill /f /im "OverwolfLauncher.exe" /t
>nul taskkill /f /im "OverwolfHelper64.exe"
>nul taskkill /f /im "OverwolfHelper.exe"
>nul taskkill /f /im "OverwolfBrowser.exe"
:: Warframe
>nul taskkill /f /im "Launcher.exe" /t
>nul taskkill /f /im "Warframe.x64.exe" /t
exit
