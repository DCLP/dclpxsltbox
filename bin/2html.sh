#! /bin/bash
set -x #echo on


if [ "$#" -ne 1 ]
then
  echo "Usage: 2html {path/to/working/directory/that/contains/dclpxsltbox/}"
  exit 1
fi
abspath=$(unset CDPATH && cd "$(dirname "$1")" && echo $PWD/$(basename "$1"))
echo $abspath
java -jar $1/dclpxsltbox/bin/claxon-1.0.0-SNAPSHOT-standalone.jar --xsl $1/navigator/pn-xslt/MakeHTML.xsl --dir $1/idp.data/DCLP/ --out $1/dclpxsltbox/output/dclp/ --ext .html collection dclp analytics no cssbase '../../css' jsbase '../../js' path "$abspath/idp.data"
