@if (@CodeSection == @Batch) @then

@echo off

TITLE batchDecoder

set /A cnt = 0
if "%1"=="de_DE" (
    set /A cnt = 0
)
if "%1"=="ru_RU" (
    set /A cnt = 1
)
if "%1"=="en_UK" (
    set /A cnt = 2
)
if "%1"=="fr_FR" (
    set /A cnt = 3
)
if "%1"=="es_ES" (
    set /A cnt = 4
)
if "%1"=="it_IT" (
    set /A cnt = 5
)
if "%1"=="hu_HU" (
    set /A cnt = 6
)
if "%1"=="pl_PL" (
    set /A cnt = 7
)
::if "%1"=="cz_CZ" (
if "%1"=="Cz" (
    set /A cnt = 8
)
::if "%1"=="jp_JP" (
if "%1"=="Jp" (
    set /A cnt = 9
)

rem Use %SendKeys% to send keys to the keyboard buffer
set SendKeys=CScript //nologo //E:JScript "%~F0"

rem Start the other program in another window
START "applicationDecoder" S2rw.v1.7.exe
timeout /t 5 /nobreak

%SendKeys% "{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}"
for /l %%x in (0, 1, %cnt%) do (
    %SendKeys% "{DOWN}"
)
%SendKeys% "{TAB}{ENTER}"
timeout /t 10 /nobreak
%SendKeys% "{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{ENTER}"

goto :EOF


@end

// JScript section

var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.AppActivate("applicationDecoder");
WshShell.AppActivate("Sacred 2 Reader / Writer");
WshShell.SendKeys(WScript.Arguments(0));