@echo off
chcp 65001>nul
title Warframe : Set CPU Priority
setlocal

::# OPTIONS
:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"
:: - Default: normal
set priority=high

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and hidden
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
:: When you start Warframe in launcher he create "Warframe.x64.exe" task for a short period of time
:: This is a crutch method to solve the automation problem (because im a dumb)
echo ! Waiting launcher's false start . . .
echo Viewing Attempts: %cycle_count%
>nul timeout /t 5 /nobreak
:: checking tasklist for selected executable
tasklist |>nul findstr /b /l /i /c:%process% && goto check-cycle
:: exit when limit is reached
if %cycle_count% geq %cycle_amount% (exit)
:: increase the counter by one step
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

:: Powershell command that sets priority for warframe
:set-priority
powershell (Get-Process -name "Warframe.x64").PriorityClass = [System.Diagnostics.ProcessPriorityClass]::%priority%
echo ! Changing priority complete

:: Source: https://github.com/N3M1X10/warframe-batch-tools
exit
