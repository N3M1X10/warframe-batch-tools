@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion


:Params
:: default: ''
set debug=

:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
set game=Warframe

:: ps1 script path
set autorestart-ps1=%~dp0autorestart-scrobbler.ps1

:End-Of-Params


call :cpu-priority
call :msg "I have started a background script: \"!autorestart-ps1!\"."


:close
rem if "%debug%"=="1" (timeout /t 60)
endlocal
exit


:cpu-priority
cd /d "%~dp0"
if "%debug%"=="1" (
	start powershell.exe -NoProfile -NoExit -ExecutionPolicy Bypass -File "%autorestart-ps1%" -Verb RunAs
) else (
	start /min powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%autorestart-ps1%" -Verb RunAs
)
exit /b


:msg
msg * [%~n0%~x0] ^: %~1
exit /b

