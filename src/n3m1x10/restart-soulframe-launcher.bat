@echo off
chcp 65001>nul
title Soulframe (Launcher) : Restart
setlocal

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

::kill
>nul taskkill /f /im "Soulframe.x64.exe" /t
>nul timeout /t 1 /nobreak

::start (starting with separated client launcher)
set soulframe=%LocalAppData%\Soulframe\Downloaded\Public
cd /d "%soulframe%"
IF NOT EXIST "Tools\Launcher.exe" (
cls
echo [101;93m! Soulframe launcher doesn't exist, unable to continue
echo Make sure that the soulframe launcher exists in: 
echo "%soulframe%"[0m
pause>nul&exit
)
start "Tools\" "Tools\Launcher.exe"
:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
