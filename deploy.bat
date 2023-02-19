@echo off
setlocal
set patched=patched

if not exist browser-sync (
    git clone https://github.com/qdirks/browser-sync.git
)

cd browser-sync

git fetch origin >nul 2>&1
git switch -f master
git branch -D %patched%
git push origin --delete browser-sync
git push origin --delete browser-sync-ui
git push origin --delete browser-sync-client

echo Copying .git folder to each of the packages...
xcopy /e /i /y .git packages\browser-sync\.git >nul
xcopy /e /i /y .git packages\browser-sync-ui\.git >nul
xcopy /e /i /y .git packages\browser-sync-client\.git >nul

git switch -c %patched%
echo Merging fixes...
git merge origin/fix-ui-external-url >nul
git merge origin/fix-scripts >nul
git merge origin/fix-logger >nul
git merge origin/fix-gitignore >nul
git merge origin/fix-cwd-option >nul
git merge origin/fix-tsconfig >nul

rmdir /s /q packages\browser-sync\dist >nul 2>&1
rmdir /s /q packages\browser-sync-client\dist >nul 2>&1
rmdir /s /q packages\browser-sync-client\_dist >nul 2>&1

echo Building...
cmd /c "npm install" >nul
cmd /c "npm run build:cmd" >nul

echo Fixing files and updating references...
node ..\fixfiles.js >nul

echo Deploying...
call ..\deployBranch browser-sync
call ..\deployBranch browser-sync-client
call ..\deployBranch browser-sync-ui

echo ---- removing git directories
rmdir /s /q packages\browser-sync\.git
rmdir /s /q packages\browser-sync-ui\.git
rmdir /s /q packages\browser-sync-client\.git
echo ---- operation complete

call ..\restore
