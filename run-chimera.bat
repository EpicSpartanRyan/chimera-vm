@echo off
cd /d "%~dp0"

echo Verificando disco virtual de Chimera...
if not exist "chimera-disk.qcow2" (
    echo El disco no existe. Creando chimera-disk.qcow2 de 20GB...
    qemu-img create -f qcow2 chimera-disk.qcow2 20G
) else (
    echo El disco virtual ya existe. Omitiendo creacion.
)

echo Iniciando Chimera Linux (x86_64)...
qemu-system-x86_64 ^
    -accel whpx ^
    -cpu host ^
    -smp 8 ^
    -m 16G ^
    -drive file=chimera-disk.qcow2,format=qcow2,id=hd0,if=none ^
    -device virtio-blk-pci,drive=hd0 ^
    -drive file="chimera-linux-x86_64-LIVE-20251220-plasma.iso",format=raw,id=cdrom,media=cdrom,if=none ^
    -device ide-cd,drive=cdrom ^
    -device virtio-vga-gl ^
    -display sdl,gl=on ^
    -serial stdio ^
    -netdev user,id=net0,hostfwd=tcp::2222-:22 ^
    -device virtio-net-pci,netdev=net0

pause