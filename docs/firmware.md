# Notes and links on firmware files

We probably don't need to worry about `.fir` firmware files too much. The 400D is well past EOL and will never get another update, but it might be interesting to dump the assembly to learn more about the camera's internals.

## testfir.fir

What does it do exactly? Where's the source? Who made it?

I can't find much about this other than that it supposedly flips some boot flag enabling loading the `autoexec.bin` file from the CF card.

## Links to Magic Lantern / CHDK wiki & forum

[Packing FIR files](https://magiclantern.fandom.com/wiki/Packing_FIR_Files)

[FIR related tools for developers](https://chdk.setepontos.com/index.php?topic=6523.0)

[Fir_tool 0.5 for 5D/30D/400D and for 1Dm3 -> 7D](https://chdk.setepontos.com/index.php/topic,5161.0.html)

[on encryption in FIR files](https://chdk.setepontos.com/index.php/topic,134.msg2461.html#msg2461)

## Original Canon firmware for EOS Digital Rebel XTi / EOS 400D Digital cameras

Unfortunately, the official firmware download page on Canon's website has disappeared 😞, but
it's still possible to download the firmware via [Wayback Machine](https://archive.org).

Self-extracting (.exe) archive for Windows platform (seems like MacOS .dmg was not archived)
is still available on the [archived snapshot of the Canon website](https://web.archive.org/web/20080507103407/http://web.canon.jp/imaging/eosdigital3/e4kr3_firmware-e.html).

In order to extract the firmware file (`e4kr3111.fir`), the known options currently
running the .exe either on Windows or via Wine.

As an alternative, it's possible to exract archive contents using 7z, but the firmware file
itself seems to be compressed using [StuffIt](https://en.wikipedia.org/wiki/StuffIt) which does
not have any up-to-date open source decompresseors available.

## Preparing the CF Card

1. Find the device, e.g. with `fdisk -l`
2. Card must be formatted as FAT12 or FAT16 for cards up to 2GB, or FAT32 if 4GB or larger

### FAT12/16

```sh
dev=/dev/sdX1
echo EOS_DEVELOP | sudo dd of="$dev" bs=1 seek=43 count=11
echo BOOTDISK | sudo dd of="$dev" bs=1 seek=64 count=8
```

### FAT32

```sh
dev=/dev/sdX1
echo EOS_DEVELOP | sudo dd of="$dev" bs=1 seek=71 count=11
echo BOOTDISK | sudo dd of="$dev" bs=1 seek=92 count=8
```
