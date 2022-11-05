# LIB H - caching factory based HTML template engine
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, Greg Jennings - see license.txt

Hc=
He= # "-e"  # there should be a note here...
Hs=

H() {
local e h i v

case $1 in
--)
	echo "<!-- $2 -->"
	return 0
	;;
v)
	echo "$2='$3'"
	return 0
	;;
-c)
	Hc=
	return 0
	;;
+c)
	Hc+=$2
	return 0
	;;
c)
	echo "$Hc"
	Hc=
	return 0
	;;
\?c|C)
	if [[ -z $Hc ]]; then
		return 1
	fi
	return 0
	;;
+e|+E)
	if [[ $1 == "+E" ]]; then
		h=$2
	else
		h=${Hh[H$2]}
	fi
	h=${h//\"/\\\"}
	eval "Hc+=\"$h\""
	return 0
	;;
e|E)
	if [[ $1 == "E" ]]; then
		h=$2
	else
		h=${Hh[H$2]}
	fi
	h=${h//\"/\\\"}
	eval "e=\"$h\""
	echo $He "$e"
	return 0
	;;
# NOTE: Since eval is used, someone will declare that "Evil". Yeah, well, you 
#       have to look at it first, then test it, extensively, and then tell me 
#       *exactly* why it is bad... (There are ways to do the same thing without 
#       it, just more complicated.)
-)
	h=$2
	shift
	;;
div|p|span)
	h="<$1>$2</$1>"
	shift
	;;
*)
	h=${Hh[H$1]}
	if [[ -z $h ]]; then
		local f
		f=H$1
		f=$(declare -f $f)
		if [[ $f ]]; then
			$f
			return 0
		else
			echo "<p>template not found \`$1'</p>"
			return 1
		fi
	fi
	;;
esac

shift

i=1
for v in "$@"; do
	h=${h//\$$i/$v}
	(( i++ ))
done

echo $He "$h"

Hs=1

return 0
}
