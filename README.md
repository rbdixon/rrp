# Brad's Project Template

## Installing ggmap on Homebrew Macs

This appears to be required:

```
$ cat ~/.R/Makevars 
PKG_CFLAGS=-I/opt/boxen/homebrew/include
PKG_LIBS=-L/opt/boxen/homebrew/lib -ljpeg
```