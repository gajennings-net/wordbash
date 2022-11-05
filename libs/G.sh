# LIB G - pages document database
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

declare -a Gl

G() {
local cmd arg dat
cmd=$1
arg=$2
dat=$3

case $cmd in
n)
	D n $Gd $arg
	Gn=$Dn
	;;
l)
	D l $Gd $arg
	Gl=(${Dl[@]})
	;;
h|r|R)
	D $cmd $Gd $arg
	;;
p|P)
local r
	D r $Gd $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	D t
	H e gg
	;;
*)
	return 8
	;;
esac

return 0
}
