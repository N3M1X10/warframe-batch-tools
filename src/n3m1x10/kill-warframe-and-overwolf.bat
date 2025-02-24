@echo off
chcp 65001>nul
:: Kill Overwolf and Warframe
:: Overwolf
taskkill /f /im "Overwolf.exe" /t
taskkill /f /im "OverwolfLauncher.exe" /t
taskkill /f /im "OverwolfHelper64.exe"
taskkill /f /im "OverwolfHelper.exe"
taskkill /f /im "OverwolfBrowser.exe"
:: Warframe
taskkill /f /im "Warframe.x64.exe" /t
cls&taskkill /im "Launcher.exe"
exit
