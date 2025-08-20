@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion



:Params
:: Change CPU Priority on Launch
:: - Possible values: ["low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"]
:: - Default: normal
set priority=normal

:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
set game=Warframe

:: ps1 script path
:: required to correctly setup this var for option below
set autorestart-ps1=%~dp0autorestart-warframe.ps1

set debug=0

:End-Of-Params



call :cpu-priority



:close
if "%debug%"=="1" (pause)
endlocal
exit



:cpu-priority
cd /d "%~dp0"
start powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%autorestart-ps1%"
exit /b



:msg
msg * [!application_name! %~2] ^: %~1
exit /b


