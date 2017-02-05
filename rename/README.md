# What is ...
**remove-dia.sh** is a shell script for removing diacritics from file name. It depends on iconv for converting file
 names from one encoding to another. Despite support of diacritics in file names for most modern file systems I still
 prefer old-style ASCII style file naming convention to avoid any potential problems. This utility can be used to remove
 diacritics from any file names, not only mp3's. The internal id3 metadata are not affected by diacritics removal renaming.
 
**rename-titleize.sh** is a shell script for renaming/titleizing file names. Titleize just capitalize the first character
 of each word in file name. Obviously this makes sanse only on case sensitive filesystems like unix (windows filesystems
 as so far case insensitive). Titleizing is just visual cosmetic improvement for file names. This utility can be used to 
 titleize any file names, not only mp3's. The internal id3 metadata are not affected by titleizing.    


Hope it helps ...


**keywords**: mp3, diacritics, locale, encoding, code-page, file-system, rename, titleize, rename, ASCII

