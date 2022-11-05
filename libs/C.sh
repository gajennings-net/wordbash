# LIB C - comments hierarchical document database
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

declare -a Cl Ch
declare Cb Ck Cn Cp Cr

CFRM=0
CDAT=1
CHSH=2
CWRD=26
CWRE="[^[:word:]._ ]"

Ce=([1]="arg missing" [2]="not found" [3]="maximum reached" \
    [4]="could not delete" [5]="could not write" [6]="no data" \
    [7]="comment rejected due to invalid data" \
    [8]="names must less than $CFLN characters" \
    [9]="names must be alpha-numeric (spaces, '.' and '_' allowed)" \
    [10]="comment exceeds $CSIZ character limit" \
    [11]="invalid command" \
    [12]="duplicate comment")

# check
cc() {
	if [[ -z $1 ]]; then
		return 1
	fi
	if [[ ! -d $Cd/$1 ]]; then
		return 2
	fi
}

# number
cn() {
local c
	if [[ ! -d $Cd/$1 ]]; then
		Cn=
	else
		c=($Cd/$1/*)
		if [[ ! $c ]]; then
			Cn=0
		else
			Cn=${#c[@]}
		fi
	fi
}

# list
cl() {
local c
	if [[ ! -d $Cd/$1 ]]; then
		Cl=
		Cn=
		return
	fi
	c=($Cd/$1/*)
	if [[ ! $c ]]; then
		Cl=
		Cn=0
		if [[ $2 == "n" ]]; then
			Cn=1
		fi
	else
		Cl=${c[@]#$Cd/$1/}
		Cl=($(bs "$Cl"))
		Cn=${#Cl[@]}
		if [[ $2 == "n" ]]; then
			Cn=${Cl[@]:(-1)}
			(( ++Cn ))
		fi
	fi
}

# strip
cs() {
local r t
	t=0
	r=
	I=$IFS; IFS=$'\n'
	while read -r -n 1 c; do
		if [[ $c == ">" ]]; then t=0; continue; fi
		if [[ $t == 1 ]]; then continue; fi
		if [[ $c == "<" ]]; then t=1; continue; fi
		if [[ -z $c ]]; then c=$'\n'; fi
		r+=$c
	done <<< "$1"
	echo "$r"
	IFS=$I
}

# format
cf() {
local l p r w
set -f
	r=
	p=0
	while read -r l; do
		if [[ "$l" == "" ]]; then
			(( $p )) && r+="</p>"$'\n'"<p>"
			p=0
			continue
		fi
		if [[ $p -eq 1 ]]; then
			r+="<br>"$'\n'
		fi
		l=($l)
		for w in ${l[*]}; do
			r+="${w:0:$CWRD} "
		done
		p=1
	done <<< "$1"
	echo "<p>$r</p>"
set +f
}

# write lock (trivial, and the value in the wait loop is poor programming)
co() {
local i d
	d=$Cd/$1/.l
	if [[ $2 == 1 ]]; then
		mkdir $d
	elif [[ $2 == 0 ]]; then
		rm -rf $d
	else
		i=0
		while [ -f $d ]; do
			if (( ++i > 100 )); then
				break;
			fi
		done
	fi
}

# recent
ct() {
local c n
	if [[ $1 == "r" ]]; then
		c=($(< $Cc))
		c=(${c[@]#$Cd/})
		n=${#c[@]}
		if [[ $n > $CRNT ]]; then
			Cl=(${c[@]: -$CRNT:$CRNT})
		else
			Cl=(${c[@]})
		fi
		return
	fi
	echo "$1" >> $Cc
}

# checksum
ck() {
local c k
	if [[ $2 ]]; then
		cl $3
		for c in ${Cl[*]}; do
			cr $3/$c
			k=${Ch[CHSH]}
			if [[ "$2" == $k ]]; then
				return 1
			fi
		done
		return 0
	fi
	Ck=$(echo -n $1 | md5sum)
	Ck=${Ck%% *}
}

# read
cr() {
	Cr=$(< $Cd/$1)
	I=$IFS; IFS=$'\n'
	Ch=(${Cr%%$'\n'$'\n'*})
	Cb=${Cr#*$'\n'$'\n'}
	IFS=$I
}

# write
cw() {
	local d dat
	d=$(D d)
	dat=$2$'\n'$d$'\n'$3$'\n'$'\n'$4
	co $1
	co $1 1
	cl $1 n
	echo "$dat" > $Cd/$1/$Cn
	co $1 0
	if [[ ! -f $Cd/$1/$Cn ]]; then
		return 5
	fi
	ct $Cd/$1/$Cn
}

C() {
local cmd arg dat
local a c h i n r 
cmd=$1
arg=$2
dat=$3

case $cmd in
cc)
	cc $arg
	return
	;;
d)
	echo $Cd/$arg
	;;
D)
	[ -f $Cd/$arg ]
	return
	;;
t)
	ct r
	;;
n)
	cn $arg
	;;
l)
	cc $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	cl $arg
	;;
r|R)
	if [[ ! -f $Cd/$arg ]]; then
		return 2
	fi
	cr $arg
	if [[ $cmd == "r" ]]; then
		body=$Cb
		from=${Ch[CFRM]}
		date=${Ch[CDAT]}
	fi
	;;
+)
	cc $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	cn $arg
	if [[ $Cn -ge $CMAX ]]; then
		Cp=0
	else
		Cp=1
	fi
	;;
p)
local ht
	cc $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	cl $arg
	if [[ ! $Cn ]]; then
		return 0
	fi
	ht=cm
	i=1
	for c in ${Cl[@]}; do
		cr $arg/$c
		if [[ $i -eq $Cn && $r -eq 0 ]]; then
			ht=cl
		fi
		H $ht "${Ch[CFRM]}" "${Ch[CDAT]}" "$Cb" $c
		(( i++ ))
	done
	;;
a)
local d f w
	cc $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	cl $arg n
	if [[ $Cn -ge $CMAX ]]; then
		return 3
	fi
	f=$dat
	if [[ -z $f ]]; then
		f=$CFDF;
	else
		if [[ ${#f} -gt $CFLN ]]; then
			return 8
		fi
		if [[ "$f" == *$CWRE* ]]; then
			return 9
		fi
	fi
	dat=$4
	if [[ ${#dat} -gt $CSIZ ]]; then
		return 10
	fi
	if [[ $Cw ]]; then
		for w in "${Cw[@]}"; do
			if [[ "$dat" != "${dat/$w}" ]]; then
				return 7
			fi
		done
	fi
	dat=$(cs "$dat")
	if [[ -z $dat ]]; then
		return 6;
	fi
	if (( CAMP )); then
		dat=${dat//&/&amp;}
	fi
	dat=$(cf "$dat")
	ck "$dat"
	ck "$dat" $Ck $arg; r=$?
	if [[ $r -ne 0 ]]; then
		return 12
	fi
	cw $arg "$f" $Ck "$dat"
	;;
h)
	local f
	f="meta/help/C.txt"
	if [[ -f $f ]]; then
		$pager $f
	else
		echo -e "\nhelp file $f not found\n"
	fi
	;;
e)
local s
	s=${Ce[arg]}
	if [[ -z $s ]]; then
		s="err: $arg"
	fi
	echo "$s"
	;;
*)
	return 11
	;;
esac

return 0
}
