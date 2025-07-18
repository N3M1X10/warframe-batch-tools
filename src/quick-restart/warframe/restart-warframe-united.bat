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

:: Change CPU Priority on Launch
:: - Possible values: ["low", "BelowNormal", "normal", "AboveNormal", "high", "realtime"]
:: - Default: normal
set priority=normal

:: ps1 script path
:: required to correctly setup this var for option below
set warframe-cpu-priority-ps1=%~dp0bin\warframe-cpu-priority.ps1
set soulframe-cpu-priority-ps1=%~dp0bin\soulframe-cpu-priority.ps1

:: Sets that you need to make sure that all Steam processes is terminated or terminate them before launching Warframe
:: [1 / any else val]
:: default: '0'
set terminate_steam=0

:: if 'steam' the script will try launch game through steam
:: ['steam' / any else val]
:: default: ''
set launch_type=

:: !!! Set your own game directory path (without tools and executable, only game dir) if you running through a Steam !!!
:: there's no default value
set steam_warframe_path=

:: Sets whether Steam will be called or not 
:: [1 / any else val]
:: And if your 'launch_type' is 'steam' then with this option - you need to setup 'steam_warframe_path' above
:: 1 - if you don't wanna wake up the Steam
:: default: '0'
set without_waking_up_steam=0


:Dev-Params
:: !!! We strongly recommend that you DO NOT edit these parameters!!!

:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
set game=Warframe

:: default paths
set warframe=%LocalAppData%\Warframe\Downloaded\Public
set soulframe=%LocalAppData%\Soulframe\Downloaded\Public

:: this option will set this script to request admin rights
:: [1 / any else val]
:: this option REQUIRED to correct working of this script, and added only for very specific debugging
:: default: '1'
set require_admin=1

::debug mode (only for devs)
:: [1 / any else val]
::default: '0'
set debug=0

:End-Of-Params



