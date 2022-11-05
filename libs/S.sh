# LIB S - http state management; RFC2965/RFC2616
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, Greg Jennings - see license.txt

Ss=
SEXP=30
SDFM="+%a, %d %b %G %T GMT"
Sc[400]="Bad Request"
Sc[403]="Forbidden"
Sc[404]="Not Found"

# expires
se() {
local d
	if [[ $1 == 0 ]]; then
		echo "Expires=Thu, 01 Jan 1970 00:00:01 GMT"
	else
		${Sd:=$SEXP}
		if [[ $1 ]]; then
			Sd=$1
		fi
		d=`date -v +${Sd}d "$SDFM"`
		echo "Expires=$d"
	fi
# NOTE: The use of `date...` is not "Pure Bash", I know. It should be like:
#       printf %(datefmt)T ... (there are not anymore of this)
}

# download
sd() {
local s t st_size
	t=${1#*.}
	case $t in
		txt|sh) t=text/plain ;;
		zip) t=application/zip ;;
		*) return 2 ;;
	esac
	s=($(stat -s $1))
	declare "${s[7]}"
	echo "Content-Type: $t"
	echo "Content-Length: $st_size"
	echo "Content-Disposition: attachment; filename=\"${1#*/}\""
	echo ""
	cat $1
	exit
}

S() {
local cmd arg dat aux
cmd=$1
arg=$2
dat=$3
aux=$4

case $cmd in
r)
local e
	if [[ ${arg:0:1} == "?" ]]; then
		arg=$sitehost$arg
	fi
	if [[ $dat ]]; then
		e=$(se $aux)
		echo "Set-Cookie: ${dat// /+}; $e; Path=$Bs;"
	fi
	echo "Location: $arg"
	echo
	exit
	;;
h)
local t
	if [[ $Ss == 1 ]]; then
		return
	fi
	t=${2:-text/html; charset=UTF-8}
	echo "X-Powered-By: BASH/${BASH_VERSION%(*}"
	echo "Content-Type: $t"
	echo
	Ss=1
	;;
s)
	[ $Ss -eq 1 ]
	return
	;;
p)
	if [[ $ss -eq 0 ]]; then
		S h 'text/plain'
	fi
	echo "$arg"
	;;
d)
	if [[ ! -f $arg ]]; then
		return 1
	fi
	sd $arg
	;;
esac

return 0
}
