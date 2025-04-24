@echo off & chcp 65001>nul

:: Restart with Admin Rights
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit
)

setlocal

set reg_bash=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
set key_name=EnableLUA
set value=0

echo.&REG ADD %reg_bash% /v %key_name% /t REG_DWORD /d %value% /f
IF %ERRORLEVEL% NEQ 0 (echo [31mSomething went wrong & goto end) else (echo [92mUser Account Control has disabled!)

echo [0m&echo Registry bash: "%reg_bash%"
echo Registry key "%key_name%" is set on "%value%"

echo.&echo [33mNow you need to restart the system![0m

:end
echo.&pause&endlocal&exit