:: main functions sequence
:request-admin-rights
if "%debug%"=="1" (
    rem debug mode
    if "%require_admin%"=="1" (
        set arg=%1
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
    rem if not debug mode
    if "%require_admin%"=="1" (
        set arg=%1
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


call :check-game-parameter


:kill-steam
if "%terminate_steam%"=="1" (
    :: Terminate of steam process tree
    echo.&echo [93mTrying to terminate a Steam . . .[0m
    call :check-process steamwebhelper.exe kill
    call :check-process steam.exe kill
)



:kill-game
echo.&echo [93mTrying to terminate a Game . . .[0m
call :check-process %game%.x64.exe kill
echo Done


:kill-Launcher
echo.&echo [93mTrying to terminate the Game Launcher . . .[0m
powershell -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('%game%')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
echo Done


:kill-RemoteCrashSender
echo.&echo [93mTrying to terminate the Game Remote Crash Sender . . .[0m
powershell -Command "Get-Process RemoteCrashSender | Where-Object { $path = $_.Path; if ($path.Contains('%game%')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
echo Done


:start-game
if "%game%"=="Warframe" (
    :: Starting warframe
    if "%launch_type%"=="steam" (
        :: Try to run the game through a steam
        echo.&echo Trying to run Warframe via Steam
        if "%without_waking_up_steam%"=="1" (
            :: Run without calling Steam
            echo.&echo but without waking up the Steam . . .
            call :check-path !steam_warframe_path! game
            cd /d "!warframe!"
            start "Tools\" "Tools\Launcher.exe" ^
            -cluster:public -registry:Steam

        ) else (
            :: Run wf through steam uri
            echo.&echo Trying to run Warframe via Steam . . .
            explorer "steam://rungameid/230410"

        )
    ) else (
        :: Starting via separated client launcher
        echo.&echo Trying to run Warframe via separated client launcher . . .
        call :check-path !warframe! game
        start "Tools\" "Tools\Launcher.exe"

    )
    echo.&echo Warframe is started

) else if "%game%"=="Soulframe" (
    rem Starting Soulframe
    rem Starting via separated client launcher
    echo For now, 'launch_type' is ignored by reason: there's no any else way to launch the game
    echo.&echo Trying to run Soulframe via separated client launcher . . .
    call :check-path !soulframe! game
    cd /d "!soulframe!"
    start "Tools\" "Tools\Launcher.exe"
    echo.&echo Soulframe is started

)



:: Call the ps1 script
if "%change_priority%"=="1" (
    call :cpu-priority
)


:: escape from script
:close
call :debug
endlocal
exit



:: other functions
:check-path
cd /d "%1"
echo.&echo [93mTrying to check "%1" path . . .[0m
if "%2"=="game" (
    :: if we looking for a game path
    echo We looking for a game launcher

    if not exist "Tools\Launcher.exe" (
        :: When path is incorrect
        if "%debug%"=="1" (
            echo.
            echo [101;93m! %game% launcher doesn't exist, unable to continue
            echo Make sure that the %game% launcher exists in: 
            echo "%1"[0m
            echo.
            echo Press any key to exit . . .
            pause>nul&goto:close
        ) else (
            if "%1"=="" (
                msg * [Restart-Warframe Error] ^: %game% path is empty. Please setup it inside this script
            ) else (
                msg * [Restart-Warframe Error] ^: %game% launcher doesn't exist in: "%1". Please make sure that path is correctly configured
            )
            msg * [Restart-Warframe Notification] ^: Script was interrupted
            goto:close
        )

    ) else (
        :: When path is correct
        echo Checks done
        exit /b
    )

) else (
    :: For now, this is a reserved part of the code
    echo incorrect check type
    exit /b
)
exit /b



:check-game-parameter
echo Checking and fixing the game ('%game%') parameter . . .
echo Trying to fix param character case . . .
for /F "delims=" %%i in ('echo %game% ^| find /i "soulframe"') do set game=Soulframe
for /F "delims=" %%i in ('echo %game% ^| find /i "warframe"') do set game=Warframe


echo Are this param is valid?
if "%game%" equ "Warframe" (
    rem do nothing

) else if "%game%" equ "Soulframe" (
    rem do nothing

) else if "%game%"=="" (
    :: empty
    if "%debug%"=="1" (
        echo [91mError. Param 'game' is empty[0m
        echo [91mScript is going to be interrupted[0m
        pause
        goto :close

    ) else (
        msg * [Restart-Warframe Error] ^: Error. Param 'game' is empty. Script was interrupted
        goto :close

    )

) else (
    :: else error
    if "%debug%"=="1" (
        echo [91mError. Param 'game' is incorrect[0m
        echo [91mScript is going to be interrupted[0m
        pause&goto :close

    ) else (
        msg * [Restart-Warframe Error] ^: Error. Param 'game' is incorrect. Script was interrupted
        goto :close

    )

)

echo Checks done
exit /b



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
        powershell -Command "$time = '500'; Write-Host "Pause for a $time ms"; Start-Sleep -m $time; exit"
        goto :check-process
    ) else (
        echo Killing is skipped by user
        exit /b
    )
) else (
    echo [92mNo[0m
    exit /b
)



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
        msg * [Restart-Warframe Notification] ^: !cpu-msg!

    )
    exit /b
)

if "%game%"=="Warframe" (
    set cpu-priority-ps1=%warframe-cpu-priority-ps1%
    set cpu-arg1=!priority!
    set cpu-arg2=Warframe.x64
    set cpu-arg3=Warframe Launcher

) else if "%game%"=="Soulframe" (
    set cpu-priority-ps1=%soulframe-cpu-priority-ps1%
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
        msg * [Restart-Warframe Notification] ^: The script """"!cpu-priority-ps1!"""" has not found. Cannot change the cpu priority.

    )
) else (
    :: if exist
    echo Args: !cpu-args!

    if "%debug%"=="1" (

        :: keep the window until script is done
        start powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" !cpu-args!

        :: keep the window infinite
        rem start powershell.exe -NoExit -NoProfile -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" !cpu-args!

    ) else (
        powershell -ExecutionPolicy Bypass -File "%cpu-priority-ps1%" !cpu-args!

    )
)


exit /b



:debug
if "%debug%"=="1" (
    echo.&echo [debug] : PAUSE EOF
    timeout /t 60
)
exit /b



:debug-warning
echo.
echo [93m[warning] : Script is in debug mode^^![0m
if "%require_admin%" neq "1" (
    echo [91m
    set require_admin_msg1=Admin rights was not requested^^!
    set require_admin_msg2=We are not sure that we have admin rights. Otherwise it may cause any issues^^!
    echo [caution] :  !require_admin_msg1!
    echo [caution] : !require_admin_msg2![0m
)
if "%debug%" neq "1" (
    msg * [Restart-Warframe Notification] ^: !require_admin_msg1! !require_admin_msg2!
)
echo.
exit /b


