@echo off
rem chcp 65001>nul
setlocal
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

echo WARP config generator for Warframe chat
echo Please wait . . .

powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"
powershell -ExecutionPolicy Bypass -File "%~dp0pwsh\WARP-gen(warframe).ps1"

endlocal&exit
