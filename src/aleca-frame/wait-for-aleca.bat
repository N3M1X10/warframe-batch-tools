
@echo off
chcp 65001>nul

:aleca_cycle
set att_count=1
set process_title=Overwolf.exe
set att_amount=3
:cycle
echo Attempt for sniff out the AlecaFrame: %att_count%
>nul timeout /t 2 /nobreak
rem tasklist /FI "WINDOWTITLE eq AlecaFrame"
tasklist /FI "WINDOWTITLE eq AlecaFrame"^
 |>nul findstr /b /l /i /c:%process_title% || echo I can't smell Aleca!
 tasklist /FI "WINDOWTITLE eq AlecaFrame"^
 |>nul findstr /b /l /i /c:%process_title% && echo I smelled it !!!
if %att_count% geq %att_amount% (echo I tired of sniffing out the AlecaFrame, i gotta go &pause>nul&exit)
set /a att_count=%att_count%+1
echo.
goto cycle

:end
echo.
echo cmd is stupid now &pause>nul&exit
