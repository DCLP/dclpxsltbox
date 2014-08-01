#! /bin/bash

if (( $#==1 )); then
    cd $1
elif (( $#>1 )); then
	echo "too many arguments; expected 1"
	exit
elif (( $#<1 )); then
	echo "no top-level directory specified"
	echo "usage: pullall.sh absolute/or/relative/path/to/top/level/working/directory"
	exit
fi

set -x #echo on

cd idp.data
git checkout dclp
git pull origin dclp
cd ../navigator
git checkout xslt-master
git pull origin xslt-master
cd ../xsugar
git checkout master
git pull origin master
cd ../dclpxsltbox
git checkout master 
git pull origin master
git checkout gh-pages
git pull origin gh-pages
git checkout master
