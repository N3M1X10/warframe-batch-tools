@echo off
chcp 65001>nul
title net-reset
setlocal

set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)
echo.

echo.
echo %~n0

:: base reset
echo.
echo NETSH INT IP RESET
netsh int ip reset

echo.
echo IPCONFIG IPV4
ipconfig /release

timeout /t 10 /nobreak

ipconfig /renew

rem echo IPCONFIG FLUSHDNS
rem ipconfig /flushdns

echo.&echo All operations has complete !
echo Press any key to exit . . .
timeout /t 1 &endlocal&exit
