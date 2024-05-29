# WordBash
## WordPress Clone Written in Bash

**This is just getting started and is currently (5 Nov 2022) not complete.**

### WordBash is 1,200 lines of Bash code that looks just like *WordPress*

>I wrote this code in order to learn BASH. And I really enjoyed doing so, 
>having created something indistinguishable from WordPress in 1,200 lines
>of BASH code. I never got around to releasing the Admin code - sorry for 
>that. Some people prefer multi-megabyte, massive code full of bells and 
>whistles and social media stuff - if that is you your thinking, don't use 
>*WordBash*, it ain't for you.

Has been tested with *Linux*, *OS-X* and *Windows/Cygwin* and *Bash 3.2* and 
higher. It is a **CGI** script and has only been tested with *Apache*.

Please note that this is just a "first release" and lacks many features 
normally found in *WordPress*. There are also some things that may look hastily 
designed, and there are some things that may look unfinished, the result of 
"reduction" to make this code as small as possible. (It's kinda "Planned 
Obsolescence", but not exactly...)

**The code is weird.** And I make the claim that it is **Object Oriented**.

## INSTALL

Needs to be installed the ancient way: download the archive and unzip into a 
web-server directory. Then check file permissions and the *Apache* `.htaccess` 
file, and then see if it runs. (If not, it's a setup thing... or a The Coder 
screwed up thing...)

## Oh, Wait...

The core premise of WordBash, the question of, "What is the absolute minimum required to read/write a post?" Obviously, that is a file. (And lest anyone protest, a "database" is a file—albeit multiple files—as it cannot be anything else. Using fancy words like "cloud" and "distributed" ain't changing nothing.)

So, if a post is a file, the read can be as simple as:

    $(< $file)

But of course only if the file is stored formated with HTML, like by using a javascript rich text editor.

But the other things required is some meta-data like post title, date, author etcetera. That is usually part of the database schema:

    CREATE TABLE poost (
      ID INTEGER,
      Name CHAR(40),
      Title CHAR(200),
      Date DATE,
      PRIMARY KEY (ID)
    )
Okay, fine. But, WTF? How about that RFC stuff? Since, like, what, 1977? Yeah. That shit.

    name:C.B.Jones
    title:Download
    date:May 21, 2024
    
    <h2>WordBash is a Bash Shell Script</h2>
    ...
Of course, I'm even dumber than that. I do:

    Download
    May 21, 2024

    <h2>WordBash is a Bash Shell Script</h2>
    ...
Cause name is always just mine, and like first come first server order (deny, allow!) first line is title, second is date, and a blank line terminates headers and then starts the body.

And, of course, that can be done in Bash in just a few lines! Fuck! Ain't this shit cool! It's not unlike something like this:

    Dr=$(< $dir/$file)
    I=$IFS; IFS=$'\n'
    Dh=(${Dr%%$'\n'$'\n'*})
    IFS=$I

Or how 'bout something really lame like this:

    while read -r l; do
        if [[ "$l" == $'\n' ]]; then
            break
        fi
        Dh[$i]=$l
        (( ++i ))
    done < "$1/$2"

Yeah, I guess it's just me. We really need a fucking structured query language to do anything like this. Yeah.
