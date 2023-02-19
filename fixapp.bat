@REM Use this after building and you see that app.js is showing changes when no changes have been made.
@REM Alternatively, you can revert the changes with git.
@REM The issue is the line endings in git don't match the line endings in app.js after building the project.
@REM This fixes that issue.

@echo off
setlocal
call %~dp0_found
if %errorlevel%==1 exit /b 1
@REM browser-sync directory assumed

node ..\fixapp.js
