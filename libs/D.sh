# LIB D - extensible document database; common code for P and G
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

declare -a Dl Dh
declare Dn Dr

DTTL=0
DDAT=1
DCAT=2
DTAG=3

De=([1]="arg missing" [2]="not found" [3]="could not delete" \
    [4]="maximum reached" [5]="could not write" [6]="no data" \
    [7]="headers error" [8]="invalid command" [9]="could not move")

# date
dd() {
	date "$DDFM"
}

# check
dc() {
	if [[ -z $2 ]]; then
		return 1
	fi
	if [[ ! -f $1/$2 ]]; then
		return 2
	fi
}

# reverse
dv() {
local a i n
	n=${#Dl[@]}
	if [[ $n -gt 1 ]]; then
		for i in ${Dl[@]}; do
			a[--n]=$i
		done
		Dl=(${a[@]})
	fi
}

#sort
ds() {
local i n r t
	n=${#Dl[@]}; (( --n ))
	while [ $n -gt 0 ]; do
		t=0
		for (( i=0; i<$n; i++ )); do
			if [[ ${Dl[i]} -gt ${Dl[i+1]} ]]; then
				 r=${Dl[i]}
				 Dl[i]=${Dl[i+1]}
				 Dl[i+1]=$r
				 t=$i
			 fi
		done
		n=$t
	done
}

#number
dn() {
local r
	Dn=0
	if [[ $2 == "t" ]]; then
		r=($1/.[[:digit:]]*)
	else
		r=($1/*)
	fi
	if [[ $r ]]; then
		Dn=${#r[@]}
	fi
}

#list
dl() {
local p
	Dl=($1/*)
	Dl=(${Dl[@]#$1/})
	ds
	if [[ $2 == "n" ]]; then
		Dn=${Dl[@]:(-1)}
		(( ++Dn ))
		return
	elif [[ $2 ]]; then
		if [[ $2 -lt 0 ]]; then
			if [[ -$2 -lt ${#Dl[@]} ]]; then
				Dl=(${Dl[@]:$2})
				dv
			fi
		elif [[ $2 -lt ${#Dl[@]} ]]; then
			Dl=(${Dl[@]:0:$2})
		fi
	fi
	Dn=${#Dl[@]}
}

# read
dr() {
local r
	dc $1 $2; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	Dr=$(< $1/$2)
	I=$IFS; IFS=$'\n'
	Dh=(${Dr%%$'\n'$'\n'*})
	IFS=$I
}

# header
dh() {
local l i r
set -f
	i=$DTTL
	r=
	while read -r l; do
		if [[ "$l" == $'\n' ]]; then
			break
		fi
		Dh[$i]=$l
		(( ++i ))
	done < "$1/$2"
set +f
}

# translate
dt() {
	for (( i=0; i<${#Tt[@]}; i+=2 )); do
		title=${title//${Tt[i]}/${Tt[i+1]}}
	done
	for (( i=0; i<${#Tp[@]}; i+=2 )); do
# see readme.txt NOTE 1
		body=${body//${Tp[i]}/${Tp[i+1]}}
#		body=$(br "${Tp[i]}" "${Tp[i+1]}" "$body")
	done
}

D() {
local cmd arg dat
cmd=$1
arg=$2
dat=$3

case $cmd in
d)
	dd
	;;
c)
	dc $arg $dat
	;;
n)
	dn $arg $dat
	;;
l)
	dl $arg $dat
	;;
t)
	dt "$arg"
	;;
h)
	dh $arg $dat
	title=${Dh[DTTL]}
	date=${Dh[DDAT]}
	;;
r|R)
local r
	dc $arg $dat; r=$?
	if [[ $r -ne 0 ]]; then
		return $r
	fi
	dr $arg $dat
	if [[ $cmd == "r" ]]; then
		body=${Dr#*$'\n'$'\n'}
		title=${Dh[DTTL]}
		date=${Dh[DDAT]}
	fi
	;;
e)
local s
	s=${De[$arg]}
	if [[ -z $s ]]; then
		s="err: $arg"
	fi
	echo "$s"
	;;
esac
	return 0
}
