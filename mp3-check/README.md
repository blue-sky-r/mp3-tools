# What is mp3-check
**mp3-check.sh** is a shell script for checking (frames) integrity of mp3 encoded audio files. 
It launches cli mp3 player [mpg123](https://www.mpg123.de/ "mpg123 Homepage") in test mode to parse all frames of mp3 file looking for any framing or 
id3 metadata errors. The script can process single file(s) in **DETAIL** mode or any directory subtree in **SURVEY** mode.  

SURVEY mode (a.k.a. DIRECTORY mode) is usefull for overview which mp3 files have problems. The files are listed row-wise
with integirity result as '[ OK ]' or '[ ERR ]'. In case of error only the first abreviated error message is shown. For 
full report rerun the check in DETAIL mode. At the end of report the summary (number of checked files and runtime) 
is shown.

DETAIL mode (a.k.a. FILE mode) is used to show all detailed integrity error messages. This mode is usually used for single
 file, however with bash expansion multiple files could be checked in DETAIL mode as well. Fixing the errors is another
 story and other tools could be utilised like kid3 for id3 metadata errors. For framing/sync and junk data errors you can
 use ffmpeg with audio codec 'copy' to recreate frames/headers or just grab source cd again. 
 
__Motivation:_ I was not able to find any simple unix like (a.k.a. command line) tool for checking integrity of my mp3 collection so I have 
written **mp3-check.sh** for my personal use on linux and I have been using it without any issues since then._

Hope it helps ...

#### It does
* locate framing error
* locate id3 metadata error
* locate junk data either at the beginning or at the end of mp3 file

#### It does not
* fix any framing error
* fix any id3 metadata error
* fix any errors

## Usage
Short usage help is shown when script is launched without any parameter:

    usage: mp3-check.sh SRC [SRC2, SRC3, ...]

    SRC  ... source to check (file or directory)
    SRC2 ... optional another source(s) to check

    There are two operational modes: SURVEY and DETAIL:

    SURVEY / DIRECTORY mode outputs mp3 files and their integrity status row wise.
    To activate this mode the source has to be a readable directory.
    All files matching *.mp3 (case insensitive) mask will be checked
    and also all subdirs will be traversed

    DETAIL / FILE mode outputs all details from single mp3 file.
    To activate this mode the source has to be a readable mp3 FILE.

    Recomended usage is to use survey mode first to identify potential problematic files
    and then use detail mode to inspect all error messages shown.

    Note: checking huge number of mp3 files could take a long time`


Some typical usage examples with explanation:

Scan subtree /media/misc for any errors in SURVEY mode:
 
   **$ mp3-check.sh /media/misc**

    = MP3 integrity checker 2016.10 = mpg123 1.16.0 = (c) 2016.10 CLI version by Robert =
    
    SURVEY: ./
    =======
    ./01 - Autobahn.mp3                                        [ OK ]
    ./217 - Something Beautiful Remains.mp3                    [ ERR ] error: No comment text / valid ..
    ./09 - Knowing Me, Knowing You.mp3                         [ OK ]
    ./01 - Autobahn-eof.mp3                                    [ ERR ] error: Giving up resync after 1..
    ./204 Chateau.mp3                                          [ OK ]
    ./104 Furious Angel.mp3                                    [ OK ]
    
    = DONE @ Thu 24. november 2016, 17:59:05 CET = 6 file(s) checked in 7 sec = 00h:00m:07s =


Scan file "/media/01 - Autobahn-eof.mp3" for all errors in DETAIL mode:

   **$ mp3-check.sh "/media/01 - Autobahn-eof.mp3"**

    = MP3 integrity checker 2016.10 = mpg123 1.16.0 = (c) 2016.10 CLI version by Robert =
    
    DETAIL: 01 - Autobahn-eof.mp3
    =======
    High Performance MPEG 1.0/2.0/2.5 Audio Player for Layers 1, 2 and 3
            version 1.16.0; written and copyright by Michael Hipp and others
            free software (LGPL) without any warranty but with best wishes
    Decoder: SSE
    
    Playing MPEG stream 1 of 1: 01 - Autobahn-eof.mp3 ...
    
    MPEG 1.0, Layer: III, Freq: 44100, mode: Joint-Stereo, modext: 3, BPF : 417
    Channels: 2, copyright: No, original: Yes, CRC: No, emphasis: 0.
    Bitrate: 128 kbit/s Extension value: 0
    Title:   Autobahn                        Artist: Kraftwerk
    Album:   Autobahn
    Year:    1974                            Genre:  Electronic,
    Frame# 52136 [   21], Time: 22:41.92 [00:00.54], RVA:   off, Vol: 100(100)
    Note: Illegal Audio-MPEG-Header 0x00000000 at offset 21888744.
    Note: Trying to resync...
    Note: Skipped 1024 bytes in input.
    [parse.c:1162] error: Giving up resync after 1024 bytes - your stream is not nice... (maybe increasing resync limit could help).
    [mpg123.c:690] error: ...in decoding next frame: Failed to find valid MPEG data within limit on resync. (code 28)
    Frame# 52137 [   17], Time: 22:41.94 [00:00.44], RVA:   off, Vol: 100(100)
    [22:41] Decoding of 01 - Autobahn-eof.mp3 finished.

    = DONE @ Thu 24. november 2016, 17:33:56 CET = 1 file(s) checked in 3 sec = 00h:00m:03s =
 
Scan multiple files for errors in DETAIL mode (use any bash expansion):
 
   **$ mp3-check.sh /media/*.mp3**
 
## Dependencies
mp3-check requires [mpg123](https://www.mpg123.de/ "mpg123 Homepage"). Installed and active version of mpg123 is shown in header (version 1.16.0):

    ... = mpg123 1.16.0 = ...

The following error message is shown (instead of version) in case if mpg123 cannot be launched:

    ... = [ ERR ] mpg123 not found ! = ...
 
In this case install mpg123 via your favorite packaging system.

## Configuration
configuration options (variables) are located at the beginning of the script with short description:

Default values should be ok in the most cases:

    # status strings shown in survey mode only
    #
    ERR='[ ERR ]'
    OK='[ OK ]'
    
    # max length of error msg excerpt in survey mode only
    #
    ERRLEN=25

You can use ERR string as a mask for grep to extract only files with any errors:

    $ mp3-check /media/ | grep '\[ ERR \]' 

## Report
All reporting is done to the terminal to STDOUT. To get file use standard unix redirection of STDOUT to file

    $ mp3-check /media > report.txt

#### History
 version 2016.10 - the initial GitHub release in 2017

_keywords:_ mp3, frame, metadata, id3, integrity, error, check, test, verify, analyze, invalid, broken, bash

