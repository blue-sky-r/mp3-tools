#!/bin/bash

# =============================================
# remove diacritical characters form file names
# =============================================
#
# REQUIRES: iconv
#
# USAGE: see usage help bellow
# =============================================

# version
#
VER='2016.10'

# source encoding
#
SRC_ENC="UTF-8"

# destination encoding
#
DST_ENC="US-ASCII"

# dry run (default no) - just show what would be done
#
DRY=

# status strings shown
#
ERR='[ ERR ]'
OK='[ OK ]'

# iconv - encoding converter
#
ic=$( which iconv )

# iconv version or error message if not found
#
icver="$ERR iconv not found !" && [[ $ic ]] && icver=$( $ic --version | head -1 )

# header (c) string
#
H="= Remove Diacritic from filenames = $icver = (c) $VER CLI version by Robert ="

# without any pars show usage help
#
[ $# -lt 1 ] && cat <<< """
    $H

    usage: $(basename $0) [-l] [-n] [-from=UTF-8] [-to=US-ASCII] SRC [SRC2, SRC3, ...]

    -l         ... list available encodings
    -n         ... dry run, no action is taken, just show what would be done
    -from=ENC  ... optional source encoding (default $SRC_ENC)
    -to=ENC    ... optional destination encoding (default $DST_ENC)
    SRC        ... source file(s) (use bash expansion for multiple files)
    SRC2       ... optional another file(s) (use bash expansion for multiple files)

    You can chain multiple [-from -to src] groups, like:

        $(basename $0) -from=UTF-8 -to=CYRILLIC file1.mp3 -from=UTF-16 -to=CP852 file2.mp3 ...

    Parameters are processed in the order specified on the command line, so the last value wins, like:

        $(basename $0) -from=UTF-8 -from=UTF-16 file.mp3

            will convert from UTF-16 (the last one wins) to default US-ASCII.

        $(basename $0) -from=UTF-16 file1.mp3 -to=CP852 file2.mp3 ...

            will convert file1.mp3 UTF-16 -> US-ASCII and then file2.mp3 UTF-16 -> CP852

    Note: renaming the file will not change any id3 metadata stored inside the file itself
""" && exit 1

# file counter
#
CNT=0

# set exit code to the first non-zero pipe exit code
#
set -o pipefail

# header
#
echo "$H"

# process cli pareameters
#
for f in "$@"
{
    # list encodings
    #
    [[ $f == -l ]] && $ic -l | tr -d '//' && continue

    # dry run
    #
    [[ $f == -n ]] && DRY=1 && continue

    # src encoding
    #
    [[ $f == -from=* ]] && SRC_ENC=${f#-from=} && continue

    # dst encoding
    #
    [[ $f == -to=* ]] && DST_ENC=${f#-to=} && continue

    # split name to dir name ext
    #
    ext=${f##*.}
    name=$( basename "$f" .$ext )
    dir=$( dirname "$f" )/ && [[ $dir == ./* ]] && dir=${dir##./}

    # prepare new name
    #
	new=$dir$( echo "$name" | $ic -f "$SRC_ENC" -t "$DST_ENC//TRANSLIT" ).$ext

    # show action
    #
	echo -en "$SRC_ENC -> $DST_ENC: "

    # dry run
    #
    [[ $DRY ]] && echo "'$f' -> '$new'" && continue

	# rename only if not dry run
	#
	stat="$ERR" && mv -v "$f" "$new" |&  sed -e 's/mv: //' | tr -d "\n" && stat="$OK" && ((CNT++))

	# result status in non-dry mode only
	#
	echo " $stat"
}

# footer
#
echo "= Done: $CNT filename(s) without diacritics ="
