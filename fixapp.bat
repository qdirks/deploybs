@echo off
setlocal
call %~dp0_found
if %errorlevel%==1 exit /b 1
@REM browser-sync directory assumed

node ..\fixapp.js
