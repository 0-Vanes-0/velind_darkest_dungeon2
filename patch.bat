@echo off
setlocal EnableDelayedExpansion

REM !!!!! You can execute this file via Steam. Open Properties -> Launch Options: "C:\<path_to_repository>\velind_darkest_dungeon2\patch.bat" %command%

REM Folder where this script lives
set "SCRIPT_DIR=%~dp0"

REM 1) Read the FULL path from the text file
for /f "usebackq delims=" %%A in ("%SCRIPT_DIR%DD2_filepath_to_patch.txt") do (
    if not defined FULLPATH set "FULLPATH=%%A"
)

if not defined FULLPATH (
    echo ERROR: DD2_filepath_to_patch.txt is empty or missing.
    pause
    exit /b 1
)

REM 2) Get the PARENT folder of that path (strip the last \name)
REM    %%~dpI gives drive + path with trailing backslash, no filename
for %%I in ("%FULLPATH%") do set "BASEPATH=%%~dpI"

REM Remove trailing backslash from BASEPATH
if "%BASEPATH:~-1%"=="\" set "BASEPATH=%BASEPATH:~0,-1%"

echo Parent folder is:
echo "%BASEPATH%"
echo.

REM 3) Find the actual "Darkest Dungeon® II" directory using a wildcard
REM    "?" stands for exactly one character (here, the ®)
set "GAME_DIR="
for /d %%G in ("%BASEPATH%\Darkest Dungeon? II") do (
    if not defined GAME_DIR set "GAME_DIR=%%G"
)

if not defined GAME_DIR (
    echo ERROR: Could not find "Darkest Dungeon? II" inside:
    echo   "%BASEPATH%"
    pause
    exit /b 1
)

REM 4) Build the final target directory
set "TARGET_DIR=%GAME_DIR%\Darkest Dungeon II_Data\StreamingAssets\Localization\Poedit"

echo Using target directory:
echo "%TARGET_DIR%"
echo.

if not exist "%TARGET_DIR%" (
    echo Wrong path!
	pause
	exit /b 1
)

REM 5) Copy everything from "po files" into the target directory
xcopy "%SCRIPT_DIR%po files\*" "%TARGET_DIR%\" /E /I /Y

echo.
echo Patch done! Starting game...

REM 6) If called from Steam with %command%, start the game afterwards
REM    Steam will pass the game exe as %1
if not "%~1"=="" (
    echo Starting game...
    start "" %1
)

endlocal
