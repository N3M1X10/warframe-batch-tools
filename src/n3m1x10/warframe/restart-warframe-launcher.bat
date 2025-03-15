@echo off
chcp 65001>nul
title Warframe (Launcher) : Restart
setlocal

::# OPTIONS
:: If you don't know what they mean - read https://github.com/N3M1X10/warframe-batch-tools/blob/main/src/n3m1x10/guide.md

:: Change CPU Priority on Launch [1 / 0] (read guide.md)
:: WARNING! UNSTABLE!
:: PLEASE, TEST THIS FEATURE AND LEAVE A REVIEW
set change_priority=0

:: END OF OPTIONS

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

::warframe kill
rem >nul taskkill /f /im "Launcher.exe" /t
>nul taskkill /f /im "Warframe.x64.exe" /t
>nul timeout /t 1 /nobreak

::warframe start (starting with separated client launcher)
set warframe=%LocalAppData%\Warframe\Downloaded\Public
cd /d "%warframe%"
IF NOT EXIST "Tools\Launcher.exe" (
cls
echo [101;93m! Warframe launcher doesn't exist, unable to continue
echo Make sure that the Warframe launcher exists in: 
echo "%warframe%"[0m
pause>nul&exit
)
start "Tools\" "Tools\Launcher.exe"

if %change_priority%==1 (
cd /d "%~dp0" & start "" "warframe-cpu-priority.bat"
)

:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
