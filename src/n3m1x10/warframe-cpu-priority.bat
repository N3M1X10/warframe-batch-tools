@echo off
chcp 65001>nul
title Warframe : Set CPU Priority
setlocal

::# OPTIONS
:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "HighPriority", "realtime"
:: - Default: normal
set priority=normal

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Hidden"
    exit
)

:: checking cycles

:: cycle limitation
set cycle_amount=120

set cycle_count=1
set process=Warframe.x64.exe
:first-cycle
cls
echo ! Waiting launcher's false start . . .
echo Viewing Attempts: %cycle_count%
>nul timeout /t 5 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto check-cycle
if %cycle_count% geq %cycle_amount% (exit)
set /a cycle_count=%cycle_count%+1
echo.
goto first-cycle

:check-cycle
set cycle_count=1
:cycle
cls
echo ! Waiting for the Warframe launch to change the priority of the process . . .
echo Viewing Attempts: %cycle_count%
>nul timeout /t 3 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto set-priority
if %cycle_count% geq %cycle_amount% (exit)
set /a cycle_count=%cycle_count%+1
echo.
goto cycle

:: Warframe.x64.exe

:: Powershell command that sets priority for warframe
:set-priority
powershell (Get-Process -name "Warframe.x64").PriorityClass = [System.Diagnostics.ProcessPriorityClass]::%priority%

:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
