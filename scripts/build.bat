@echo off
cd /d "%~dp0\.."

REM ======================================
REM 编译脚本
REM 用法: build.bat [源文件] [镜像名]
REM 镜像名自动保存到 images/ 目录
REM ======================================

set BUILD_DIR=build
set IMAGES_DIR=images
set BOOT_SRC=%1
set IMG_NAME=%2

if "%BOOT_SRC%"=="" set BOOT_SRC=boot\boot.asm
if "%IMG_NAME%"=="" set IMG_NAME=hd.img

REM 确保镜像名不带路径，统一放到 images/ 下
for %%i in ("%IMG_NAME%") do set IMG_NAME=%%~nxi
set IMG_PATH=%IMAGES_DIR%\%IMG_NAME%

echo Building: %BOOT_SRC% -> %IMG_PATH%
echo.

if not exist %BUILD_DIR% mkdir %BUILD_DIR%

nasm -f bin %BOOT_SRC% -o %BUILD_DIR%\temp.bin
if errorlevel 1 (
    echo ERROR: Compilation failed!
    pause
    exit /b 1
)

if not exist %IMAGES_DIR% mkdir %IMAGES_DIR%

dd if=/dev/zero of=%IMG_PATH% bs=512 count=32768 2>nul
dd if=%BUILD_DIR%\temp.bin of=%IMG_PATH% bs=512 seek=0 count=1 conv=notrunc 2>nul

echo Done: %IMG_PATH%
pause