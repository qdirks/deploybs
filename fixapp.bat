@echo off
setlocal

if not exist packages cd browser-sync
if not exist packages (
    echo No packages directory. Check your current working directory. Script will now exit.
    exit /b
)

node ..\fixapp.js