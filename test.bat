@echo off
setlocal
call %~dp0_found
if %errorlevel%==1 exit /b 1

node packages\browser-sync\dist\bin.js start --server --browser --cwd "H:\sazzlefrazzle"
