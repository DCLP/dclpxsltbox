#! /bin/bash

if [ "$#" -ne 1 ]
then
  echo "Usage: 2html {path/to/dclptestbox}"
  exit 1
fi
java -jar $1/bin/claxon-1.0.0-SNAPSHOT-standalone.jar --xsl $1/xslt/pn-xslt/RDF2HTML.xsl --dir $1/data/ --out $1/output/dclp/ --ext .html collection dclp analytics no cssbase '../../css' jsbase '../../js'
