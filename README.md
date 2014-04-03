Sandbox for experimenting with DCLP/PN XSLT stuff

data/
=====

This is a hard copy (no linkage) of the prototype DCLP XML data files (https://github.com/papyri/idp.data/tree/dclp/DCLP), made on 3 April 2014.


xslt/
=====

XSLT files we want to play with, including:

quickview/
----------

Creates a single HTML tabular view of all the DCLP XML files you can point it to. Run like:

  saxon -xsl:xslt/quickview/quickview.xsl -o:output/quickview.html -it:START datadir="$PWD/data"
  
