# amdek-310a
My setup for driving and Amdek Video-310A MDA monitor with a Raspberry Pi. Visit [https://narlotl.github.io/amdek-310a](https://narlotl.github.io/amdek-310a) or the [demo branch](https://github.com/Narlotl/amdek-310a/tree/demo) to see it in action. 


## Setting up

**(Required)**

- Clone the repository to your home directory. I used [YADM](https://yadm.io/) to make this easier.
- Move `boot_config.txt` to `/boot/firmware/config.txt`. This is what tells the Pi to generate MDA output on the GPIO.
- Connect the GPIO pins to the MDA cable. See [Wiring](#wiring) for details.

**(Not required but makes seeing the terminal much easier)**
  
- Move `console-setup` to `/etc/default/console-setup` to make the TTY clearly readable.
- Run `setvtrgb ~/.config/tty_colors.conf` at startup to make all the terminal colors show up. This sets all colors except white to `(255, 0, 0)` (red), which shows up as mid brightness on the screen. Without this, some colors like green won't be visible as they don't produce red or blue output (see [Notes](#notes)).


### Wiring

This uses the Raspberry Pi's [DPI](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#display-parallel-interface-dpi) mode to output video signals on the GPIO.

Connect these GPIO pins to the pins on the monitor cable:
| GPIO Pin   | MDA Pin       |
| ---------- | ------------- |
| Ground     | 1, 2 (Ground) |
| 3 (V-Sync) | 9 (V-Sync)    |
| 5 (H-Sync) | 8 (H-Sync)    |
| 21 (Blue)  | 6 (Intensity) |
| 22 (Red)   | 7 (Video)     |

**GPIO Diagram**

<a href="https://pinout.xyz/pinout/dpi"><img width="390" height="390" alt="GPIO diagram" src="https://github.com/user-attachments/assets/954517cc-358f-4970-96ec-682a1246937b" /></a>

**MDA Diagram**

<img width="390" height="197" alt="MDA pins" src="https://github.com/user-attachments/assets/6f736002-9d8c-4062-b96a-b5e046e01338#gh-dark-mode-only" />
<img width="390" height="197" alt="image" src="https://github.com/user-attachments/assets/33bf8e4f-dbd9-440c-8d2d-98e408b078d7#gh-light-mode-only" />


### Software

- [i3](https://i3wm.org/) for the desktop.
- [picom](https://github.com/yshui/picom) to put a shader over the desktop (see [Shaders](#shaders)).
- [kitty](https://sw.kovidgoyal.net/kitty/) for the terminal.
- [DOSBox](https://www.dosbox.com/) for DOS applications. There is a config at `~/.config/dosbox/dosbox.conf` that sets DOSBox to run at the correct resolution. Run `dosbox -conf ~/.config/dosbox/dosbox.conf` to use it.


#### Shaders

I have two picom shaders: [dither.glsl](https://github.com/Narlotl/amdek-310a/blob/main/.config/picom/dither.glsl) and [simple.glsl](https://github.com/Narlotl/amdek-310a/blob/main/.config/picom/simple.glsl). The dither shader uses [ordered dithering](https://en.m.wikipedia.org/wiki/Ordered_dithering) to work around the limited amount of brightness levels. The simple shader just converts the pixel to grayscale and outputs the corresponding red and blue values (see [Notes](#notes)). You can change the thresholds for video and intensity by adjusting the numbers in the `r` and `b` variables in each shader. Lowering the number raises how bright a pixel has to be to meet the threshold while raising it lowers that threshold.

The dither shader is better suited for media and modern games where a lot of color is expected and pixel-level detail is less important. Dithering does take some detail, so the simple shader is better for old applications and games that are designed for limited colors or text where dithering is unnecessary because there is only a light and dark color.


## Notes

I use the red color channel for the MDA video pin (pin 7), which corresponds to 2/3 brightness on the 310A. I use the blue channel for the intensity pin (pin 6), which is 1/3 brightness. Although some monitors have 4, the 310A only has 3 brightness levels: off, mid, and bright. If the video pin is off, no pixel will show.

| Intensity | Video | Display |
| --------- | ----- | ------- |
|     0     |   0   |   Off   |
|     1     |   0   |   Off   |
|     0     |   1   |   Mid   |
|     1     |   1   |  Bright |

### References

#### Amdek Video-310A
- [Amdek Video 310A Monitor - National Museum of American History](https://americanhistory.si.edu/collections/object/nmah_1321868)
- [I ruined this Amdek 300A after fixing it - Adrian's Digital Basement \]\[](https://www.youtube.com/watch?v=7blLes8Vgbs)
- [Unboxing a New 1980s Amdek Monochrome Monitor - LGR](https://www.youtube.com/watch?v=XphXo2BSjL4)
- [IBM 5150 and Amdek 310a amber monochrome monitor - Ancient Electronics](https://www.youtube.com/watch?v=3nGW_pe08ts)
#### Monochrome display adapter
- [IBM Monochrome Display Adapter - Wikipedia](https://en.m.wikipedia.org/wiki/IBM_Monochrome_Display_Adapter)
- [Monochrome Display Adapter Notes - John Elliott](https://www.seasip.info/VintagePC/mda.html)
- [IBM:  MDA / CGA / EGA - minuszerodegrees](https://www.minuszerodegrees.net/mda_cga_ega/mda_cga_ega.htm)
- [ArduinoCGADriver - Cristophe Diericx](https://github.com/christophediericx/ArduinoCGADriver)
- [1BPP is enough! Arduino driving an Amdek 310A - discatte](https://www.reddit.com/r/crtgaming/comments/fkk4ia/1bpp_is_enough_arduino_driving_an_amdek_310a/)
#### DPI
- [Raspberry Pi hardware - Rasperry Pi Documentation](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#display-parallel-interface-dpi)
- [DPI - Raspberry Pi GPIO Pinout](https://pinout.xyz/pinout/dpi)
#### Dithering
- [Ordered dithering - Wikipedia](https://en.m.wikipedia.org/wiki/Ordered_dithering)
- [Arbitrary-palette positional dithering algorithm - Joel Yliluoma](https://bisqwit.iki.fi/story/howto/dither/jy/)
