# LIB P - posts document database
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

declare -a Pl Pt Pc
declare Pn Pts Ptc

PMOR='<!--more-->'
PMOT='<span id="more"></span>'
PMOC='Continue reading &rarr;'

P() {
local cmd arg dat aux
cmd=$1
arg=$2
dat=$3
aux=$4

case $cmd in
n)
	D n $Pd $arg
	Pn=$dn
	;;
l)
	D l $Pd $arg
	Pl=(${Dl[@]})
	;;
h|r|R)
	D $cmd $Pd $arg
	;;
v)
	Pl=($(bv "${Pl[*]}"))
	;;
# display a post
# see readme.txt NOTE 2
p|P)
local c h r t ht cat tags
	D r $Pd $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	cat=${Dh[DCAT]}
	if [[ -z $cat || $cat == "-" ]]; then
		cat='default'
	fi
	if [[ ! -d $Bc/$cat ]]; then
		cat='default'
	fi
	cat=$(H ca $cat)
	if [[ ${Dh[DTAG]} && "${Dh[DTAG]}" != "-" ]]; then
		t=
		for c in ${Dh[DTAG]}; do
			t+="<a href=\"?tag=$c\">$c</a>, "
		done
		t=${t%, }
		tags=$(H ta "$t")
	fi
	unset more
	if [[ "$body" == *"$PMOR"* ]]; then
		if [[ $cmd == "p" ]]; then
			body=${body%%$PMOR*}
			more=$PMOC
		else
			body=$(br "$PMOR" "$PMOT" "$body")
		fi
	fi
	D t
	if [[ $cmd == "P" ]]; then
		ht='ps'
	else
		C n $arg
		if [[ -z $Cn ]]; then
			ht='pc'
		else
			ht='pp'
			c='#comment'
			r='Leave a reply'
			if [[ $Cn -gt 0 ]]; then
				c='#comments'
				if [[ $Cn -eq 1 ]]; then
					r='1 Reply'
				else
					r="$Cn Replies"
				fi
			fi
			C + $arg
			if [[ ! $Cp ]]; then
				c='#comments'
				r='Comments'
			fi
		fi
	fi
	H e $ht
	;;
# tag list
tl)
local d
	Pts="&nbsp;"
	d=$Bt/$arg
	if [[ ! $arg || ! -d $d ]]; then
		Pl=
		Pts='Not found.'
		Pt=($Bt/*)
		Pt=(${Pt[@]#$Bt/})
		Pt=$(bs "$Pt")
	fi
	if [[ $arg ]]; then
		dl $d
		Pl=(${Dl[@]})
		if [[ -f $Bt/.$arg ]]; then
			Pts=$(< $Bt/.$arg)
		fi
	fi
	;;
# category list
cl)
local d
	Pcs="&nbsp;"
	d=$Bc/$arg
	if [[ ! -d $d ]]; then
		Pl=; Pc=
		Pcs='Not found.'
	fi
	if [[ $arg ]]; then
		dl $d
		Pl=(${Dl[@]})
		if [[ -f $Bc/.$arg ]]; then
			Pcs=$(< $Bc/.$arg)
		fi
	else
		Pc=($d/*)
		Pc=(${Pc[@]#$d/})
	fi
	;;
*)
	return 8
	;;
esac

return 0
}
