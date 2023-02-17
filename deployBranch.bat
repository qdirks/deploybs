@echo off
setlocal

set package_name=%*

cd packages\%package_name%

echo ---- Now running operations for the following package: %package_name%

@REM Remove items from the .remove file
echo Removing items in .remove file...
for /f %%F in (%~dp0%package_name%.remove) do git rm --cached %%F >nul 2>&1

@REM Ignore items from the .remove file
echo Ignoring items in .remove file...
type nul>.gitignore
for /f %%F in (%~dp0%package_name%.remove) do echo /%%F>>.gitignore

echo Adding changes to be committed
git add . >nul
git restore --staged LICENSE

@REM Deploy package as branch
git switch -c %package_name%
git commit -m "Deploy %package_name% as git branch so that npm can install it." >nul
echo Pushing to remote branch %package_name%
git push -u origin %package_name% >nul 2>&1
