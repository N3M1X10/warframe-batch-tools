@echo off
chcp 65001>nul
:: Kill Overwolf and Warframe
:: Overwolf
taskkill /f /im "Overwolf.exe" /t
taskkill /f /im "OverwolfLauncher.exe" /t
taskkill /f /im "OverwolfHelper64.exe"
taskkill /f /im "OverwolfHelper.exe"
taskkill /f /im "OverwolfBrowser.exe"
:: Warframe
:: launcher
for /f "tokens=1,2,3 delims= " %%i in ('powershell -Command "Get-Process -Name 'Launcher' | Select-Object Description, Id | Format-Table -HideTableHeaders | Out-String"') do (
    if "%%i %%j"=="Warframe Launcher" (
        echo.
        echo Description: %%i %%j
        echo PID: %%k
        taskkill /f /pid %%k
        echo Process with PID %%k has terminated
        echo.
    ) else (cls&echo Launcher not found)
)
:: game
taskkill /f /im "Warframe.x64.exe" /t
cls&taskkill /im "Launcher.exe"
exit
