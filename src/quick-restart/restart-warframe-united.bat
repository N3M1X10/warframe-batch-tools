@echo off
chcp 65001>nul
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
:: ps1 script cpu-priority path
:: required to correctly setup this var for option below
set cpu-priority-ps1=%~dp0bin\powershell\cpu-priority\cpu-priority.ps1

:: Start Scrobbler-Autorestarter
:: possible: [1 / any else val]
:: default: '0'
set autorestart_scrobbler=0
:: ps1 script autorestart path
:: required to correctly setup this var for option below
set autorestart-ps1=%~dp0bin\powershell\autorestart\autorestart-scrobbler.ps1

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

::Description
:: Sets which game we looking for
:: ['Warframe' / 'Soulframe']
::Additional
:: Or in of order
:: ['1' / '2']
:: Where:
:: 1 - Warframe
:: 2 - Soulframe
set game=1

::debug mode (only for devs)
:: [1 / any else val]
::default: '0'
set debug=0

:: cpu-priority window mode switcher
:: [1 / any else val]
:: default: '0'
set keep_ps1=0

:: this option will set this script to request admin rights
:: [1 / any else val]
:: this option REQUIRED to correct working of this script, and added only for very specific debugging
:: default: '1'
set require_admin=1

:Constant-Params

:: default paths
set warframe=%LocalAppData%\Warframe\Downloaded\Public
set soulframe=%LocalAppData%\Soulframe\Downloaded\Public

set application_name=%~n0%~x0

set "adm_arg=%1"
set "hdn_arg=%2"

:End-Of-Params



:Start-Of-Application-Body

call :request-admin-rights
call :check-game-parameter
title Restart %game% (United)

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
            cd /d "!steam_warframe_path!"
            call :run_async "Tools\Launcher.exe" "-cluster:public -registry:Steam"

        ) else (
            :: Run wf through steam uri
            echo.&echo Trying to run Warframe via Steam . . .
            explorer "steam://rungameid/230410"

        )
    ) else (
        :: Starting via separated client launcher
        echo.&echo Trying to run Warframe via separated client launcher . . .
        call :check-path !warframe! game
        call :run_async "Tools\Launcher.exe"

    )
    echo.&echo Warframe is started

) else if "%game%"=="Soulframe" (
    rem Starting Soulframe
    rem Starting via separated client launcher
    echo For now, 'launch_type' is ignored by reason: there's no any else way to launch the game
    echo.&echo Trying to run Soulframe via separated client launcher . . .
    call :check-path !soulframe! game
    cd /d "!soulframe!"
    call :run_async "Tools\Launcher.exe"
    echo.&echo Soulframe is started

)


:: Call the ps1 scripts
if "%change_priority%"=="1" (
    call :cpu-priority
)

if "%autorestart_scrobbler%"=="1" (
    call :autorestart_scrobbler
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
            powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin\"' -Verb RunAs"
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
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin hidden\"' -Verb RunAs -WindowStyle Hidden"
                exit
            )
        ) else (
            rem if we don't need to be quiet
            if "%adm_arg%" == "admin" (
                rem admin requested
            ) else (
                echo [powershell] : Requesting admin rights . . .
                powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/c \"\"%~f0\" admin hidden\"' -Verb RunAs"
                exit
            )
        )
    )
)
exit /b



