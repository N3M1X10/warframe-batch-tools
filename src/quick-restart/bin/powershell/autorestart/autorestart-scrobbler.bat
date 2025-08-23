@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion

:Params

:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
set game=Warframe

:: ps1 script path
:: required to correctly setup this var for option below
set autorestart-ps1=%~dp0autorestart-scrobbler.ps1

set debug=0

:End-Of-Params

call :cpu-priority

:close
rem if "%debug%"=="1" (pause)
endlocal
exit

:cpu-priority
cd /d "%~dp0"
if "%debug%"=="1" (
	start powershell.exe -NoProfile -NoExit -ExecutionPolicy Bypass -File "%autorestart-ps1%"
) else (
	start powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%autorestart-ps1%"
)
exit /b

:msg
msg * [!application_name! %~2] ^: %~1
exit /b
