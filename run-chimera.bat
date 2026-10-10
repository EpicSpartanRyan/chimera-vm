@echo off
cd /d "%~dp0"

echo Verificando disco virtual de Chimera...
if not exist "chimera-disk.qcow2" (
    echo El disco no existe. Creando chimera-disk.qcow2 de 20GB...
    qemu-img create -f qcow2 chimera-disk.qcow2 20G
) else (
    echo El disco virtual ya existe. Omitiendo creacion.
)

echo Iniciando Chimera Linux (RISC-V) con alto rendimiento...
qemu-system-riscv64 ^
  -M virt ^
  -cpu rv64 ^
  -smp 8 ^
  -m 16G ^
  -bios default ^
  -drive file=chimera-disk.qcow2,format=qcow2,id=hd0,if=none ^
  -device virtio-blk-device,drive=hd0 ^
  -drive file="chimera-linux-riscv64-LIVE-20251220-plasma.iso",format=raw,id=cdrom,media=cdrom,if=none ^
  -device virtio-blk-device,drive=cdrom ^
  -device virtio-gpu-pci ^
  -display sdl,gl=on ^
  -netdev user,id=net0,hostfwd=tcp::2222-:22 ^
  -device virtio-net-device,netdev=net0

pause