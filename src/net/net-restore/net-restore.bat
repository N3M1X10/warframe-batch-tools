@echo off
chcp 65001>nul
title net-restore

:: base reset
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

echo.&echo All operations has complete !
echo Press any key to exit . . .
timeout /t 3 &endlocal&exit
