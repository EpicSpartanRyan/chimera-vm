@echo off
cd /d "%~dp0"

echo [1/2] Creando copia de seguridad automatica (chimera-disk.qcow2.bkp)...
copy /y chimera-disk.qcow2 chimera-disk.qcow2.bkp

echo [2/2] Iniciando Chimera Linux con aceleracion grafica...
qemu-system-x86_64 ^
    -accel whpx ^
    -cpu host ^
    -smp 8 ^
    -m 16G ^
    -drive file=chimera-disk.qcow2,format=qcow2,id=hd0,if=none ^
    -device virtio-blk-pci,drive=hd0 ^
    -device virtio-vga-gl ^
    -display sdl,gl=on ^
    -device qemu-xhci ^
    -device usb-tablet ^
    -serial stdio ^
    -netdev user,id=net0,hostfwd=tcp::2222-:22 ^
    -device virtio-net-pci,netdev=net0

pause