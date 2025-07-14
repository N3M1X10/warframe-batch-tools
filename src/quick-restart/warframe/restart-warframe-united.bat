@echo off
chcp 65001>nul
title Restart Warframe (United)
setlocal EnableDelayedExpansion


:Params
:: If you don't know what they mean - check readme's
:: Script source: https://github.com/N3M1X10/warframe-batch-tools

:: Change CPU Priority on Launch
:: possible: [1 / 0]
:: default: '0'
set change_priority=0

:: ps1 script path
:: required to correctly setup this var for option below
set cpu-priority-ps1=%~dp0bin\warframe-cpu-priority.ps1

:: Sets that you need to make sure that all Steam processes is terminated or terminate them before launching Warframe
:: [1 / any else val]
:: default: '0'
set terminate_steam=0

:: if 'steam' the script will try launch game through steam
:: ['steam' / any else val]
:: default: ''
set launch_type=

:: !!! Set your own Warframe directory path (without tools and executable, only game dir) if you running through a Steam !!!
:: there's no default value
set steam_warframe_path=

:: Sets whether Steam will be called or not 
:: [1 / any else val]
:: And if your 'launch_type' is 'steam' then with this option - you need to setup 'steam_warframe_path' above
:: 1 - if you don't wanna wake up the Steam
:: default: '0'
set without_waking_up_steam=0

:: this option will set this script to request admin rights
:: [1 / any else val]
:: this option REQUIRED to correct working of this script, and added only for very specific debugging
:: default: '1'
set require_admin=1

::debug mode (only for devs)
:: [1 / any else val]
::default: '0'
set debug=0

::End of Params


:: main functions sequence

:request-admin-rights
if "%debug%"=="1" (
    if "%require_admin%"=="1" (
        set "arg=%1"
            if "%arg%"=="admin" (
                echo [93m[powershell] : Restarted with admin rights[0m
                call :debug-warning
            ) else (
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
                exit
            )
    ) else (
        call :debug-warning
    )
) else (
    if "%require_admin%"=="1" (
        set "arg=%1"
        if "%arg%"=="admin" (
            echo [powershell] : Restarted with admin rights and hidden
        ) else (
            powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Hidden"
            exit
        )
    ) else (
        call :debug-warning
    )
)


:kill-steam
if "%terminate_steam%"=="1" (
    :: Terminate of steam process tree
    echo.&echo [93mTrying to terminate a Steam . . .[0m
    call :check-process steamwebhelper.exe kill
    call :check-process steam.exe kill
)


:kill-game
echo.&echo [93mTrying to terminate a Game . . .[0m
>nul taskkill /f /t /im "Warframe.x64.exe">nul
echo Done


:kill-Launcher
echo.&echo [93mTrying to terminate the Game Launcher . . .[0m
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
echo Done


:kill-RemoteCrashSender
echo.&echo [93mTrying to terminate the Game Crash Sender . . .[0m
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('Warframe')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
echo Done


:start-warframe
if "%launch_type%"=="steam" (
    :: Try to run the game through a steam
    echo.&echo Trying to run Warframe via Steam
    if "%without_waking_up_steam%"=="1" (
        :: Run without calling Steam
        echo.&echo but without waking up the Steam . . .
        cd /d "%steam_warframe_path%"
        call :check-warframe-path !steam_warframe_path!
        start "Tools\" "Tools\Launcher.exe" ^
        -cluster:public -registry:Steam
        echo Warframe is started

    ) else (
        :: Run wf through steam uri
        echo.&echo Trying to run Warframe via Steam . . .
        explorer "steam://rungameid/230410"
        echo Warframe is started

    )
) else (
    :: Starting via separated client launcher
    echo.&echo Trying to run Warframe via separated client launcher . . .
    set warframe=%LocalAppData%\Warframe\Downloaded\Public
    call :check-warframe-path !warframe!
    start "Tools\" "Tools\Launcher.exe"
    echo Warframe is started

)


:: Call the ps1 script
if "%change_priority%"=="1" (
    call :start-cpu-priority
)


:close
call :debug
endlocal
exit




:: other functions
:check-warframe-path
cd /d "%1"
echo.&echo Trying to check warframe path . . .
if not exist "Tools\Launcher.exe" (
    :: When path is incorrect
    if "%debug%" neq "1" (
        if "%1"=="" (
            msg * [restart-warframe] ^: Error. Warframe path is empty. Please setup it inside this script
        ) else (
            msg * [restart-warframe] ^: Error. Warframe launcher doesn't exist in: "%1". Please make sure that path is correctly configured
        )
        msg * [restart-warframe] ^: Script was interrupted
        goto:close
    ) else (
        cls
        echo [101;93m! Warframe launcher doesn't exist, unable to continue
        echo Make sure that the Warframe launcher exists in: 
        echo "%1"[0m
        echo.
        echo Press any key to exit . . .
        pause>nul&goto:close
    )
) else (
    :: When path is correct
    echo Done
    exit /b
)


:check-process
set checking_process=%1
set defined_tasks_count=
echo.&echo [93mAre '%checking_process%' is running?[0m 
for /F "delims=" %%i in ('tasklist /fi "IMAGENAME eq %checking_process%" /fo CSV ^| find /c "%checking_process%"') do set defined_tasks_count=%%i
if %defined_tasks_count% geq 1 (
    echo [91mYes[0m
    if "%2"=="kill" (
        :: kill and make sure that process is killed
        echo [93mTrying to stop it . . .[0m
        taskkill /f /t /im "%checking_process%"
        echo Done
        echo Repeat
        goto :check-process
    ) else (
        echo Killing is skipped by user
        exit /b
    )
) else (
    echo [92mNo[0m
    set checking_count=
    exit /b
)


:start-cpu-priority
cd /d "%~dp0"
echo Starting '%cpu-priority-ps1%' script
if "%debug%"=="1" (
    start powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%cpu-priority-ps1%"
) else (
    powershell -ExecutionPolicy Bypass -File "%cpu-priority-ps1%"
)
exit /b


:debug
if "%debug%"=="1" (
    echo.&echo [debug] : PAUSE EOF
    pause>nul
)
exit /b


:debug-warning
echo.
echo [93m[warning] : Script is in debug mode^^![0m
if "%require_admin%" neq "1" (
    echo [91m
    echo [caution] : Admin rights was not requested^^! 
    echo [caution] : We are not sure that we have admin rights. Otherwise it may cause any issues^^![0m
)
set debug=1
echo.
exit /b

