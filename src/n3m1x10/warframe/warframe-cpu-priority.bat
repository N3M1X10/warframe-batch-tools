@echo off
chcp 65001>nul
title Warframe : Set CPU Priority
setlocal EnableDelayedExpansion

::# OPTIONS

:: ## Change CPU Priority on Launch
:: - Possible values: "idle", "low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"
:: - Default: normal
set priority=high

::END OF OPTIONS

:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and hidden
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit
)

:: checking cycles

:set-priority
powershell -Command "do {Start-Sleep -Seconds 2; $proc = Get-Process -Name "Warframe.x64" -ErrorAction SilentlyContinue; $hasWindow = $false; if($proc) {if ($proc -and $proc.MainWindowHandle -ne 0) { $hasWindow = $true; Write-Host "Process has been found"; $proc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::!priority!; Write-Host "Priority for Warframe.x64.exe has been changed"} else{cls; Write-Host "Process Warframe.x64.exe has no window"; Write-Host "Im trying to find him again . . ."}} else{cls; Write-Host "Process Warframe.x64.exe wasnt found"; Write-Host "Please, launch Warframe"}} while (-not $hasWindow)"
echo ! Changing priority complete

:: Source: https://github.com/N3M1X10/warframe-batch-tools
endlocal
exit