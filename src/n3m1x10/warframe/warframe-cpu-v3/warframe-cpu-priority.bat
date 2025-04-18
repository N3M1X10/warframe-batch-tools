@echo off
chcp 65001>nul
title Warframe : Set CPU Priority
setlocal EnableDelayedExpansion

::# OPTIONS

:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"
:: - Default: normal
::set priority=high ???

::END OF OPTIONS

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and hidden
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit
)

:: checking cycles

:set-priority
powershell -ExecutionPolicy Bypass -File "%~dp0pwsh\warframe-cpu.ps1"
echo ! Changing priority complete
pause
:: Source: https://github.com/N3M1X10/warframe-batch-tools
endlocal
exit