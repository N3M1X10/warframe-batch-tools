@echo off & chcp 65001
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "warframe-cpu-priority.ps1"
exit
