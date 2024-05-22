:: fchooser.bat
:: launches a folder chooser and outputs choice to the console
:: https://stackoverflow.com/a/15885133/1683264

@echo off
setlocal

::set pathway=%1
set pathway=%~dp0
set pathway="%pathway:~0,-4%MODS"

set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please choose a folder.',0,'%pathway%').self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"

setlocal enabledelayedexpansion
echo !folder!
endlocal