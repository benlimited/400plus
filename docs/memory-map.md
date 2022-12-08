# EOS 400D memory map

|addr|description|
|-|-|
|000053CC|Firmware version (string)|
|000053A8|Model name|
|00005410|Owner name|
|00005884|LensID|
|0000EBFC|Release count (as string/)|
|00016B60|DPData struct (see camera.h)|
|00200000-00800000|Main heap|
|007E0000-00800000|400plus is loaded here|
|C0220000|LEDBLUE|
|C02200A0|LEDRED|
|C0220130|BT_TRASH|
|C0220134|BTN_JUMP|
|FF800000|code|


|start|end|size|desc|
|-|-|-|-|
|00000000|00800000|8MiB|RAM|
|C0000000|||IO|
|FF800000|FFC00000?|4MiB?|flash|
