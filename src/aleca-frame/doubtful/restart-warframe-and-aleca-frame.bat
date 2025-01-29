@echo off
chcp 65001>nul

:: Options

:: overwolf path
set overwolf=G:\Program Files (x86)\Tools\overwolf\

:: warframe default launcher's directory
set warframe=%LocalAppData%\Warframe\Downloaded\Public


:: Restart with Admin Rights and minimize the window
set "arg=%1"
if "%arg%" == "admin" (
    echo ! Restarted with admin rights and minimized
) else (
    powershell -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

cd /d "%warframe%"
IF NOT EXIST "Tools\Launcher.exe" (
cls
echo [101;93m! Warframe directory doesn't exist, unable to continue
echo Make sure that the Warframe directory exists in: 
echo "%warframe%"[0m
pause>nul&exit
)
cd /d "%overwolf%"
IF NOT EXIST "OverwolfLauncher.exe" (
cls
echo [101;93m! Overwolf directory doesn't exist, unable to continue
echo Please configure correct path in this file[0m
pause>nul&exit
)

rem goto run_overwolf

:warframe_kill
>nul taskkill /f /im "Launcher.exe" /t
>nul taskkill /f /im "Warframe.x64.exe" /t
>nul timeout /t 1 /nobreak

:overwolf_kill
>nul taskkill /f /im "Overwolf.exe" /t
>nul taskkill /f /im "OverwolfLauncher.exe" /t
>nul taskkill /f /im "OverwolfHelper64.exe"
>nul taskkill /f /im "OverwolfHelper.exe"
>nul taskkill /f /im "OverwolfBrowser.exe"

:run_overwolf
cd /d "%overwolf%"
start "" "OverwolfLauncher.exe" ^
-launchapp afmcagbpgggkpdkokjhjkllpegnadmkignlonpjm -from-startmenu
cls

:aleca_cycle
set att_count=1
set process_title=Overwolf.exe
set att_amount=120
:cycle
cls
echo Attempt for sniff out the AlecaFrame: %att_count%
>nul timeout /t 1 /nobreak
tasklist /FI "WINDOWTITLE eq AlecaFrame"^
 |>nul findstr /b /l /i /c:%process_title% && goto run_warframe
if %att_count% geq %att_amount% (goto sniff_fail)
set /a att_count=%att_count%+1
goto cycle

:sniff_fail
echo.
echo I tired of sniffing out the AlecaFrame, i gotta go
echo Ошибка, долго не могу найти окно AlecaFrame
echo Нажмите любую кнопку чтобы выйти
>nul timeout /t 10 &exit

:run_warframe
echo I smelled it !!!
::warframe start (starting with separated client launcher)
cd /d "%warframe%"
start "Tools\" "Tools\Launcher.exe"
:: Source: https://github.com/N3M1X10/warframe-batch-tools

:end
exit
