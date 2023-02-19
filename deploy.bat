@REM Deploy the current patched build, or master build if no patched

@echo off
setlocal
set patched=patched

call _create

git switch master -f

echo Copying .git folder to each of the packages...
xcopy /e /i /y .git packages\browser-sync\.git >nul
xcopy /e /i /y .git packages\browser-sync-ui\.git >nul
xcopy /e /i /y .git packages\browser-sync-client\.git >nul

git switch %patched%
git push origin --delete browser-sync
git push origin --delete browser-sync-ui
git push origin --delete browser-sync-client

echo Deploying...
call ..\deployBranch browser-sync
call ..\deployBranch browser-sync-client
call ..\deployBranch browser-sync-ui

echo ---- removing git directories
rmdir /s /q packages\browser-sync\.git
rmdir /s /q packages\browser-sync-ui\.git
rmdir /s /q packages\browser-sync-client\.git
echo ---- operation complete
