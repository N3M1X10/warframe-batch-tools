@echo off
chcp 65001>nul
setlocal EnableDelayedExpansion



:Params
:: Change CPU Priority on Launch
:: - Possible values: ["low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"]
:: - Default: normal
set priority=normal

:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
set game=Soulframe

:: ps1 script path
:: required to correctly setup this var for option below
set cpu-priority-ps1=%~dp0cpu-priority.ps1

set debug=0

:End-Of-Params



call :cpu-priority



:close
if "%debug%"=="1" (pause)
endlocal
exit



:cpu-priority
cd /d "%~dp0"

if "%priority%"=="low" (
rem do nothing

) else if "%priority%"=="BelowNormal" (
rem do nothing

) else if "%priority%"=="normal" (
rem do nothing

) else if "%priority%"=="AboveNormal" (
rem do nothing

) else if "%priority%"=="high" (
rem do nothing

) else if "%priority%"=="realtime" (
rem do nothing

) else (
    set cpu-msg=Param 'priority' is incorrect. Cannot change cpu priority

    if "%debug%"=="1" (
        echo.
        echo [101;93m!cpu-msg![0m

    ) else (
        call :msg "!cpu-msg!" "Notification"

    )
    exit /b
)

if "%game%"=="Warframe" (
    set cpu-arg1=!priority!
    set cpu-arg2=Warframe.x64
    set cpu-arg3=Warframe Launcher

) else if "%game%"=="Soulframe" (
    set cpu-arg1=!priority!
    set cpu-arg2=Soulframe.x64
    set cpu-arg3=Soulframe Launcher

)

set cpu-args="!cpu-arg1!" "!cpu-arg2!" "!cpu-arg3!"

echo.&echo Starting '%cpu-priority-ps1%' script
if not exist "%cpu-priority-ps1%" (
    :: if NOT exist
    if "%debug%"=="1" (
        echo.
        echo [101;93m "!cpu-priority-ps1!" doesn't exist.
        echo But this is not a significant error. We have to continue.[0m

    ) else (
        call :msg "The script """"!cpu-priority-ps1!"""" has not found. Cannot change the cpu priority." "Notification"

    )
) else (
    :: if exist
    echo Args: !cpu-args!

    if "%debug%"=="1" (

        :: keep the window until script is done
        start powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" !cpu-args!

        :: keep the window infinite
        rem start powershell.exe -NoExit -NoProfile -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" -WindowStyle Hidden !cpu-args!

    ) else (
        :: silent
        powershell -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" -WindowStyle Hidden !cpu-args!

    )
)
exit /b



:msg
msg * [!application_name! %~2] ^: %~1
exit /b


