# rip.rb Internet Radio Song Title Scraper

rip.rb is an Internet radio station song title scraper. When downloading an internet radio steam (usually of the filetype .pls), the host and port of the radio station are saved inside the file. It is as simple as opening a text editor (or `cat radiostation.pls` on Linux) and looking at the resulting text.

For example, to save song titles from Soma.fm's *Groove Salad* one would run `ruby rip.rb voxsc1.somafm.com 3000`.

Enjoy!