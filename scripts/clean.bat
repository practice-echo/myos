@echo off
cd /d "%~dp0\.."

echo ========================================
echo Cleaning
echo ========================================
echo.

if exist build (
    del /q build\* 2>nul
    echo   Cleaned build/
) else (
    echo   build/ not found
)

if exist debug (
    del /q debug\* 2>nul
    for /d %%i in (debug\*) do rmdir /s /q "%%i" 2>nul
    echo   Cleaned debug/
)

if exist images (
    del /q images\* 2>nul
    echo   Cleaned images/
) else (
    echo   images/ not found
)

echo.
echo Clean completed.
pause