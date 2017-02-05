#!/usr/bin/env bash
:

# =============================================
# titleize file names
# =============================================
#
# USAGE: see usage help bellow
# =============================================

# version
#
VER='2016.10'

# dry run (default no) - just show what would be done
#
DRY=

# status strings shown
#
ERR='[ ERR ]'
OK='[ OK ]'

# header (c) string
#
H="= Titlelize filenames = (c) $VER CLI version by Robert ="

# without any pars show usage help
#
[ $# -lt 1 ] && cat <<< """
    $H

    usage: $(basename $0) [-n] SRC [SRC2, SRC3, ...]

    -n         ... dry run, no action is taken, just show what would be done
    SRC        ... source file(s) (use bash expansion for multiple files)
    SRC2       ... optional another file(s) (use bash expansion for multiple files)

    Example: 'this is a test.mp3' will be renamed to 'This Is A Test.mp3'

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
    # dry run
    #
    [[ $f == -n ]] && DRY=1 && continue

    # split name to dir name ext
    #
    ext=${f##*.}
    name=$( basename "$f" .$ext )
    dir=$( dirname "$f" )/ && [[ $dir == ./* ]] && dir=${dir##./}

    #echo "DBG: file($f) -> dir($dir) name($name) ext($ext)"

    # prepare new name
    #
    new=$dir$( echo "$name" | sed -e 's/\(\w\+\)/\L\u\1/g' ).$ext

    # dry run
    #
    [[ $DRY ]] && echo "'$f' -> '$new'" && continue

	# rename
	#
	stat="$ERR" && mv -v "$f" "$new" |&  sed -e 's/mv: //' | tr -d "\n" && stat="$OK" && ((CNT++))

	# rename status
	#
	echo " $stat"
}

# footer
#
echo "= Done: $CNT filename(s) Titleized ="
