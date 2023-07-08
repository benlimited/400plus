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

## Original Canon firmware for 400D

Good luck, not hosted on Canon's websites any more, best shot is from war3z sites 😞

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
