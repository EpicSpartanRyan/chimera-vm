@echo off
cd /d "%~dp0"

echo Verificando disco virtual de Chimera...
if not exist "chimera-disk.qcow2" (
    echo El disco no existe. Creando chimera-disk.qcow2 de 20GB...
    qemu-img create -f qcow2 chimera-disk.qcow2 20G
) else (
    echo El disco virtual ya existe. Omitiendo creacion.
)

REM Copiar las variables de UEFI localmente si no existen
if not exist "edk2-riscv-vars.fd" (
    copy "C:\Program Files\qemu\share\qemu\edk2-riscv-vars.fd" "edk2-riscv-vars.fd" >nul
)

echo Iniciando Chimera Linux (RISC-V) con UEFI y alto rendimiento...
qemu-system-riscv64 ^
  -M virt,pflash0=pflash0,pflash1=pflash1,acpi=off ^
  -cpu rv64 ^
  -smp 8 ^
  -m 16G ^
  -blockdev node-name=pflash0,driver=file,read-only=on,filename="C:\Program Files\qemu\share\qemu\edk2-riscv-code.fd" ^
  -blockdev node-name=pflash1,driver=file,filename="edk2-riscv-vars.fd" ^
  -drive file=chimera-disk.qcow2,format=qcow2,id=hd0,if=none ^
  -device virtio-blk-device,drive=hd0 ^
  -drive file="chimera-linux-riscv64-LIVE-20251220-plasma.iso",format=raw,id=cdrom,media=cdrom,if=none ^
  -device virtio-blk-device,drive=cdrom ^
  -device virtio-gpu-pci ^
  -display sdl,gl=on ^
  -serial stdio ^
  -netdev user,id=net0,hostfwd=tcp::2222-:22 ^
  -device virtio-net-device,netdev=net0

pause