:: other functions
:check-path
set checking-path=%~1
set check-type=%~2
echo.&echo [93mTrying to check "%checking-path%" path . . .[0m
if "%check-type%"=="game" (
    echo We looking for a game launcher
    cd /d "%checking-path%"

    if not exist "Tools\Launcher.exe" (
        rem When path is incorrect
        if "%debug%"=="1" (
            echo.
            echo [101;93m! %game% launcher doesn't exist, unable to continue
            echo Make sure that the %game% launcher exists in: 
            echo "%checking-path%"[0m
            echo.
            echo Press any key to exit . . .
            pause>nul
        ) else (
            if "%checking-path%"=="" (
                call :msg "Error. %game% path is empty. Please setup it inside this script"
            ) else (
                call :msg "Error. %game% launcher doesn't exist in: "%checking-path%". Please make sure that path is correctly configured. Script was interrupted"
            )
        )
        set debug=0
        goto:close
    ) else (
        rem When path is correct
        echo Path checks is done
        exit /b
    )

rem For now, this is a reserved part of the code

) else if "%check-type%"=="folder" (
rem dn
) else if "%check-type%"=="file" (
rem dn
) else (
    echo Error. Incorrect check type
    exit /b
)

if exist "%checking-path%" (
    echo %check-type% "%checking-path%" has found
    exit /b 1
) else (
    echo %check-type% "%checking-path%" has not found
    exit /b 0
)

exit /b



:check-game-parameter
echo.&echo [93mChecking and fixing the game ('%game%') parameter . . .[0m

echo.&echo Trying to fix param character case . . .
for /F "delims=" %%i in ('echo %game% ^| find /i "soulframe"') do set game=Soulframe
for /F "delims=" %%i in ('echo %game% ^| find /i "warframe"') do set game=Warframe

echo.&echo Are this param is valid?
if "%game%" == "Warframe" (
    rem do nothing

) else if "%game%" == "Soulframe" (
    rem do nothing

) else if "%game%" == "1" (
    set game=Warframe

) else if "%game%" == "2" (
    set game=Soulframe

) else if "%game%"=="" (
    :: empty
    if "%debug%"=="1" (
        echo [91mError. Param 'game' is empty[0m
        echo [91mScript is going to be interrupted[0m
        pause
    ) else (
        call :msg "Error. Param 'game' is incorrect. Script was interrupted"
    )
    set debug=0
    goto :close

) else (
    :: else error
    if "%debug%"=="1" (
        echo [91mError. Param 'game' is incorrect[0m
        echo [91mScript is going to be interrupted[0m
        pause
    ) else (
        call :msg "Error. Param 'game' is incorrect. Script was interrupted"
    )
    set debug=0
    goto :close

)

echo Checks of 'game' param is done
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
call :msg "Error. Checking function for """"!checking_process!"""" has an exeption"
set debug=0
goto :close



:run_async
::exmpl
::call :run_async "Tools\Launcher.exe"
set "exe=%~1"
set "args=%~2"
start "" "%exe%" %args%
exit /b



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
        call :msg "!cpu-msg!"

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
call :start-pwsh "%cpu-priority-ps1%" !cpu-args!
exit /b



:autorestart_scrobbler
if "%game%" neq "Warframe" (
    echo [ERROR] Any game instead of Warframe is not supported by the 'autorestart_scrobbler' at this time
    exit /b
)
echo.&echo Starting '%autorestart-ps1%' script
call :start-pwsh "%autorestart-ps1%" ""
exit /b



:start-pwsh
set script=%~1
set args=%~2

if not exist "%script%" (
    rem if NOT exist
    if "%debug%"=="1" (
        echo.
        echo [101;93m "!script!" doesn't exist.
        echo But this is not a significant error. We have to continue.[0m
        exit /b
    ) else (
        call :msg "The script """"!script!"""" has not found. Cannot start %script% scanner."
    )
    exit /b
) else (
    rem if exist
    if "%debug%"=="1" (
        if "%keep_ps1%"=="1" (
            :: keep the window anyway
            start powershell.exe -NoProfile -NoExit -ExecutionPolicy Bypass -File "%script%" -Verb RunAs !args!
        ) else (
            :: keep the normal window until script is done
            start /min powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%script%" -Verb RunAs !args!
        )
    ) else (
        :: start the script silently, but wait for completion
        rem powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%script%" -Verb RunAs
        start /min powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%script%" -Verb RunAs !args!
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
msg * [!application_name!] ^: %~1
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


