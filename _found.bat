@echo off

if not exist packages cd browser-sync >nul 2>&1
if not exist packages (
    cd %~dp0
    cd browser-sync >nul 2>&1
)
if not exist packages (
    echo Couldn't find packages directory.
    exit /b 1
)
exit /b 0
