@echo off
setlocal

if not exist packages cd browser-sync
if not exist packages (
    cd %~dp0
    cd browser-sync
)
if not exist packages (
    echo Couldn't find packages directory.
    exit /b
)

cmd /c "npm run build:cmd"
call ..\fixapp.bat
