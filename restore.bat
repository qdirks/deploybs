@REM You may need to call this after building
@echo off
setlocal
call %~dp0_found
if %errorlevel%==1 exit /b 1

git restore packages/browser-sync-client/package.json
git restore packages/browser-sync-ui/package.json
git restore packages/browser-sync/package.json
