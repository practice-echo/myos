@echo off
cd /d "%~dp0\.."

echo [1/3] Compiling...
nasm -f bin boot/boot.asm -o build/boot.bin
if errorlevel 1 goto error

echo [2/3] Creating disk image...
dd if=/dev/zero of=images/hd.img bs=512 count=32768 2>nul
dd if=build/boot.bin of=images/hd.img bs=512 seek=0 count=1 conv=notrunc 2>nul

echo [3/3] Running QEMU...
qemu-system-x86_64 -drive format=raw,file=images/hd.img

goto end

:error
echo Build failed!
pause
:end