@echo off
chcp 65001>nul
title Soulframe : Set CPU Priority
setlocal

::# OPTIONS

:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"
:: - Default: normal
set priority=normal

::END OF OPTIONS

:: Restart with Admin Rights and hide the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and hidden
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Hidden"
    exit
)

:: checking cycles

:: cycle limitation
set cycle_amount=60
:: Executable name we looking for
set process=Soulframe.x64.exe
:: Variable that makes this cycle doesn't endless, for performance reason
set cycle_count=1

:cycle
cls
echo ! Waiting for the "%process%" launch to change the priority of the process . . .
echo Cycle Limitation. After %cycle_amount% attempts batch will stopped. Viewing Attempts: %cycle_count%

if %cycle_count% geq %cycle_amount% (exit)
set /a cycle_count=%cycle_count%+1

:check-step1
echo Step 1
>nul timeout /t 4 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto check-step2
goto cycle
:check-step2
echo Step 2
>nul timeout /t 4 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto check-step3
goto cycle
:check-step3
echo Step 3
>nul timeout /t 5 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto check-step4
goto cycle
:check-step4
echo Step 4
>nul timeout /t 6 /nobreak
tasklist |>nul findstr /b /l /i /c:%process% && goto set-priority
goto cycle

:: Powershell command that sets priority for process
:set-priority
powershell (Get-Process -name "Soulframe.x64").PriorityClass = [System.Diagnostics.ProcessPriorityClass]::%priority%
echo ! Changing priority complete
>nul timeout /t 1 /nobreak

:: Source: https://github.com/N3M1X10/warframe-batch-tools
endlocal
exit
