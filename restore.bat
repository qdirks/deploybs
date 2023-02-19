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

git restore packages/browser-sync-client/package.json
git restore packages/browser-sync-ui/package.json
git restore packages/browser-sync/package.json