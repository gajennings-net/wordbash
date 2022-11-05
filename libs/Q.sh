# LIB Q - server http/cgi data management; Apache/RFC3875
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, Greg Jennings - see license.txt

set -f

Qc="_"
Qf="[[:punct:] ]"
QBUF=2000

if [[ $REQUEST_METHOD == "POST" ]]; then
	if [ $CONTENT_LENGTH -gt 0 ]; then
		read -n $CONTENT_LENGTH POST_STRING <&0
	fi
fi

QUERY_STRING=${QUERY_STRING//+/ }
QUERY_STRING=${QUERY_STRING//\%/\\x}
if [[ ${#POST_STRING} -lt $QBUF ]]; then
	POST_STRING=${POST_STRING//+/ }
	POST_STRING=${POST_STRING//%0D/}
	POST_STRING=${POST_STRING//%/\\x}
else
	POST_STRING=`echo "$POST_STRING" | $sed -e '
s/+/ /g
s/%0D//g
s/%/\\\\x/g
'`
fi
# NOTE: The above use of SED is not "Pure Bash", I know. But, extensive testing, 
#       though only using Cygwin, resulted in the pure Bash way - when POST 
#       data size is less than a guessed at by trial and error number just Bash 
#       is used - as being very Sa-Low! Significantly so.

HTTP_COOKIE=${HTTP_COOKIE// /}
HTTP_COOKIE=${HTTP_COOKIE//+/ }

I=$IFS
IFS='&'
for q in $QUERY_STRING; do
	for a in ${Qa[@]}; do
		if [[ ${q%=*} == $a ]]; then
			q=$(echo -ne "${q#*=}")
			q=${q//$Qf/}
			declare "$a=$q"
			break
		fi
	done
done

for q in $POST_STRING; do
	for a in ${Qa[@]}; do
		if [[ $q == $a* ]]; then
			q=$(echo -ne "${q#*=}")
			declare "$a=$q"
			break
		fi
	done
done

IFS=';'
for c in $HTTP_COOKIE; do
	declare "$Qc$c"
done

IFS=$I

set +f

unset a c q Qc Qf
unset QUERY_STRING POST_STRING HTTP_COOKIE
