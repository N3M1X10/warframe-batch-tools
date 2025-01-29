@echo off
chcp 65001>nul
title Warframe (Launcher) : Restart

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

::warframe kill
>nul taskkill /f /im "Launcher.exe" /t
>nul taskkill /f /im "Warframe.x64.exe" /t
>nul timeout /t 1 /nobreak

::warframe start (starting with separated client launcher)
set warframe=%LocalAppData%\Warframe\Downloaded\Public
cd /d "%warframe%"
IF NOT EXIST "Tools\Launcher.exe" (
cls
echo [101;93m! Warframe directory doesn't exist, unable to continue
echo Make sure that the Warframe directory exists in: 
echo "%warframe%"[0m
pause>nul&exit
)
start "Tools\" "Tools\Launcher.exe"
:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
