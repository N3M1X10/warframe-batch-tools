@echo off & chcp 65001
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "soulframe-cpu-priority.ps1"
exit
