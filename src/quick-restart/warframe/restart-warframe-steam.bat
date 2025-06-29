@echo off
chcp 65001>nul
title Warframe (Steam) : Restart
setlocal

:: # OPTIONS

:: If you don't know what they mean - read:
:: - https://github.com/N3M1X10/warframe-batch-tools/blob/main/src/warframe/guide.md
:: - https://github.com/N3M1X10/warframe-batch-tools/blob/main/src/soulframe/guide.md

:: Set the Warframe directory path !!! (read guide.md)
set warframe=

:: Set whether Steam will be called or not [1 / 0] (read guide.md)
:: default=1
set without_steam=1

:: Change CPU Priority on Launch [1 / 0] (read guide.md)
:: WARNING! UNSTABLE!
:: PLEASE, TEST THIS FEATURE AND LEAVE A REVIEW
:: default=0
set change_priority=0

:: # END OF OPTIONS

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
>nul taskkill /f /im "Warframe.x64.exe" /t
>nul timeout /t 1 /nobreak
:: Launcher
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
:: RemoteCrashSender
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul

::warframe start (starting without steam)
cd /d "%warframe%"
IF NOT EXIST "Tools\Launcher.exe" (
cls
echo [101;93m! Warframe launcher doesn't exist, unable to continue
echo Make sure that the Warframe launcher exists in: 
echo "%warframe%"[0m
pause>nul&exit
)

:: Launch without steam if in options "set without_steam=1"
if %without_steam%==1 (
cd /d "%warframe%"
start "Tools\" "Tools\Launcher.exe" ^
-cluster:public -registry:Steam
) else (
rem start "Tools\" "Tools\Launcher.exe"
explorer "steam://rungameid/230410"
)

:: Call CPU Priority batch if you choose "set change_priority=1"
if %change_priority%==1 (
rem cd /d "%~dp0" & start "" "warframe-cpu-priority.bat"
cd /d "%~dp0" & powershell -ExecutionPolicy Bypass -File "%~dp0bin\warframe-cpu-priority.ps1"
)

:: Source: https://github.com/N3M1X10/warframe-batch-tools
endlocal
exit
