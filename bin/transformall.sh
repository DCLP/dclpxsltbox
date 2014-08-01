#! /bin/bash
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
function error() {
    JOB="$0"              # job name
    LASTLINE="$1"         # line of error occurrence
    LASTERR="$2"          # error code
    echo "ERROR in ${JOB} : line ${LASTLINE} with exit code ${LASTERR}"
    exit 1
}
trap 'error ${LINENO} ${?}' ERR

if (( $#==1 )); then
	cd $1
elif (( $#>1 )); then
	echo "too many arguments; expected 1"
	exit
elif (( $#<1 )); then
	echo "no top-level directory specified"
	echo "usage: transformall.sh absolute/or/relative/path/to/top/level/working/directory"
	exit
fi

set -x #echo on

cd dclpxsltbox
git checkout master
./bin/2html.sh ..
git status
cd tests
python test_regression.py
