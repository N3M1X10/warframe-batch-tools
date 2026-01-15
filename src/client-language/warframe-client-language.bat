@echo off
chcp 65001>nul

:request-admin-rights
set adm_arg=%1
if "%adm_arg%" neq "admin" (
    echo [93m[powershell] Requesting admin rights...[0m
    powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Start-Process 'cmd.exe' -ArgumentList '/k \"\"%~f0\" admin\"' -Verb RunAs"
    exit /b
)

:ask
::menu session setup
chcp 65001>nul
title %~nx0
endlocal
setlocal EnableDelayedExpansion

set game=Warframe
set "REG_PATH=HKCU\Software\Digital Extremes\Warframe\Launcher"
set "CONFIG_FILE=languages.ini"
set "LANG_LIST=en fr it de es pt ru pl uk tr ja zh tc ko th"
call :save-config

:: Отрисовка меню
cls
echo [101;93mWarframe language menu[0m

echo.
echo [93mInfo:[0m
echo [93m- Choose language in this format: en[0m
for /f "tokens=3" %%A in ('reg query "%REG_PATH%" /v Language 2^>nul') do (
    set "CURR_LANG=%%A"
)
if defined CURR_LANG (
    echo [96m- Current language: "[93m%CURR_LANG%[96m"[0m
) else (
    echo [91mERROR PARSING CURRENT LANGUAGE[0m do not use 'upd'
)
echo.
echo [93mLanguages:[0m
for %%A in (%LANG_LIST%) do (
    set "item=%%A"
    echo [96m!item![0m
)
echo.
echo [93mOther options:[0m
echo [96mupd - [93mGet registry current data for current lang and cache it [91m(USE IT ONLY IF YOU HAVE ALREADY SIGNED THE LICENSE AGREEMENT)[0m
echo [96mk - [93mkill game launcher[0m
echo [96mx - [91mexit script[0m
echo.
set select=
set /p select="[96m%~nx0[92m>[0m"

:: defined options

if "%select%"=="upd" call :save-config & goto endfunc
if "%select%"=="k" call :kill-Launcher & goto endfunc
if "%select%"=="kill" call :kill-Launcher & goto endfunc

if "%select%"=="x"     goto close
if "%select%"=="X"     goto close
if "%select%"=="end"   goto close
if "%select%"=="exit"  goto close
if "%select%"=="close" goto close

set "found=0"
for %%L in (!lang_list!) do (
    if /i "%select%"=="%%L" set "found=1"
)
if "!found!"=="1" (
    call :change-lang "%select%"
)
:: mismatch
set draw_mismatch=1
if "!draw_mismatch!"=="1" (
    cls
    if "%select%"=="" (
        echo [91m[^^!] [93mEnter is empty[0m
    ) else (
        echo [91m[^^!] [93mHash for "[96m%select%[93m" has not found in database[0m
    )
    goto endfunc
)
goto ask



:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:change-lang
cls
set "new_lang=%~1"
set "eula_hash="
echo Changing language to "%new_lang%"...

echo.&echo Reading cached languages
call :read-config
echo done

if not defined eula_hash (
    echo.&echo Error. Config does not respponding. Reading the built-in database...
    call :lang_database
    for /f "tokens=2 delims==" %%V in ('set data_%new_lang% 2^>nul') do set "eula_hash=%%V"
    echo done
)

if not defined eula_hash (
    cls
    echo.
    echo [91m[^^!] [93mHash for "[96m%new_lang%[93m" has not found in database[0m
    echo Try updating hashes manually by launcher where you can sign eula then before go there and cache it.
    goto endfunc
)

echo.&echo [90mUsing EULA hash: '[93m%eula_hash%[90m'[0m
reg add "%REG_PATH%" /v Language /t REG_SZ /d %new_lang% /f >nul
reg add "%REG_PATH%" /v ReadEula /t REG_SZ /d %eula_hash% /f >nul
echo Done
goto endfunc
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:save-config
echo [*] starting checks for the config update...
set "REG_LANG=" & set "REG_HASH="
for /f "tokens=3" %%A in ('reg query "%REG_PATH%" /v Language 2^>nul') do set "REG_LANG=%%A"
for /f "tokens=3" %%A in ('reg query "%REG_PATH%" /v ReadEula 2^>nul') do set "REG_HASH=%%A"
if not defined REG_LANG (echo error. registry key of game language has not found&exit /b) else (echo done)
echo [*] checking data from the cache against the registry...
set "CUR_F_HASH="
if exist "%CONFIG_FILE%" for /f "usebackq tokens=1,2 delims==" %%i in ("%CONFIG_FILE%") do if /i "%%i"=="%REG_LANG%" set "CUR_F_HASH=%%j"
if /i "%CUR_F_HASH%"=="%REG_HASH%" (echo [i] config same as registry. done&exit /b) else (echo [i] detected differences)
echo [^>] ordered override...
(for %%L in (%LANG_LIST%) do (
    if /i "%%L"=="%REG_LANG%" (
        echo %%L=%REG_HASH%
    ) else (
        set "OLD_V="
        if exist "%CONFIG_FILE%" for /f "usebackq tokens=1,2 delims==" %%i in ("%CONFIG_FILE%") do if /i "%%i"=="%%L" set "OLD_V=%%j"
        if defined OLD_V (call echo %%L=%%OLD_V%%)
    )
)) > "%CONFIG_FILE%.tmp"
move /y "%CONFIG_FILE%.tmp" "%CONFIG_FILE%" >nul
echo [i] config update completed
exit /b



:read-config
if not exist "%CONFIG_FILE%" exit /b
for /f "usebackq tokens=1,2 delims==" %%i in ("%CONFIG_FILE%") do (
    if /i "%%i"=="%new_lang%" set "eula_hash=%%j"
)
exit /b



:lang_database
:: default hashes table [upd: 2026-01-11]
set "data_en=7110700521B4706047841B38F0DBB5C1"
set "data_fr=A5BBEB49856DEB17FD070FA4814E1883"
set "data_it=4F4A98114EF7257EA3097F842C244C8A"
set "data_de=F8662A972FA54405545EABAFDDBA7605"
set "data_es=5CBF077DE9350EA7305450E020D92773"
set "data_pt=E10E0E92F5EA2A75B4094C1ABA61D54F"
set "data_ru=9331ADDE65A29752951A85D5F7A272F7"
set "data_pl=A979640C8C091F4FFF964A52FD84265F"
set "data_uk=BDD053603B77E8B0BE8DF259CC378932"
set "data_tr=4A023D17A359F9F7D5ACBAF2234DD284"
set "data_ja=A437A796098A473AE85F6D25AB06A0C7"
set "data_zh=8479ED9C36DA7620DDE368AF1CFC9C8F"
set "data_tc=E3053C36BF6E7B65B037E78E17562154"
set "data_ko=2122A0E97ABB9C5988CF0E0A9F35F93D"
set "data_th=61E6578B8059BF9432BC91C58023D2E5"
exit /b



:kill-Launcher
echo.&echo [93mTrying to terminate the Game Launcher . . .[0m
powershell -NoLogo -NoProfile -Command "Get-Process Launcher | Where-Object { $path = $_.Path; if ($path.Contains('%game%')) { Write-Host 'Killing Process...'; Stop-Process -Id $_.Id; } }">nul
echo Done
exit/b


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: end of a function
:endfunc
echo.&echo [36m[!time!] Function execution is completed^^!
if !exaf!==1 (endlocal&exit/b)
echo Press any button to return to the main menu...[0m
pause>nul&endlocal&cls
goto :ask



:close
endlocal
exit
