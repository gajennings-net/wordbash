#!/bin/bash 
# WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt
#
# 1. The lack of comments is by design.
# 2. The lack of the Admin code is because the Coder is...
#

. ./B.sh

if [[ $cmd == "comment" ]]; then
	C a $post "$from" "$data"; rc=$?
	if [[ $rc -eq 0 ]]; then
		S r "?post=$post#last" "from=$from"
		exit 0
	fi
fi

S h
H e hh

if [[ $post || $page || $tag || $cat ]]; then
	H sp
fi


if [[ $page ]]; then
	G p $page; rg=$?
	if [[ $rg -ne 0 ]]; then
		H gn
	fi
elif [[ $post ]]; then
	P P $post; rp=$?
	if [[ $rp -ne 0 ]]; then
		H pn
		H e ff
		exit 0
	fi
	C n $post
	if [[ -z $Cn ]]; then
		H cn
	else
		n="s"
		[ $Cn -eq 0 ] && cn=No
		[ $Cn -eq 1 ] && n=""
		H ch $Cn "$n"
	fi
	C p $post
	if [[ $rc -ne 0 ]]; then
		H ce "$(C e $rc)"
	fi
	C + $post
	if [[ $Cn && $Cp == 1 ]]; then
		if [[ -z $from && $_from ]]; then
			from=$_from
		fi
		H e cf
	elif [[ $Cp == 0 ]]; then
		H cx
	else
		H cc
	fi
# this section will be changed as there IS a better way
else
	W
	if [[ $tag ]]; then
		P tl $tag
		H ha $tag "$Pts"
	elif [[ $cat ]]; then
		P cl $cat
		H hc $cat "$Pcs"
	else
		P l
	fi
	if [[ ! $Pl ]]; then
		if [[ $Pt ]]; then
			H pt
		elif [[ $Pc ]]; then
			H pc
		else
			H pn
		fi
	else
		B s
		H nv
		for p in ${Pl[@]}; do
			P p $p
		done
	fi
fi

# and done
H e ff
B e

times

exit 0
