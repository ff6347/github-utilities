    #!/bin/sh
    # create list with the first 7 lines of all scripts in markdown
    # author: @fabiantheblind
    # the headlines are formated to point to github raw files
    # TODO:  
    # make a interface to add raw links right now it points to a fixed location
    # should maybe be a python script

usage="$(basename "$0") [-h] [-p path] -- program to create TOC (table of contents) of a folder

where:
    -h  show this help text
    -n  number of lines to fetch from files
    -p  path to github repository for direct links to raw file e.g.
        https://raw.github.com/fabiantheblind/auto-typo-adbe-id/master/fabiantheblind/"

path=
numlines=7
while getopts :h:p:n: option
do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    p) path=$OPTARG
       ;;
    n) numlines=$OPTARG
       ;;
    :) printf "missing argument for -%p\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%p\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "$usage" >&2
    exit 1
fi


if [ -e "TOC.md" ]; then
    echo "\"TOC.md\" already exists. I will remove it"
    rm TOC.md
fi
numfiles=(*)
numfiles=${#numfiles[@]}
echo "There are $numfiles .jsx / .txt / .sh files in this directory"
#echo ls -l | grep -c "^-.*"
echo "##Autogenerated TOC  " >> TOC.md;
for file in *.{jsx,json,txt,sh}; do
    if [ -e "$file" ]; then
        echo "###[${file}]($path${file})  " >> TOC.md;
        #echo  "  \n" >> TOC.md;
        head -$numlines "${file}" >> TOC.md;
        echo  "" >> TOC.md;
        echo "--------------  " >> TOC.md;
        echo  "" >> TOC.md;
    fi
done
open TOC.md
