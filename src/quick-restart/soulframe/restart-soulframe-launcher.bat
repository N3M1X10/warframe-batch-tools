@echo off
chcp 65001>nul
title Soulframe (Launcher) : Restart
setlocal

::# OPTIONS
:: If you don't know what they mean - check readme.md

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
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Hidden"
    exit /b
)

:: kill
:: Game
>nul taskkill /f /im "Soulframe.x64.exe" /t
>nul timeout /t 1 /nobreak
:: Launcher
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('Soulframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
:: RemoteCrashSender
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('Soulframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul

:: start (starting with separated client launcher)
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

:: call cpu priority
if %change_priority%==1 (
cd /d "%~dp0" & powershell -ExecutionPolicy Bypass -File "%~dp0bin\soulframe-cpu-priority.ps1"
)

:: Source: https://github.com/N3M1X10/warframe-batch-tools
endlocal
exit
