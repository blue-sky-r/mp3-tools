#!/bin/bash

# ===========================
# check MP3 file(s) integrity
# ===========================
#
# REQUIRES: mpg123
#
# USAGE: see usage help bellow
# ============================

# version
#
VER='2016.10'

# status strings shown in survey mode only
#
ERR='[ ERR ]'
OK='[ OK ]'

# max length of error msg excerpt in survey mode only
#
ERRLEN=25

# mpg123 - utility to verify mp3 integrity
#
mpeg123=$( which mpg123 )

# mpg123 version or error message if not found
#
mpeg123ver="$ERR mpg123 not found !"
[[ $mpeg123 ]] && mpeg123ver=$( $mpeg123 --version )

# header (c) string
#
H="= MP3 integrity checker $VER = $mpeg123ver = (c) $VER CLI version by Robert ="

# without any src show usage help
#
[ $# -lt 1 ] && cat <<< """
    $H

    usage: $(basename $0) SRC [SRC2, SRC3, ...]

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

    Note: checking huge number of mp3 files could take a long time
""" && exit 1

# right pad file name so status/error message is shown on the right side
# pad = terminal columns - fixed text - error msg excerpt - right border
pad=$(( $(tput cols)-16-$ERRLEN-2 ))

# checked files counter
#
cnt=0

# timestamp to calc duration
#
sec=$( date +%s )

# header
#
echo "$H"
echo

# exit if required mpeg123 was not found
#
[[ ! $mpeg123 ]] && exit 2

# iterate all parameters as sources
#
for src in "$@"
{
    # DIR -> survey mode
    #
    if [[ -d $src ]]
    then
        echo "SURVEY: ${src}"; echo "======="

        # iterate all files in dir and subdirs
        #
        while read -r -d $'\0' mp3
        do
            ((cnt++))

            printf "%-*.*s" $pad $((pad-1)) "$mp3"
            #
            err=$( $mpeg123 -t "$mp3" |& grep -Eo "error:.{,$ERRLEN}" | head -1 )
            #
            [ ! "$err" ] && echo "$OK"
            [   "$err" ] && echo "$ERR $err.."

        done < <( find "${src}" -type f -iname "*.mp3" -print0 )
    fi

    # FILE -> detail mode
    #
    if [[ -f $src ]]
    then
        echo "DETAIL: ${src}"; echo "======="

        ((cnt++))

        $mpeg123 -vt "$src" 2>&1

        echo
    fi
}

# calc duration in seconds (now - start)
#
sec=$(( $(date +%s) - sec ))

# footer
#
echo
echo "= DONE @ $(date +%c) = $cnt file(s) checked in $sec sec = $(date -d@$sec -u +%Hh:%Mm:%Ss) ="
