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
set pathToMods=%pathToFolder:~0,-9%\\DECODED
set pathToPowerShellScript=%pathToFolder%chooseMod_GUI.ps1

powershell Start-Process -FilePath \"%pathToFile%\" -ArgumentList \"unrestrict\" -Verb RunAs -Wait
for /f "delims=" %%a in ('powershell -File "%pathToPowerShellScript%" "%pathToMods%"') do set "outerValue=%%a"
powershell Start-Process -FilePath \"%pathToFile%\" -ArgumentList \"restrict\" -Verb RunAs -Wait
echo %pathToMods%\\%outerValue%
::pause