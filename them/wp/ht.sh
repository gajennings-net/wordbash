# Part of WordBash, the WordPress clone written in Bash
# Copyright 2014-2022, GAJennings - see license.txt
# HTML template file to look sort of like WordPress Twenty Eleven theme
# with a few additions

siteimage="$Td/h0.jpg"

Hnv() {
local i
	start=${start:-0}; i=$start
	if (( ${#Dl[@]}-$start > $PNUM )); then
		i=$(( $start+$PNUM ))
	fi
	next="?start=$i"
	i=0
	if (( $start-$PNUM >= 0 )); then
		i=$(( $start-$PNUM ))
	fi
	prev="?start=$i"
	if (( ${#Dl[@]} > $PNUM )); then
		i=$(( ${#Dl[@]} - $PNUM ))
		last="?start=$i"
	fi
	sitelinks=
	if (( $start )); then
		sitelinks+="<a href='./' rel='nofollow' title='home'><img src='$Td/home.png' alt='HOM'><br></a>"
		sitelinks+="<a href='$prev' rel='nofollow' title='previous'><img src='$Td/prev.png' alt='PRE'><br></a>"
	fi
	if (( ${#Dl[@]}-$start > $PNUM )); then
		sitelinks+="<a href='$next' rel='nofollow' title='next'><img src='$Td/next.png' alt='NEX'><br></a>"
		sitelinks+="<a href='$last' rel='nofollow' title='last'><img src='$Td/last.png' alt='END'><br></a>"
	fi
	sitelinks+="<a href='#top' rel='nofollow' title='top'><img src='$Td/top.png' alt='TOP'></a>"
	sitelinks="<div id='links'>$sitelinks</div>"
}

# just another way to do the above in a different style
Hnv1() {
local i nv pv lv
	start=${start:-0}; i=$start
	if (( ${#Dl[@]}-$start > $PNUM )); then
		i=$(( $start+$PNUM ))
	fi
	next="?start=$i"
	i=0
	if (( $start-$PNUM >= 0 )); then
		i=$(( $start-$PNUM ))
	fi
	prev="?start=$i"
	if (( ${#Dl[@]} > $PNUM )); then
		i=$(( ${#Dl[@]} - $PNUM ))
		last="?start=$i"
	fi
	if (( $start == 0 )); then
		pv="style='display:none'"
	fi
	if (( ${#Pl[@]} < $PNUM )); then
		nv="style='display:none'"
	fi
	if (( ${#Pl[@]}-$start < $PNUM )); then
		lv="style='display:none'"
	fi

	sitelinks="<a $pv href='./' rel='nofollow' title='home'><img src='$Td/home.png' alt='HOM'><br></a>
<a $pv href='$prev' rel='nofollow' title='previous'><img src='$Td/prev.png' alt='PRE'><br></a>
<a $nv href='$next' rel='nofollow' title='next'><img src='$Td/next.png' alt='NEX'><br></a>
<a $lv href='$last' rel='nofollow' title='last'><img src='$Td/last.png' alt='END'></a>
"
	sitelinks="<div id='links'>$sitelinks</div>"
}

Hsp() {
	sitelinks="<a href='./' rel='nofollow' title='home'><img src='$Td/home.png' alt='HOM'><br></a><a href='#top' rel='nofollow' title='top'><img src='$Td/top.png' alt='TOP'></a>"
	sitelinks="<div id='links'>$sitelinks</div>"
}

Hpt() {
local t h
	h='<div class="tags">Available tags are:<p>'
	for t in ${Pt[@]}; do
		h+="<a href=&tag=$t>$t</a><br>"
	done
	h+='</div>'
	echo "$h"
}

Hpc() {
local t h
	h='<div class="tags">Available categories are:<p>'
	for t in ${Pc[@]}; do
		h+="<a href=&cat=$t>$t</a><br>"
	done
	h+='</div>'
	echo "$h"
}

i=0
Hh[i++]=

Hhh=$i
Hh[i++]='<!DOCTYPE html>
<html lang="en-US">
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta name="description" content="$sitedesc">
<title>$sitetitle</title>
<link rel="stylesheet" type="text/css" href="$sitebase/$Td/st.css">
</head>
<body id="top">
<header>
<h1><a href="$sitehost" title="$sitetitle">$sitename</a></h1>
<h2>$sitetitle</h2>
<img src="$sitebase/$siteimage" alt="header image" height="190" width="1000">
<nav>
<ul>
<li><a href="$sitehost" title="Home">Home</a></li>
<li><a href="?page=1" title="About">About</a></li>
</ul>
</nav>
</header>
<section id="content">'

Hhc=$i
Hh[i++]='<h1>CATEGORY ARCHIVE: $1</h1>
<h2>$2</h2>'

Hha=$i
Hh[i++]='<h1>TAG ARCHIVE: $1</h1>
<h2>$2</h2>'

Hca=$i
Hh[i++]='<span>Category: <a href="?cat=$1">$1</a> | </span>'

Hta=$i
Hh[i++]='<span>Tagged: $1 | </span>'

Hpi=$i
Hh[i++]='$sitelinks'

Hpp=$i
Hh[i++]='<article>
<h1><a href="?post=$arg" title="Permanent link to $title">$title</a></h1>
<span class="time">Posted on <a>$date</a></span>
$body
<p><a href="?post=$arg#more">$more</a></p>
<footer>
$cat$tags<a href="?post=$arg$c" title="Comment on $title">$r</a>
</footer>
</article>
$sitelinks'

Hpc=$i
Hh[i++]='<article>
<h1><a href="?post=$arg" title="Permanent link to $title">$title</a></h1>
<span class="time">Posted on <a>$date</a></span>
$body
<p><a href="?post=$arg#more">$more</a></p>
<footer>
$cat$tags <em>comments closed</em>
</footer>
</article>
$sitelinks'

Hps=$i
Hh[i++]='<article class="single">
<span class="time">Posted on <a>$date</a></span>
<h1><a href="?post=$arg" title="Permanent link to $title">$title</a></h1>
$body
</article>
$sitelinks'

Hpn=$i
Hh[i++]='<article class="single">
<h1>Post</h1>
<p><b>Not Found</b></p>
</article>'

Hgg=$i
Hh[i++]='<span id="content"></span>
<article class="page">
<h1>$title</h1>
<span class="time">Posted on <a>$date</a></span>
$body
</article>'

Hgn=$i
Hh[i++]='<article class="page">
<h1>Page</h1>
<b>Not Found</b>
</article>'

Hch=$i
Hh[i++]='</section>
<section id="comments">
<div class="cintro">$1 Comment$2</div>'

Hcn=$i
Hh[i++]='</section>
<section id="comments">'

Hcx=$i
Hh[i++]='<div class="cintro">Maximum number of comments reached</div>'

Hcc=$i
Hh[i++]='<div class="cintro">Comments are closed</div>'

Hcm=$i
Hh[i++]='<div class="comment" id="$4">
#$4 <span>$1</span> on <span class="time">$2</span> <span class="says">said:</span>
$3
</div>'

Hcl=$i
Hh[i++]='<span id="last"></span><div class="comment" id="$4">
#$4 <span>$1</span> on <span class="time">$2</span> <span class="says">said:</span>
$3
</div>'

Hce=$i
Hh[i++]='<div class="cerr" id="last">$1</div>'

Hcf=$i
Hh[i++]='<span id="comment"></span>
<form id="cform" class="submit" method="post" action="$sitehost#last">
<div>Leave a Reply</div>
<label for="from">Name</label><input type="text" name="from" value="$from" maxlength="32">
<label for="data">Comment</label><textarea name="data" rows="8">$data</textarea>
<p><strong>Comment length is limited, all HTML will be stripped and <em>do not submit links</em>.</strong></p>
<input type="submit" value="Post Comment">
<input type="hidden" name="cmd" value="comment">
<input type="hidden" name="post" value="$post">
</form>'

Hff=$i
Hh[i++]='</section>
<footer>
<a href="?page=1" title="$sitedesc">$sitename</a> is Powered by <em><a href="http://www.gnu.org/software/bash/">GNU Bash</a></em>
</footer>
</body>
</html>'
