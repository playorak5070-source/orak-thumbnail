@echo off
chcp 949 >nul
setlocal enabledelayedexpansion
title ORAK 5070 thumbnail render

rem 이 파일을 두 번 누르면 orak.css 가 있는 폴더의 HTML을 전부 PNG로 뽑습니다.
rem PNG는 그 한 단계 위 폴더에 떨어집니다. 폴더를 어디에 두든 됩니다.
rem 한글 폴더 이름을 적지 않고 직접 찾아내므로 경로가 깨지지 않습니다.

set "HERE=%~dp0"

set "CSS="
for /f "delims=" %%A in ('dir /b /s "%HERE%orak.css" 2^>nul') do if not defined CSS set "CSS=%%A"
if not defined CSS goto NOSRC

for %%A in ("%CSS%") do set "SRC=%%~dpA"
set "SRCT=%SRC:~0,-1%"
for %%A in ("%SRCT%") do set "OUT=%%~dpA"

set "CHROME="
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if not defined CHROME goto NOCHROME

set "PROF=%TEMP%\orak_thumb_profile"
set "OPT=--headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files --window-size=1080,1920 --virtual-time-budget=12000"

echo.
echo  원본 : %SRCT%
echo  저장 : %OUT%
echo.

set /a N=0
for %%F in ("%SRCT%\0*.html" "%SRCT%\1*.html") do call :SHOT "%%~fF" "%%~nF"

echo.
echo  끝났습니다. !N!장을 뽑았습니다.
echo.
echo  [꼭 하세요] 뽑은 PNG를 열어 눈으로 확인해 주세요.
echo              글자가 겹치거나 잘린 곳은 그림을 봐야만 보입니다.
echo.
pause
exit /b 0

:SHOT
set "NAME=%~2"
if /i "!NAME:~0,1!"=="_" exit /b 0
echo   뽑는 중 ... !NAME!
"%CHROME%" %OPT% --user-data-dir="%PROF%" --screenshot="%OUT%!NAME!.png" "file:///%~1" >nul 2>&1
set /a N+=1
exit /b 0

:NOCHROME
echo.
echo  [멈춤] 크롬을 찾지 못했습니다. 구글 크롬을 설치한 뒤 다시 실행해 주세요.
echo.
pause
exit /b 1

:NOSRC
echo.
echo  [멈춤] orak.css 를 찾지 못했습니다.
echo         이 파일은 썸네일_작업 폴더 맨 위에 있어야 합니다.
echo.
pause
exit /b 1
