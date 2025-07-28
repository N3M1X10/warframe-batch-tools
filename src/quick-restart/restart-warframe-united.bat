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
set cpu-priority-ps1=%~dp0bin\powershell\cpu-priority\cpu-priority.ps1

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

:: sets whether the window will be hidden
:: default: '1'
set windowless=1


:Dev-Params
::!!! We strongly recommend that you DO NOT edit these parameters!!!

set application_name=WFBT-Quick-Restart

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

:Constant-Params

set "adm_arg=%1"
set "hdn_arg=%2"

:End-Of-Params



:Start-Of-Application-Body

call :request-admin-rights

call :check-game-parameter

:kill-steam
if "%terminate_steam%"=="1" (
    :: Terminate of steam process tree
    echo.&echo [93mTrying to terminate a Steam . . .[0m
    call :check-process "steamwebhelper.exe" kill
    call :check-process "steam.exe" kill
)



:kill-game
echo.&echo [93mTrying to terminate a Game . . .[0m
call :check-process "%game%.x64.exe" kill
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

:End-Of-Application-Body



:: escape from script
:close
call :debug
endlocal
exit



:request-admin-rights
if "%debug%"=="1" (
    rem debug mode
    if "%require_admin%" == "1" (
        if "%adm_arg%" == "admin" (
            call :debug-warning
            echo [93m[powershell] : Restarted with admin rights
            echo By the way, window is kept awake, because we is in debug[0m
        ) else (
            echo [powershell] : Requesting admin rights . . .
            powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
            exit
        )
    ) else (
        call :debug-warning
    )
) else (
    rem if not debug mode
    if "%require_admin%" == "1" (
        if "%windowless%" == "1" (
            rem if we need to be quiet
            if "%hdn_arg%" == "hidden" (
                rem admin requested
            ) else (
                echo [powershell] : Requesting admin rights and trying to hide the window . . .
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin hidden\"' -Verb RunAs -WindowStyle Hidden"
                exit
            )
        ) else (
            rem if we don't need to be quiet
            if "%adm_arg%" == "admin" (
                rem admin requested
            ) else (
                echo [powershell] : Requesting admin rights . . .
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin hidden\"' -Verb RunAs"
                exit
            )
        )
    )
)
exit /b



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
                msg * [!application_name! Error] ^: %game% path is empty. Please setup it inside this script
            ) else (
                msg * [!application_name! Error] ^: %game% launcher doesn't exist in: "%1". Please make sure that path is correctly configured
            )
            msg * [!application_name! Notification] ^: Script was interrupted
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
        call :msg "Param 'game' is incorrect. Script was interrupted" "Error"
        goto :close
    )

) else (
    :: else error
    if "%debug%"=="1" (
        echo [91mError. Param 'game' is incorrect[0m
        echo [91mScript is going to be interrupted[0m
        pause
        goto :close
    ) else (
        call :msg "Param 'game' is incorrect. Script was interrupted" "Error"
        goto :close
    )

)

echo Checks done
exit /b



:check-process
set checking_process=%~1
set defined_tasks_count=

echo.&echo [93mAre '%checking_process%' is running?[0m

for /F "delims=" %%i in ('tasklist /fi "IMAGENAME eq %checking_process%" /fo CSV ^| find /c "%checking_process%"') do set defined_tasks_count=%%i

if "%2"=="kill" (
    :: stopping it and making sure that this is not running
    echo Function action is: "%2"

    if %defined_tasks_count% geq 1 (
        echo [91mYes[0m
        :: kill and make sure that process is killed
        echo [93m[cycle] : Trying to stop it . . .[0m
        taskkill /f /t /im "%checking_process%"
        echo Repeat checking . . .
        call :wait 500
        goto :check-process

    ) else (
        echo [92mNo[0m
        exit /b
    )

) else if "%2"=="wait" (
    :: waiting to appear
    echo Function action is: "%2"

    if %defined_tasks_count% geq 1 (
        echo [92mYes[0m
        exit /b
    ) else (
        echo [91mNo[0m
        echo [93m[cycle] : Waiting for "%checking_process%" to appear . . .[0m
        call :wait 1000
        goto :check-process
    )

) else (
    :: when we without any actions in %2
    if %defined_tasks_count% geq 1 (
        echo [93mYes[0m
        exit /b 1
    ) else (
        echo [93mNo[0m
        exit /b 0
    )
    exit /b
)
call :msg "Checking function for """"!checking_process!"""" has an exeption" "Error"
set debug=0
goto :close



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



:wait
:: just a function for additional delays in code. 
::it takes params:
:: time - wait in milliseconds
if "%1"=="" (set time=1000) else (set time=%1)
powershell -Command "$time = '!time!'; Write-Host "Pause for a $time ms"; Start-Sleep -m $time; exit"
set time=
exit /b



:msg
msg * [!application_name! %~2] ^: %~1
exit /b



:debug
if "%debug%"=="1" (
    echo.
    echo [93m[debug] : Pause on the end of a file . . .[0m
    timeout /t 60
    set debug=0
    goto :close
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
    msg * [!application_name! Notification] ^: !require_admin_msg1! !require_admin_msg2!
)
echo.
exit /b


