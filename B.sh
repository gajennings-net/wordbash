# B - base/basic site wide configuration data (and several support functions)
# WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

shopt -s nullglob

# environment globals (used for interactive mode)
pager=less

# Base globals
Bv="1.0.3"
Bl=./libs
Bm=./meta
Bc=$Bm/cats
Bt=$Bm/tags
Br=$Bm/.roll
Bs=${SCRIPT_NAME%/*}

# Post globals
PRNT=2
PMAX=100
PNUM=5
PREV=
Pd=$Bm/psts
Pa=$Bm/arch

# paGe globals
GRNT=2
GMAX=100
Gd=$Bm/pags

# Database globals
DDFM="+%b %-e, %Y %R%p"

# Comment globals
CAMP=1
CRNT=4
CMAX=20
CSIZ=6000
CFLN=32
CFDF=Anonymous
Cd=$Bm/cmts
Cc=$Cd/.cmts
CP=cp.sh
# see cf.ch
Cw=()

# post Translations (see cf.sh)
Tt="& &amp; \" &quot;"
Tt=($Tt)
Tp=()

# Theme dir (yep)
Td=them/wp

# Server globals
Sd=30
Sn=${0##*/}

# allowed QUERY/POST_STRING data
Qa=(post page tag cat cmt from data cmd arg start)

# referenced by the ('site') theme HTML
sitebase=$Bs
sitehost="http://$HTTP_HOST$Bs/$Bn"
siteurl="http://$HTTP_HOST$REQUEST_URI"
sitedesc="Syntagmatic Personal Publishing Platform"
sitename="WordBash"
sitetitle="The WordPress clone written in GNU Bash"

# configuration file
if [[ -f cf.sh ]]; then
	. ./cf.sh
fi

# array reverse
bv() {
local a b i j
	a=($1)
	j=${#a[@]}
	for i in "${a[@]}"; do
		b[--j]=$i
	done
	echo "${b[@]}"
}

# Algorithm B (Bubble sort), Knuth Vol. 3, page 107
bs() {
local a j n r t
	a=($1)
	n=${#a[@]}; (( --n ))
	while [ $n -gt 0 ]; do
		t=0
		for (( j=0; j<$n; j++ )); do
			if [[ ${a[j]} -gt ${a[j+1]} ]]; then
				 r=${a[j]}
				 a[j]=${a[j+1]}
				 a[j+1]=$r
				 t=$j
			 fi
		done
		n=$t
	done
	echo "${a[@]}"
}

# in array
bi() {
local i t
	i=0
	for t in $2; do
		if [[ $t -eq $1 ]]; then
			echo "$i"
			return
		fi
		(( ++i ))
	done
	echo ""
}

# string replace
br() {
local l r
	r=
	while read -r l; do
		r+=${l//$1/$2}$'\n'
	done <<< "$3"
	echo "$r"
}

# htmlentities
be() {
local s
	s=${1//&/&amp;}
	s=${s//\</&lt;}
	s=${s//\>/&gt;}
	if [[ $2 ]]; then
		s=${s//\"/&quot;}
		s=${s//\'/&#039;}
	fi
	echo "$s"
}

# include "library" code
for s in $Bl/*.sh; do
	. $s
done
unset s

# include HTML (theme) templates
. ./$Td/ht.sh

# the B "class"
B() {

case $1 in
s)
	${start:=0}
	if [[ $start -gt ${#Pl[@]} ]]; then
		start=0
	fi
	Pl=(${Pl[@]:$start:$PNUM})
	if [[ $PREV ]]; then
		Pl=($(bv "${Pl[*]}"))
	fi
	;;
# not used yet
e)
	d=
	for a in ${debug[@]}; do
		if [[ ${!a} ]]; then	
			d+="$s${!a}"
			s=", "
		fi
	done
	H div "$d"
	;;
v)
	echo "WordBash v$Bv"
	;;
esac
}

if [[ "$PS1" ]]; then
	echo -e "\nWelcome to WordBash v$Bv interactive."
	echo -e "Use the \E[31mhelp\E[37m command learn the code.\n"
fi

help() {
local m h
	m=($Bl/*)
	m=(${m[@]#$Bl/})
	m=(${m[@]%.sh})
	echo -e "\nModules: ${m[@]}\n"
	echo -e "[module] h - list module commands/data\n"
	echo -e "\n(more to come)\n"
}

# END
