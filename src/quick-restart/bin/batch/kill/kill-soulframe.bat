@echo off
chcp 65001>nul
set game=Soulframe
:: kill
:: Game
>nul taskkill /f /t /im "%game%.x64.exe"
>nul timeout /t 1 /nobreak
:: Launcher
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('%game%')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
:: RemoteCrashSender
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('%game%')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
timeout /t 1
exit
