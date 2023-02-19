@REM Build the local patched branch

@echo off
setlocal
set patched=patched
if -%1-==-debug- (
    set debug=true
)

call _create

git fetch origin >nul 2>&1
git switch -f master
git branch -D %patched%

git switch -c %patched%
echo Merging fixes...
git merge origin/fix-ui-external-url >nul
git merge origin/fix-logger >nul
git merge origin/fix-gitignore >nul
git merge origin/fix-cwd-option >nul
if defined debug (
    git merge origin/fix-scripts-debug >nul
) else (
    git merge origin/fix-scripts >nul
    git merge origin/fix-tsconfig >nul
)

rmdir /s /q packages\browser-sync\dist >nul 2>&1
rmdir /s /q packages\browser-sync-client\dist >nul 2>&1
rmdir /s /q packages\browser-sync-client\_dist >nul 2>&1

echo Building...
cmd /c "npm install" >nul
cmd /c "npm run build:cmd" >nul

echo Fixing files and updating references...
node ..\fixfiles.js >nul
git add .
git commit -m "save"
