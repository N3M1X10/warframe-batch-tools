@echo off
chcp 65001>nul
title Warframe (Steam) : restart


:: Set the Warframe directory path !!! (without quotes)
set warframe=C:\Program Files (x86)\Steam\steamapps\common\Warframe\


:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

:: Change CPU Priority on Launch [1 / 0] (read guide.md)
:: WARNING! UNSTABLE!
:: PLEASE, TEST THIS FEATURE AND LEAVE A REVIEW
set change_priority=0

::warframe kill
>nul taskkill /f /im "Launcher.exe" /t
>nul taskkill /f /im "Warframe.x64.exe" /t

::warframe start (starting without steam)
cd /d "%warframe%"
start "Tools\" "Tools\Launcher.exe" ^
-cluster:public -registry:Steam

if %change_priority%==1 (
cd /d "%~dp0"
start "" "warframe-cpu-priority.bat"
)

:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
