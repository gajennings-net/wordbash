# LIB W - sidebar "widgets"
# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt

# this code belongs in the theme template file... (to be done later)

Wh[0]='<aside id="meta">'
Wh[1]='<h1>$1</h1><ul>'
Wh[2]='<li><span>$4</span><a href="?$1=$2" title="$3">$3</a></li>'
Wh[3]='</ul>'
Wh[4]='</aside>'

wh() {
	H - "${Wh[$1]}" "$2" "$3" "$4" "$5"
}

W() {
local a c n p s t
	wh 0

	G l -$GRNT
	if [[ $Gl ]]; then
		wh 1 "PAGES"
		for t in ${Gl[@]}; do
			G h $t
			wh 2 "page" $t "$title"
		done
		wh 3
	fi

	P l -$PRNT
	wh 1 "RECENT POSTS"
	for t in ${Pl[@]}; do
		P h $t
		wh 2 "post" $t "$title"
	done
	wh 3

	C t
	if [[ $Cl ]]; then
		wh 1 "RECENT COMMENTS"
		for t in ${Cl[@]}; do
			p=${t%/*}
			c=${t#*/}
			C D $p/$c; r=$?
			if [[ $r -eq 0 ]]; then
				C r $p/$c
				P r $p
				wh 2 "post" "$p#$c" "$title" "$from: "
			fi
		done
		wh 3
	fi

	P cl
	if [[ $Pc ]]; then
		wh 1 "CATEGORIES"
		s="title='category: default'"
		echo "<li><a href='?cat=default' $s>default</a></li>"
		for t in ${Pc[@]}; do
			if [[ $t != "default" ]]; then
				s="title='category: $t'"
				echo "<li><a href='?cat=$t' $s>$t</a></li>"
			fi
		done
		wh 3
	fi

	if [[ -f $Br ]]; then
		a=($(< $Br))
		n=${#a[@]}
		wh 1 "BLOG ROLL"
		for (( t=0; t<$n; t+=2 )); do
			if [[ ${a[t]} != http* ]]; then
				a[t]="http://${a[t]}"
			fi
			echo "<li><a href='${a[t]}'>${a[t+1]}</a></li>"
		done
		wh 3
	fi

	wh 4
}
