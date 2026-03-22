@echo off
cd /d "%~dp0\.."

set FILE=%1
if "%FILE%"=="" set FILE=hd.img

REM 统一使用 images/ 路径
set IMG_PATH=images\%FILE%

if not exist %IMG_PATH% (
    echo ERROR: %IMG_PATH% not found!
    pause
    exit /b 1
)

qemu-system-x86_64 -drive format=raw,file=%IMG_PATH%