#https://gist.github.com/ogerardin/fb3b615a1a1daaec31966edbb47681c0

$QP = "C:\Program Files\qemu\"
$QIMG = "$QP" + "qemu-img.exe"
$QSYST = "$QP" + "qemu-system-x86_64.exe"
$ALPINE_EXTENDED ="http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-extended-3.12.0-x86_64.iso"

echo "Creating disk image"
& $QIMG create -f qcow2 hd.img 10G
echo "Downloading alpine linux"
(new-object net.webclient).DownloadFile($ALPINE_EXTENDED,'alpine-extended-3.12.0-x86_64.iso')


#..\qemu\qemu-system-x86_64.exe -m 2G -k none -nic user,ipv6=off,hostfwd=tcp::22022-:22 -boot order=cd -drive file=hd.img,format=raw,index=0,media=disk -cdrom alpine-extended-3.7.0-x86_64.iso 
#@if errorlevel 1 pause