@echo off
chcp 65001>nul
:: kill
:: Game
>nul taskkill /f /im "Warframe.x64.exe" /t
>nul timeout /t 1 /nobreak
:: Launcher
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }"
:: RemoteCrashSender
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }"
exit
