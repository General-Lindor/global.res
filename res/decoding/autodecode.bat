@if (@CodeSection == @Batch) @then

@echo off

set /A cnt = 0
if "%1"=="De" (
    set /A cnt = 0
)
if "%1"=="Ru" (
    set /A cnt = 1
)
if "%1"=="En" (
    set /A cnt = 2
)
if "%1"=="Fr" (
    set /A cnt = 3
)
if "%1"=="Sp" (
    set /A cnt = 4
)
if "%1"=="It" (
    set /A cnt = 5
)
if "%1"=="Hu" (
    set /A cnt = 6
)
if "%1"=="Pl" (
    set /A cnt = 7
)
if "%1"=="Cz" (
    set /A cnt = 8
)
if "%1"=="Jp" (
    set /A cnt = 9
)



rem Use %SendKeys% to send keys to the keyboard buffer
set SendKeys=CScript //nologo //E:JScript "%~F0"

rem Start the other program in the same Window
start "blablablub" /B S2rw.v1.7.exe

%SendKeys% "{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}"
for /l %%x in (0, 1, %cnt%) do %SendKeys% "{DOWN}"
%SendKeys% "{TAB}{ENTER}"
timeout 10
%SendKeys% "{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{ENTER}"
timeout 1

goto :EOF


@end


// JScript section

var WshShell = WScript.CreateObject("WScript.Shell");
WshShell.AppActivate("blablablub");
WScript.Sleep(100);
WshShell.SendKeys(WScript.Arguments(0));