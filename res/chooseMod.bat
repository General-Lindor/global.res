@echo off

set pathToFile=%~F0

if "%1"=="unrestrict" (
    net session >nul 2>&1
    if not %errorLevel% == 0 (
        powershell Start-Process -FilePath \"!pathToFile!\" -ArgumentList \"unrestrict\" -Verb RunAs -Wait
        goto :EOF
    )
    powershell set-executionpolicy Unrestricted
    goto :EOF
)

if "%1"=="restrict" (
    net session >nul 2>&1
    if not %errorLevel% == 0 (
        powershell Start-Process -FilePath \"%pathToFile%\" -ArgumentList \"restrict\" -Verb RunAs -Wait
        goto :EOF
    )
    powershell set-executionpolicy AllSigned
    goto :EOF
)

set pathToFolder=%pathToFile:~0,-13%
set pathToMods=%pathToFolder:~0,-5%\\DECODED
set pathToPowerShellScript=%pathToFolder%chooseMod_GUI.ps1

::echo Unrestricting Execution Policy...
::echo We need to run a powershell script.
::echo By default you cannot run powershell scripts from batch unless the script is digitally signed ^(which actually costs money, yep microsoft makes money this way^)
::echo If you accept, you make it a little bit less safe for a moment but don't worry, we will restrict it again afterwards.
::echo If you want to, you can view the script that needs to be run. It's res/chooseMod_GUI.ps1. Completely harmless.
::echo If you do not accept, then this doesn't work and we cannot continue.
powershell Start-Process -FilePath \"%pathToFile%\" -ArgumentList \"unrestrict\" -Verb RunAs -Wait
for /f "delims=" %%a in ('powershell -File "%pathToPowerShellScript%" "%pathToMods%"') do set "outerValue=%%a"
powershell Start-Process -FilePath \"%pathToFile%\" -ArgumentList \"restrict\" -Verb RunAs -Wait
echo %pathToMods%\\%outerValue%
::pause